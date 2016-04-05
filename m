From: akpm@linux-foundation.org
Subject: +
 mm-consider-compaction-feedback-also-for-costly-allocation.patch added to
 -mm tree
Date: Tue, 05 Apr 2016 14:51:30 -0700
Message-ID: <57043362.+68VG4CCadl+jf6M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543AbcDEVvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: consider compaction feedback also for costly allocation
has been added to the -mm tree.  Its filename is
     mm-consider-compaction-feedback-also-for-costly-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consider-compaction-feedback-also-for-costly-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consider-compaction-feedback-also-for-costly-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: consider compaction feedback also for costly allocation

PAGE_ALLOC_COSTLY_ORDER retry logic is mostly handled inside
should_reclaim_retry currently where we decide to not retry after at least
order worth of pages were reclaimed or the watermark check for at least
one zone would succeed after reclaiming all pages if the reclaim hasn't
made any progress.  Compaction feedback is mostly ignored and we just try
to make sure that the compaction did at least something before giving up.

The first condition was added by a41f24ea9fd6 ("page allocator: smarter
retry of costly-order allocations) and it assumed that lumpy reclaim could
have created a page of the sufficient order.  Lumpy reclaim, has been
removed quite some time ago so the assumption doesn't hold anymore. 
Remove the check for the number of reclaimed pages and rely on the
compaction feedback solely.  should_reclaim_retry now only makes sure that
we keep retrying reclaim for high order pages only if they are hidden by
watermaks so order-0 reclaim makes really sense.

should_compact_retry now keeps retrying even for the costly allocations. 
The number of retries is reduced wrt.  !costly requests because they are
less important and harder to grant and so their pressure shouldn't cause
contention for other requests or cause an over reclaim.  We also do not
reset no_progress_loops for costly request to make sure we do not keep
reclaiming too agressively.

This has been tested by running a process which fragments memory:
	- compact memory
	- mmap large portion of the memory (1920M on 2GRAM machine with 2G
	  of swapspace)
	- MADV_DONTNEED single page in PAGE_SIZE*((1UL<<MAX_ORDER)-1)
	  steps until certain amount of memory is freed (250M in my test)
	  and reduce the step to (step / 2) + 1 after reaching the end of
	  the mapping
	- then run a script which populates the page cache 2G (MemTotal)
	  from /dev/zero to a new file
And then tries to allocate
nr_hugepages=$(awk '/MemAvailable/{printf "%d\n", $2/(2*1024)}' /proc/meminfo)
huge pages.

root@test1:~# echo 1 > /proc/sys/vm/overcommit_memory;echo 1 > /proc/sys/vm/compact_memory; ./fragment-mem-and-run /root/alloc_hugepages.sh 1920M 250M
Node 0, zone      DMA     31     28     31     10      2      0      2      1      2      3      1
Node 0, zone    DMA32    437    319    171     50     28     25     20     16     16     14    437

* This is the /proc/buddyinfo after the compaction

Done fragmenting. size=2013265920 freed=262144000
Node 0, zone      DMA    165     48      3      1      2      0      2      2      2      2      0
Node 0, zone    DMA32  35109  14575    185     51     41     12      6      0      0      0      0

* /proc/buddyinfo after memory got fragmented

Executing "/root/alloc_hugepages.sh"
Eating some pagecache
508623+0 records in
508623+0 records out
2083319808 bytes (2.1 GB) copied, 11.7292 s, 178 MB/s
Node 0, zone      DMA      3      5      3      1      2      0      2      2      2      2      0
Node 0, zone    DMA32    111    344    153     20     24     10      3      0      0      0      0

* /proc/buddyinfo after page cache got eaten

Trying to allocate 129
129

* 129 hugepages requested and all of them granted.

Node 0, zone      DMA      3      5      3      1      2      0      2      2      2      2      0
Node 0, zone    DMA32    127     97     30     99     11      6      2      1      4      0      0

* /proc/buddyinfo after hugetlb allocation.

10 runs will behave as follows:
Trying to allocate 130
130
--
Trying to allocate 129
129
--
Trying to allocate 128
128
--
Trying to allocate 129
129
--
Trying to allocate 128
128
--
Trying to allocate 129
129
--
Trying to allocate 132
132
--
Trying to allocate 129
129
--
Trying to allocate 128
128
--
Trying to allocate 129
129

So basically 100% success for all 10 attempts.
Without the patch numbers looked much worse:
Trying to allocate 128
12
--
Trying to allocate 129
14
--
Trying to allocate 129
7
--
Trying to allocate 129
16
--
Trying to allocate 129
30
--
Trying to allocate 129
38
--
Trying to allocate 129
19
--
Trying to allocate 129
37
--
Trying to allocate 129
28
--
Trying to allocate 129
37

Just for completness the base kernel without oom detection rework looks
as follows:
Trying to allocate 127
30
--
Trying to allocate 129
12
--
Trying to allocate 129
52
--
Trying to allocate 128
32
--
Trying to allocate 129
12
--
Trying to allocate 129
10
--
Trying to allocate 129
32
--
Trying to allocate 128
14
--
Trying to allocate 128
16
--
Trying to allocate 129
8

As we can see the success rate is much more volatile and smaller without
this patch.  So the patch not only makes the retry logic for costly
requests more sensible the success rate is even higher.




Below you can find both the tool to fragment memory and the script it
calls in my testing.

I was executing this as follows (on 2G machine with 2G swap space):
echo 1 > /proc/sys/vm/overcommit_memory
echo 1 > /proc/sys/vm/compact_memory
/root/fragment-mem-and-run /root/alloc_hugepages.sh 1920M 250M


#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>

/*
 * Tries to fragment memory and then executes the given program.
 * Usage:
 * 	fragment-mem-and-run program_to_run mem_to_allocate mem_to_free
 *
 * First tries to allocate mem_to_allocate[KMG] amount of memory which,
 * then tries to free mem_to_free[KMG] in a way to maximize the fragmentation
 * of the page allocator. It is advisable to run compaction before starting
 * to get reproducible behavior.
 *
 * Copyright Michal Hocko 2016
 */
#define PAGE_SIZE 4096UL
#define MAX_ORDER 11
#define ALIGN(x, a) (((x) + (a) - 1) & ~((a) - 1))
#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)

size_t parse_size(const char *value)
{
	char *endptr;
	size_t size = strtoul(value, &endptr, 10);

	if (*endptr == 'K')
		size *= 1024;
	else if (*endptr == 'M')
		size *= 1024*1024;
	else if (*endptr == 'G')
		size *= 1024*1024*1024;
	else if (*endptr)
		size = -1UL;

	return size;
}

void dump_file(const char *filename)
{
	char buffer[BUFSIZ];
	int fd;

	fd = open(filename, O_RDONLY);
	if (fd == -1)
		return;

	while (read(fd, buffer, sizeof(buffer)))
		printf("%s", buffer);

	printf("\n");
	close(fd);
}

int main(int argc, char **argv)
{
	size_t size = 10<<20;
	size_t to_free, freed = 0;
	size_t i, step = PAGE_SIZE*((1UL<<MAX_ORDER)-1);
	unsigned char *addr;
	int buddy_fd;
	const char *to_run;

	if (argc > 1) {
		to_run = argv[1];
	} else {
		fprintf(stderr, "Didn't tell me what to run");
		return 1;
	}
	if (argc > 2) {
		size = parse_size(argv[2]);
		if (size == -1UL) {
			fprintf(stderr, "Number expected \"%s\" given.\n", argv[0]);
			return 1;
		}
	}
	if (argc > 3) {
		to_free = parse_size(argv[3]);
		if (to_free == -1UL) {
			fprintf(stderr, "Number expected \"%s\" given.\n", argv[0]);
			return 1;
		}
	} else {
		to_free = size;
	}

	dump_file("/proc/buddyinfo");
	addr = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	if (addr == MAP_FAILED) {
		perror("mmap");
		return 3;
	}
	madvise(addr, size, MADV_NOHUGEPAGE);
	for (i = 0; i < size; i += PAGE_SIZE)
		addr[i] = 1;

	while (freed < to_free) {
		for (i = step; (freed < to_free) && (i < size); i = (i + step) % size) {
			i = PAGE_ALIGN(i);
			if (madvise(&addr[i], PAGE_SIZE, MADV_DONTNEED))
				continue;
			freed += PAGE_SIZE;
		}
		step = (step / 2) + 1;
	}

	printf("Done fragmenting. size=%lu freed=%lu\n", size, freed);
	dump_file("/proc/buddyinfo");
	printf("Executing \"%s\"\n", to_run);
	fflush(stdout);
	return system(to_run);
}


#!/bin/sh
nr_hugepages=$(awk '/MemAvailable/{printf "%d\n", $2/(2*1024)}' /proc/meminfo)
echo Eating some pagecache
file=/mnt/data/file.1
nr_blocks=$(awk '/MemTotal/{printf "%d\n", $2/4}' /proc/meminfo)
dd of=/dev/null if=/mnt/data/file.1 bs=4096 count=$nr_blocks
cat /proc/buddyinfo
echo Trying to allocate $nr_hugepages
/bin/echo $nr_hugepages > /proc/sys/vm/nr_hugepages
cat /proc/sys/vm/nr_hugepages
cat /proc/buddyinfo
echo Try to compact
echo 1 > /proc/sys/vm/compact_memory
cat /proc/buddyinfo
echo 0 > /proc/sys/vm/nr_hugepages

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   63 +++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff -puN mm/page_alloc.c~mm-consider-compaction-feedback-also-for-costly-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-consider-compaction-feedback-also-for-costly-allocation
+++ a/mm/page_alloc.c
@@ -3023,6 +3023,8 @@ should_compact_retry(unsigned int order,
 		     enum migrate_mode *migrate_mode,
 		     int compaction_retries)
 {
+	int max_retries = MAX_COMPACT_RETRIES;
+
 	if (!order)
 		return false;
 
@@ -3040,17 +3042,24 @@ should_compact_retry(unsigned int order,
 	}
 
 	/*
-	 * !costly allocations are really important and we have to make sure
-	 * the compaction wasn't deferred or didn't bail out early due to locks
-	 * contention before we go OOM. Still cap the reclaim retry loops with
-	 * progress to prevent from looping forever and potential trashing.
+	 * make sure the compaction wasn't deferred or didn't bail out early
+	 * due to locks contention before we declare that we should give up.
 	 */
-	if (order <= PAGE_ALLOC_COSTLY_ORDER) {
-		if (compaction_withdrawn(compact_result))
-			return true;
-		if (compaction_retries <= MAX_COMPACT_RETRIES)
-			return true;
-	}
+	if (compaction_withdrawn(compact_result))
+		return true;
+
+	/*
+	 * !costly requests are much more important than __GFP_REPEAT
+	 * costly ones because they are de facto nofail and invoke OOM
+	 * killer to move on while costly can fail and users are ready
+	 * to cope with that. 1/4 retries is rather arbitrary but we
+	 * would need much more detailed feedback from compaction to
+	 * make a better decision.
+	 */
+	if (order > PAGE_ALLOC_COSTLY_ORDER)
+		max_retries /= 4;
+	if (compaction_retries <= max_retries)
+		return true;
 
 	return false;
 }
@@ -3211,18 +3220,17 @@ static inline bool is_thp_gfp_mask(gfp_t
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
  * The reclaim feedback represented by did_some_progress (any progress during
- * the last reclaim round), pages_reclaimed (cumulative number of reclaimed
- * pages) and no_progress_loops (number of reclaim rounds without any progress
- * in a row) is considered as well as the reclaimable pages on the applicable
- * zone list (with a backoff mechanism which is a function of no_progress_loops).
+ * the last reclaim round) and no_progress_loops (number of reclaim rounds without
+ * any progress in a row) is considered as well as the reclaimable pages on the
+ * applicable zone list (with a backoff mechanism which is a function of
+ * no_progress_loops).
  *
  * Returns true if a retry is viable or false to enter the oom path.
  */
 static inline bool
 should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		     struct alloc_context *ac, int alloc_flags,
-		     bool did_some_progress, unsigned long pages_reclaimed,
-		     int no_progress_loops)
+		     bool did_some_progress, int no_progress_loops)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -3234,14 +3242,6 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	if (no_progress_loops > MAX_RECLAIM_RETRIES)
 		return false;
 
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		if (pages_reclaimed >= (1<<order))
-			return false;
-
-		if (did_some_progress)
-			return true;
-	}
-
 	/*
 	 * Keep reclaiming pages while there is a chance this will lead somewhere.
 	 * If none of the target zones can satisfy our allocation request even
@@ -3312,7 +3312,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	struct page *page = NULL;
 	int alloc_flags;
-	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	enum compact_result compact_result;
@@ -3446,16 +3445,18 @@ retry:
 	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
 		goto noretry;
 
-	if (did_some_progress) {
+	/*
+	 * Costly allocations might have made a progress but this doesn't mean
+	 * their order will become available due to high fragmentation so
+	 * always increment the no progress counter for them
+	 */
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
 		no_progress_loops = 0;
-		pages_reclaimed += did_some_progress;
-	} else {
+	else
 		no_progress_loops++;
-	}
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
-				 did_some_progress > 0, pages_reclaimed,
-				 no_progress_loops))
+				 did_some_progress > 0, no_progress_loops))
 		goto retry;
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch

