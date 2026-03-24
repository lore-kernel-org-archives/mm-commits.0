Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A1136166E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388524; cv=none; b=stf+lxsgAK91Zecc786bh/aKcKDRdMOhja/ysei6lSxS7poRH9PA9spKfXwMQUmR0cNllImVVtqptHmJU6p6T0+ImrVqGlGRSpo3Fare2f5iQzgC/Z0kGIIvR92qgUSg3zLYKcRYPgn7IqQ2iT8LyTUa/eotWiqBl1pApkE9imk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388524; c=relaxed/simple;
	bh=pLwWVGcvV0U66zz54YZUwj9gmFfBfl87wQaWjcRmCgs=;
	h=Date:To:From:Subject:Message-Id; b=YXRx89l8BUOiLXxeoTnlB5RUjDvIdlyzI6o9Eav3cL87sU5t/PNThobLNMWOdAaeKl1gec64mpqBEU437+gG9Tj/6hsTYibBwHT+7h+RO38wLPQgeaDXKmWVcRVlg8pQUslFapHsZAPHi7PVrPXntdxK+n6M9bXjCtvN7VBm6mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T+XchD5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T+XchD5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007F2C19424;
	Tue, 24 Mar 2026 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388524;
	bh=pLwWVGcvV0U66zz54YZUwj9gmFfBfl87wQaWjcRmCgs=;
	h=Date:To:From:Subject:From;
	b=T+XchD5PB7SfXY8GyM75I/AyivCIWrYL6uQwzNPJ0E6sap2cH/V+oxTAhtvAx040Q
	 k7CqRStiXtQEAwm+93HRCwMFTGIOpZhZwYOBo9NHKJjyHxV6SAdyxELArXDQefE/Me
	 Ak89y2nzYMCFjH2pyKouRJWzmKrX2LdaX/3bVOYY=
Date: Tue, 24 Mar 2026 14:42:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-cp_converged-helper.patch removed from -mm tree
Message-Id: <20260324214204.007F2C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add cp_converged() helper
has been removed from the -mm tree.  Its filename was
     maple_tree-add-cp_converged-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add cp_converged() helper
Date: Fri, 30 Jan 2026 15:59:30 -0500

When the maple copy node converges into a single entry, then certain
operations can stop ascending the tree.

This is used more later.

Link: https://lkml.kernel.org/r/20260130205935.2559335-26-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-cp_converged-helper
+++ a/lib/maple_tree.c
@@ -3493,6 +3493,16 @@ static inline bool cp_is_new_root(struct
 	return true;
 }
 
+static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
+				struct ma_state *sib)
+{
+	if (cp->d_count != 1 || sib->end)
+		return false;
+
+	cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+	return true;
+}
+
 /*
  * spanning_ascend() - See if a spanning store operation has to keep walking up
  * the tree
@@ -3575,10 +3585,8 @@ static inline bool rebalance_ascend(stru
 	if (cp_is_new_root(cp, mas))
 		return false;
 
-	if (cp->d_count == 1 && !sib->end) {
-		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+	if (cp_converged(cp, mas, sib))
 		return false;
-	}
 
 	cp->height++;
 	copy_tree_location(parent, mas);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


