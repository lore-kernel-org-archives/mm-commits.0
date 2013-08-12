From: akpm@linux-foundation.org
Subject: + readahead-make-context-readahead-more-conservative.patch added
 to -mm tree
Date: Mon, 12 Aug 2013 14:39:09 -0700
Message-ID: <520955fd.iJD+AOsYLWTnt07O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3HLVjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 17:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tm@tao.ma, miaox@cn.fujitsu.com, fengguang.wu@intel.com

Subject: + readahead-make-context-readahead-more-conservative.patch added to -mm tree
To: fengguang.wu@intel.com,miaox@cn.fujitsu.com,tm@tao.ma
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 14:39:09 -0700


The patch titled
     Subject: readahead: make context readahead more conservative
has been added to the -mm tree.  Its filename is
     readahead-make-context-readahead-more-conservative.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/readahead-make-context-readahead-more-conservative.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/readahead-make-context-readahead-more-conservative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: readahead: make context readahead more conservative

This helps performance on moderately dense random reads on SSD.

Transaction-Per-Second numbers provided by Taobao:

		QPS	case
		-------------------------------------------------------
		7536	disable context readahead totally
w/ patch:	7129	slower size rampup and start RA on the 3rd read
		6717	slower size rampup
w/o patch:	5581	unmodified context readahead

Before, readahead will be started whenever reading page N+1 when it happen
to read N recently.  After patch, we'll only start readahead when *three*
random reads happen to access pages N, N+1, N+2.  The probability of this
happening is extremely low for pure random reads, unless they are very
dense, which actually deserves some readahead.

Also start with a smaller readahead window.  The impact to interleaved
sequential reads should be small, because for a long run stream, the the
small readahead window rampup phase is negletable.

The context readahead actually benefits clustered random reads on HDD
whose seek cost is pretty high.  However as SSD is increasingly used for
random read workloads it's better for the context readahead to concentrate
on interleaved sequential reads.

Another SSD rand read test from Miao

        # file size:        2GB
        # read IO amount: 625MB
        sysbench --test=fileio          \
                --max-requests=10000    \
                --num-threads=1         \
                --file-num=1            \
                --file-block-size=64K   \
                --file-test-mode=rndrd  \
                --file-fsync-freq=0     \
                --file-fsync-end=off    run

shows the performance of btrfs grows up from 69MB/s to 121MB/s, ext4 from
104MB/s to 121MB/s.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Tested-by: Tao Ma <tm@tao.ma>
Tested-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/readahead.c~readahead-make-context-readahead-more-conservative mm/readahead.c
--- a/mm/readahead.c~readahead-make-context-readahead-more-conservative
+++ a/mm/readahead.c
@@ -371,10 +371,10 @@ static int try_context_readahead(struct
 	size = count_history_pages(mapping, ra, offset, max);
 
 	/*
-	 * no history pages:
+	 * not enough history pages:
 	 * it could be a random read
 	 */
-	if (!size)
+	if (size <= req_size)
 		return 0;
 
 	/*
@@ -385,8 +385,8 @@ static int try_context_readahead(struct
 		size *= 2;
 
 	ra->start = offset;
-	ra->size = get_init_ra_size(size + req_size, max);
-	ra->async_size = ra->size;
+	ra->size = min(size + req_size, max);
+	ra->async_size = 1;
 
 	return 1;
 }
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
watchdog-update-watchdog_tresh-properly-fix.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
readahead-make-context-readahead-more-conservative.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
fat-additions-to-support-fat_fallocate-fix.patch
vmcore-introduce-remap_oldmem_pfn_range-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

