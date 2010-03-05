From: akpm@linux-foundation.org
Subject: [folded] lib-more-scalable-list_sort-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:22:40 -0800
Message-ID: <201003052122.o25LMfR6028385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462Ab0CEVXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:23:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com, dedekind@infradead.org, don.mullis@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib-more-scalable-list_sort-fix
has been removed from the -mm tree.  Its filename was
     lib-more-scalable-list_sort-fix.patch

This patch was dropped because it was folded into lib-more-scalable-list_sort.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-more-scalable-list_sort-fix
From: Andrew Morton <akpm@linux-foundation.org>

style tweaks, fix comment, make list_sort_test __init.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/list_sort.c~lib-more-scalable-list_sort-fix lib/list_sort.c
--- a/lib/list_sort.c~lib-more-scalable-list_sort-fix
+++ a/lib/list_sort.c
@@ -61,16 +61,16 @@ static void merge_and_restore_back_links
 		}
 		tail = tail->next;
 	}
-	tail->next = a?:b;
+	tail->next = a ? : b;
 
 	do {
 		/*
 		 * In worst cases this loop may run many iterations.
 		 * Continue callbacks to the client even though no
-		 * element comparison is need, so the client's cmp()
+		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		(void) (*cmp)(priv, tail, tail);
+		(*cmp)(priv, tail, tail);
 
 		tail->next->prev = tail;
 		tail = tail->next;
@@ -159,7 +159,7 @@ static int cmp(void *priv, struct list_h
  */
 #define LIST_SORT_TEST_LENGTH (512+128+2) /* not including head */
 
-static int list_sort_test(void)
+static int __init list_sort_test(void)
 {
 	int i, r = 1, count;
 	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-count-swap-usage.patch
vmscan-check-high-watermark-after-shrink-zone.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
uml-linec-avoid-null-pointer-dereference.patch
lib-more-scalable-list_sort.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch

