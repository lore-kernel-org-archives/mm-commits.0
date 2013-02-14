From: akpm@linux-foundation.org
Subject: + mm-fadvise-drain-all-pagevecs-if-posix_fadv_dontneed-fails-to-discard-all-pages.patch added to -mm tree
Date: Thu, 14 Feb 2013 12:39:30 -0800
Message-ID: <20130214203931.164C75A4207__48059.56364512$1360874402$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:52331 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761656Ab3BNUjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 15:39:32 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so283924qeb.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 12:39:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, rvdheij@gmail.com, stable@vger.kernel.org


The patch titled
     Subject: mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard all pages
has been added to the -mm tree.  Its filename is
     mm-fadvise-drain-all-pagevecs-if-posix_fadv_dontneed-fails-to-discard-all-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard all pages

Rob van der Heij reported the following (paraphrased) on private mail.

	The scenario is that I want to avoid backups to fill up the page
	cache and purge stuff that is more likely to be used again (this is
	with s390x Linux on z/VM, so I don't give it as much memory that
	we don't care anymore). So I have something with LD_PRELOAD that
	intercepts the close() call (from tar, in this case) and issues
	a posix_fadvise() just before closing the file.

	This mostly works, except for small files (less than 14 pages)
	that remains in page cache after the face.

Unfortunately Rob has not had a chance to test this exact patch but the
test program below should be reproducing the problem he described.

The issue is the per-cpu pagevecs for LRU additions. If the pages are added
by one CPU but fadvise() is called on another then the pages remain resident
as the invalidate_mapping_pages() only drains the local pagevecs via its
call to pagevec_release(). The user-visible effect is that a program that
uses fadvise() properly is not obeyed.

A possible fix for this is to put the necessary smarts into
invalidate_mapping_pages() to globally drain the LRU pagevecs if a pagevec
page could not be discarded. The downside with this is that an inode cache
shrink would send a global IPI and memory pressure potentially causing
global IPI storms is very undesirable.

Instead, this patch adds a check during fadvise(POSIX_FADV_DONTNEED) to
check if invalidate_mapping_pages() discarded all the requested pages. If a
subset of pages are discarded it drains the LRU pagevecs and tries again. If
the second attempt fails, it assumes it is due to the pages being mapped,
locked or dirty and does not care. With this patch, an application using
fadvise() correctly will be obeyed but there is a downside that a malicious
application can force the kernel to send global IPIs and increase overhead.

If accepted, I would like this to be considered as a -stable candidate.
It's not an urgent issue but it's a system call that is not working as
advertised which is weak.

The following test program demonstrates the problem. It should never
report that pages are still resident but will without this patch. It
assumes that CPU 0 and 1 exist.

int main() {
	int fd;
	int pagesize = getpagesize();
	ssize_t written = 0, expected;
	char *buf;
	unsigned char *vec;
	int resident, i;
	cpu_set_t set;

	/* Prepare a buffer for writing */
	expected = FILESIZE_PAGES * pagesize;
	buf = malloc(expected + 1);
	if (buf == NULL) {
		printf("ENOMEM\n");
		exit(EXIT_FAILURE);
	}
	buf[expected] = 0;
	memset(buf, 'a', expected);

	/* Prepare the mincore vec */
	vec = malloc(FILESIZE_PAGES);
	if (vec == NULL) {
		printf("ENOMEM\n");
		exit(EXIT_FAILURE);
	}

	/* Bind ourselves to CPU 0 */
	CPU_ZERO(&set);
	CPU_SET(0, &set);
	if (sched_setaffinity(getpid(), sizeof(set), &set) == -1) {
		perror("sched_setaffinity");
		exit(EXIT_FAILURE);
	}

	/* open file, unlink and write buffer */
	fd = open("fadvise-test-file", O_CREAT|O_EXCL|O_RDWR);
	if (fd == -1) {
		perror("open");
		exit(EXIT_FAILURE);
	}
	unlink("fadvise-test-file");
	while (written < expected) {
		ssize_t this_write;
		this_write = write(fd, buf + written, expected - written);

		if (this_write == -1) {
			perror("write");
			exit(EXIT_FAILURE);
		}

		written += this_write;
	}
	free(buf);

	/*
	 * Force ourselves to another CPU. If fadvise only flushes the local
	 * CPUs pagevecs then the fadvise will fail to discard all file pages
	 */
	CPU_ZERO(&set);
	CPU_SET(1, &set);
	if (sched_setaffinity(getpid(), sizeof(set), &set) == -1) {
		perror("sched_setaffinity");
		exit(EXIT_FAILURE);
	}

	/* sync and fadvise to discard the page cache */
	fsync(fd);
	if (posix_fadvise(fd, 0, expected, POSIX_FADV_DONTNEED) == -1) {
		perror("posix_fadvise");
		exit(EXIT_FAILURE);
	}

	/* map the file and use mincore to see which parts of it are resident */
	buf = mmap(NULL, expected, PROT_READ, MAP_SHARED, fd, 0);
	if (buf == NULL) {
		perror("mmap");
		exit(EXIT_FAILURE);
	}
	if (mincore(buf, expected, vec) == -1) {
		perror("mincore");
		exit(EXIT_FAILURE);
	}

	/* Check residency */
	for (i = 0, resident = 0; i < FILESIZE_PAGES; i++) {
		if (vec[i])
			resident++;
	}
	if (resident != 0) {
		printf("Nr unexpected pages resident: %d\n", resident);
		exit(EXIT_FAILURE);
	}

	munmap(buf, expected);
	close(fd);
	free(vec);
	exit(EXIT_SUCCESS);
}

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Rob van der Heij <rvdheij@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN mm/fadvise.c~mm-fadvise-drain-all-pagevecs-if-posix_fadv_dontneed-fails-to-discard-all-pages mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-drain-all-pagevecs-if-posix_fadv_dontneed-fails-to-discard-all-pages
+++ a/mm/fadvise.c
@@ -17,6 +17,7 @@
 #include <linux/fadvise.h>
 #include <linux/writeback.h>
 #include <linux/syscalls.h>
+#include <linux/swap.h>
 
 #include <asm/unistd.h>
 
@@ -120,9 +121,22 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
 		end_index = (endbyte >> PAGE_CACHE_SHIFT);
 
-		if (end_index >= start_index)
-			invalidate_mapping_pages(mapping, start_index,
+		if (end_index >= start_index) {
+			unsigned long count = invalidate_mapping_pages(mapping,
+						start_index, end_index);
+
+			/*
+			 * If fewer pages were invalidated than expected then
+			 * it is possible that some of the pages were on
+			 * a per-cpu pagevec for a remote CPU. Drain all
+			 * pagevecs and try again.
+			 */
+			if (count < (end_index - start_index + 1)) {
+				lru_add_drain_all();
+				invalidate_mapping_pages(mapping, start_index,
 						end_index);
+			}
+		}
 		break;
 	default:
 		ret = -EINVAL;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-huge_memory-use-new-hashtable-implementation.patch
mmksm-use-new-hashtable-implementation.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-dont-wait-on-congested-zones-in-balance_pgdat.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-uninline-page_xchg_last_nid.patch
mm-init-report-on-last-nid-information-stored-in-page-flags.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
mm-memmap_init_zone-performance-improvement.patch
mm-rename-page-struct-field-helpers.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-fadvise-drain-all-pagevecs-if-posix_fadv_dontneed-fails-to-discard-all-pages.patch

