From: akpm@linux-foundation.org
Subject: [folded] mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:15:09 -0800
Message-ID: <201003052115.o25LF9Sv027944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182Ab0CEVP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-avoid-false-sharing-of-mm_counter.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#173: FILE: mm/memory.c:149:
+#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,1)
                                                                       ^

ERROR: space required after that ',' (ctx:VxO)
#174: FILE: mm/memory.c:150:
+#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,-1)
                                                                       ^

ERROR: space required before that '-' (ctx:OxV)
#174: FILE: mm/memory.c:150:
+#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,-1)
                                                                        ^

ERROR: code indent should use tabs where possible
#192: FILE: mm/memory.c:168:
+ ^I * The caller must guarantee task->mm is not invalid.$

ERROR: code indent should use tabs where possible
#193: FILE: mm/memory.c:169:
+ ^I */$

total: 5 errors, 0 warnings, 225 lines checked

./patches/mm-avoid-false-sharing-of-mm_counter.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes
+++ a/mm/memory.c
@@ -146,8 +146,8 @@ static void add_mm_counter_fast(struct m
 	else
 		add_mm_counter(mm, member, val);
 }
-#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,1)
-#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member,-1)
+#define inc_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, 1)
+#define dec_mm_counter_fast(mm, member) add_mm_counter_fast(mm, member, -1)
 
 /* sync counter once per 64 page faults */
 #define TASK_RSS_EVENTS_THRESH	(64)
@@ -165,8 +165,8 @@ unsigned long get_mm_counter(struct mm_s
 
 	/*
 	 * Don't use task->mm here...for avoiding to use task_get_mm()..
- 	 * The caller must guarantee task->mm is not invalid.
- 	 */
+	 * The caller must guarantee task->mm is not invalid.
+	 */
 	val = atomic_long_read(&mm->rss_stat.count[member]);
 	/*
 	 * counter is updated in asynchronous manner and may go to minus.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

