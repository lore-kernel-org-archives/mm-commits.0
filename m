From: akpm@linux-foundation.org
Subject: + mm-size-of-quicklists-shouldnt-be-proportional-to-the-number-of-cpus.patch added to -mm tree
Date: Wed, 27 Aug 2008 15:29:35 -0700
Message-ID: <200808272229.m7RMTaEk025997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbYH0W3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Aug 2008 18:29:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, davem@davemloft.net, tokunaga.keiich@jp.fujitsu.com


The patch titled
     mm: size of quicklists shouldn't be proportional to the number of CPUs
has been added to the -mm tree.  Its filename is
     mm-size-of-quicklists-shouldnt-be-proportional-to-the-number-of-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: size of quicklists shouldn't be proportional to the number of CPUs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Quicklists store pages for each CPU as caches.  (Each CPU can cache
node_free_pages/16 pages)

It is used for page table cache.  exit() will increase the cache size,
while fork() consumes it.

So for example if an apache-style application runs (one parent and many
child model), one CPU process will fork() while another CPU will process
the middleware work and exit().

At that time, the CPU on which the parent runs doesn't have page table
cache at all.  Others (on which children runs) have maximum caches.

	QList_max = (#ofCPUs - 1) x Free / 16
	=> QList_max / (Free + QList_max) = (#ofCPUs - 1) / (16 + #ofCPUs - 1)

So, How much quicklist memory is used in the maximum case?

This is proposional to # of CPUs because the limit of per cpu quicklist
cache doesn't see the number of cpus.

Above calculation mean

	 Number of CPUs per node            2    4    8   16
	 ==============================  ====================
	 QList_max / (Free + QList_max)   5.8%  16%  30%  48%

Wow! Quicklist can spend about 50% memory at worst case.

My demonstration program is here
--------------------------------------------------------------------------------
#define _GNU_SOURCE

#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sched.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/wait.h>

#define BUFFSIZE 512

int max_cpu(void)	/* get max number of logical cpus from /proc/cpuinfo */
{
  FILE *fd;
  char *ret, buffer[BUFFSIZE];
  int cpu = 1;

  fd = fopen("/proc/cpuinfo", "r");
  if (fd == NULL) {
    perror("fopen(/proc/cpuinfo)");
    exit(EXIT_FAILURE);
  }
  while (1) {
    ret = fgets(buffer, BUFFSIZE, fd);
    if (ret == NULL)
      break;
    if (!strncmp(buffer, "processor", 9))
      cpu = atoi(strchr(buffer, ':') + 2);
  }
  fclose(fd);
  return cpu;
}

void cpu_bind(int cpu)	/* bind current process to one cpu */
{
  cpu_set_t mask;
  int ret;

  CPU_ZERO(&mask);
  CPU_SET(cpu, &mask);
  ret = sched_setaffinity(0, sizeof(mask), &mask);
  if (ret == -1) {
    perror("sched_setaffinity()");
    exit(EXIT_FAILURE);
  }
  sched_yield();	/* not necessary */
}

#define MMAP_SIZE (10 * 1024 * 1024)	/* 10 MB */
#define FORK_INTERVAL 1	/* 1 second */

main(int argc, char *argv[])
{
  int cpu_max, nextcpu;
  long pagesize;
  pid_t pid;

  /* set max number of logical cpu */
  if (argc > 1)
    cpu_max = atoi(argv[1]) - 1;
  else
    cpu_max = max_cpu();

  /* get the page size */
  pagesize = sysconf(_SC_PAGESIZE);
  if (pagesize == -1) {
    perror("sysconf(_SC_PAGESIZE)");
    exit(EXIT_FAILURE);
  }

  /* prepare parent process */
  cpu_bind(0);
  nextcpu = cpu_max;

loop:

  /* select destination cpu for child process by round-robin rule */
  if (++nextcpu > cpu_max)
    nextcpu = 1;

  pid = fork();

  if (pid == 0) { /* child action */

    char *p;
    int i;

    /* consume page tables */
    p = mmap(0, MMAP_SIZE, PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
    i = MMAP_SIZE / pagesize;
    while (i-- > 0) {
      *p = 1;
      p += pagesize;
    }

    /* move to other cpu */
    cpu_bind(nextcpu);
/*
    printf("a child moved to cpu%d after mmap().\n", nextcpu);
    fflush(stdout);
 */

    /* back page tables to pgtable_quicklist */
    exit(0);

  } else if (pid > 0) { /* parent action */

    sleep(FORK_INTERVAL);
    waitpid(pid, NULL, WNOHANG);

  }

  goto loop;
}
----------------------------------------

When above program which does task migration runs, my 8GB box spends
800MB of memory for quicklist.  This is not memory leak but doesn't seem
good.

% cat /proc/meminfo

MemTotal:        7701568 kB
MemFree:         4724672 kB
(snip)
Quicklists:       844800 kB

because

- My machine spec is
	number of numa node: 2
	number of cpus:      8 (4CPU x2 node)
        total mem:           8GB (4GB x2 node)
        free mem:            about 5GB

- Then, 4.7GB x 16% ~= 880MB.
  So, Quicklist can use 800MB.

So, if following spec machine run that program

   CPUs: 64 (8cpu x 8node)
   Mem:  1TB (128GB x8node)

Then, quicklist can waste 300GB (= 1TB x 30%).  It is too large.

So, I don't like cache policies which is proportional to # of cpus.

My patch changes the number of caches
from:
   per-cpu-cache-amount = memory_on_node / 16
to
   per-cpu-cache-amount = memory_on_node / 16 / number_of_cpus_on_node.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Tested-by: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/quicklist.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/quicklist.c~mm-size-of-quicklists-shouldnt-be-proportional-to-the-number-of-cpus mm/quicklist.c
--- a/mm/quicklist.c~mm-size-of-quicklists-shouldnt-be-proportional-to-the-number-of-cpus
+++ a/mm/quicklist.c
@@ -26,7 +26,10 @@ DEFINE_PER_CPU(struct quicklist, quickli
 static unsigned long max_pages(unsigned long min_pages)
 {
 	unsigned long node_free_pages, max;
-	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
+	int node = numa_node_id();
+	struct zone *zones = NODE_DATA(node)->node_zones;
+	int num_cpus_on_node;
+	node_to_cpumask_ptr(cpumask_on_node, node);
 
 	node_free_pages =
 #ifdef CONFIG_ZONE_DMA
@@ -38,6 +41,10 @@ static unsigned long max_pages(unsigned 
 		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
 
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
+
+	num_cpus_on_node = cpus_weight_nr(*cpumask_on_node);
+	max /= num_cpus_on_node;
+
 	return max(max, min_pages);
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-size-of-quicklists-shouldnt-be-proportional-to-the-number-of-cpus.patch
linux-next.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-unlockless-reclaim.patch
mm-show-quicklist-usage-in-proc-meminfo.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

