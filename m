Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AFB210FB
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EVepw5no"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0639CC433C7;
	Tue, 12 Dec 2023 18:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702406783;
	bh=lGsGOlcJiYQXR2ChfXsFNPTTFXUmSu1mAim4st93krk=;
	h=Date:To:From:Subject:From;
	b=EVepw5nowFNYGKQdS5JsEQxW1LPcCSgFQetUaqBXmlYBNi9DNN08whTuZ3ZzQe6Qs
	 7GMU+CAf7DqstM3ovEEIEOr26zhgNcTxRMdvb6Wk7A/jfQnIvOhsgSMa3AuV1n/r6F
	 WOtDjWBFob7P2H4sEp5L6eF/n1w7lXff1g78wJeg=
Date: Tue, 12 Dec 2023 10:46:22 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,lkft@linaro.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-separate-ma_state-node-from-status-fix.patch removed from -mm tree
Message-Id: <20231212184623.0639CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix mas_prev() state separation code
has been removed from the -mm tree.  Its filename was
     maple_tree-separate-ma_state-node-from-status-fix.patch

This patch was dropped because it was folded into maple_tree-separate-ma_state-node-from-status.patch

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix mas_prev() state separation code
Date: Thu, 7 Dec 2023 14:33:19 -0500

mas_prev() was setting the ma_underflow condition when the limit was
reached and not when the limit was attempting to go lower.  This resulted
in the incorrect behaviour on subsequent actions.

This commit fixes the status setting to only set ma_underflow when the
lower limit is attempted to be decremented, and modifies the testing to
ensure that's the case.

Link: https://lkml.kernel.org/r/20231207193319.4025462-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYs-j2FYZSFSVZj48mgoM9gQd4-7M2mu2Ez3D1DqDdW2bQ@mail.gmail.com/
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c      |   16 ++++++++++++----
 lib/test_maple_tree.c |    9 +++++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-separate-ma_state-node-from-status-fix
+++ a/lib/maple_tree.c
@@ -4498,6 +4498,9 @@ again:
 		mas->last = mas->index - 1;
 		mas->index = mas_safe_min(mas, pivots, mas->offset);
 	} else  {
+		if (mas->index <= min)
+			goto underflow;
+
 		if (mas_prev_node(mas, min)) {
 			mas_rewalk(mas, save_point);
 			goto retry;
@@ -4518,15 +4521,15 @@ again:
 	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 		goto retry;
 
-	if (mas->index <= min)
-		mas->status = ma_underflow;
 
 	if (likely(entry))
 		return entry;
 
 	if (!empty) {
-		if (mas_is_underflow(mas))
+		if (mas->index <= min) {
+			mas->status = ma_underflow;
 			return NULL;
+		}
 
 		goto again;
 	}
@@ -4662,7 +4665,7 @@ retry:
 		if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 			goto retry;
 
-		if (pivot >= max) {
+		if (pivot >= max) { /* Was at the limit, next will extend beyond */
 			mas->status = ma_overflow;
 			return NULL;
 		}
@@ -4677,6 +4680,11 @@ again:
 		else
 			mas->last = mas->max;
 	} else  {
+		if (mas->last >= max) {
+			mas->status = ma_overflow;
+			return NULL;
+		}
+
 		if (mas_next_node(mas, node, max)) {
 			mas_rewalk(mas, save_point);
 			goto retry;
--- a/lib/test_maple_tree.c~maple_tree-separate-ma_state-node-from-status-fix
+++ a/lib/test_maple_tree.c
@@ -3280,8 +3280,8 @@ static noinline void __init check_state_
 	MT_BUG_ON(mt, mas.last != 0x1500);
 	MT_BUG_ON(mt, !mas_is_active(&mas));
 
-	/* next:active ->active */
-	entry = mas_next(&mas, ULONG_MAX);
+	/* next:active ->active (spanning limit) */
+	entry = mas_next(&mas, 0x2100);
 	MT_BUG_ON(mt, entry != ptr2);
 	MT_BUG_ON(mt, mas.index != 0x2000);
 	MT_BUG_ON(mt, mas.last != 0x2500);
@@ -3346,6 +3346,11 @@ static noinline void __init check_state_
 	MT_BUG_ON(mt, entry != ptr);
 	MT_BUG_ON(mt, mas.index != 0x1000);
 	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_is_active(&mas)); /* spanning limit */
+	entry = mas_prev(&mas, 0x1200); /* underflow */
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
 	MT_BUG_ON(mt, !mas_is_underflow(&mas));
 
 	/* prev:underflow -> underflow (lower limit) spanning end range */
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-remove-unnecessary-default-labels-from-switch-statements.patch
maple_tree-make-mas_erase-more-robust.patch
maple_tree-move-debug-check-to-__mas_set_range.patch
maple_tree-add-end-of-node-tracking-to-the-maple-state.patch
maple_tree-use-cached-node-end-in-mas_next.patch
maple_tree-use-cached-node-end-in-mas_destroy.patch
maple_tree-clean-up-inlines-for-some-functions.patch
maple_tree-separate-ma_state-node-from-status.patch
maple_tree-remove-mas_searchable.patch
maple_tree-use-maple-state-end-for-write-operations.patch
maple_tree-dont-find-node-end-in-mtree_lookup_walk.patch
maple_tree-mtree_range_walk-clean-up.patch

