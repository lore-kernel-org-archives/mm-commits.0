Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA7C218AAF
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189069; cv=none; b=eonvxIRVpFC3Hj5qDsUC7ZfQmYXdrj5KQhiF5s4uvZcGJQphPSFvYAU3kzWqlq+2gX5zmCO23tJurgCKfG/S7hAk9vvQ6xmaBR8rcGHTkdn1rdw5WS2T+TwgimPQsM6m/pnSNGjtlTiLPJ0iZYVX3JySjcYMB8KW4gB2DoeN34s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189069; c=relaxed/simple;
	bh=vfp07BlAK8MFieLA5iBf5u+jxpXhTQPx9bJOTHgvpe4=;
	h=Date:To:From:Subject:Message-Id; b=JHAPHzvdLxMxMD797OrqcetZxP78in3ttlA+bDcNdUEpnMf4L4oW8fOlErlMGtf549b7tYcMeLB/dSHy0WACpmecuyHvt6OjMzP38V5FjnlaZwwshNfdTJo/2BYu/aw1RF0VqKt1RyW7+q71BVURbULHTBWsAmt61ImedaxXJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tLL5FYgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tLL5FYgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AE1C4CEEC;
	Mon, 17 Mar 2025 05:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189069;
	bh=vfp07BlAK8MFieLA5iBf5u+jxpXhTQPx9bJOTHgvpe4=;
	h=Date:To:From:Subject:From;
	b=tLL5FYgBv9hr7RTVcLDz+xXUj8bJ6slenc9btLTh0GJEa99UdKYNdLInH+KJ78Hka
	 gXlBKdDZjQLOqIaqXbB2jDDB2NWPtjEvpX1R2Id2ZhpcIWAq/BMWx8hukmCQc2jfbD
	 zZhJGdhcxDwvPgi3imFPpm+ZE1kDA5nEDFowiTDg=
Date: Sun, 16 Mar 2025 22:24:28 -0700
To: mm-commits@vger.kernel.org,richard120310@gmail.com,jserv@ccns.ncku.edu.tw,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-plistc-add-shortcut-for-plist_requeue-fix.patch removed from -mm tree
Message-Id: <20250317052429.37AE1C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-plistc-add-shortcut-for-plist_requeue-fix
has been removed from the -mm tree.  Its filename was
     lib-plistc-add-shortcut-for-plist_requeue-fix.patch

This patch was dropped because it was folded into lib-plistc-add-shortcut-for-plist_requeue.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-plistc-add-shortcut-for-plist_requeue-fix
Date: Tue Jan 28 07:27:41 PM PST 2025

tweak comment and code layout

Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: I Hsin Cheng <richard120310@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/lib/plist.c~lib-plistc-add-shortcut-for-plist_requeue-fix
+++ a/lib/plist.c
@@ -171,12 +171,13 @@ void plist_requeue(struct plist_node *no
 
 	plist_del(node, head);
 
-	/* After plist_del(), iter is the replacement of node
-	 * , if node was on prio_list, then take shortcut to
-	 * find node_next instead of looping.
+	/*
+	 * After plist_del(), iter is the replacement of the node.  If the node
+	 * was on prio_list, take shortcut to find node_next instead of looping.
 	 */
 	if (!list_empty(&iter->prio_list)) {
-		iter = list_entry(iter->prio_list.next, struct plist_node, prio_list);
+		iter = list_entry(iter->prio_list.next, struct plist_node,
+				  prio_list);
 		node_next = &iter->node_list;
 		goto queue;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
lib-plistc-add-shortcut-for-plist_requeue.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

