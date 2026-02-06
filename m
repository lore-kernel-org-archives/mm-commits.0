Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6407827B352
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 20:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770408085; cv=none; b=ALX4yWGbgich4bKqN0JnoPG99/Nh0u5jIKheIplRzxjHbkxVgIQnjlxglKKPpemjIvZQW/7zKEObbNYwg1ElzlEcqxU0PYRn71pQSSU0K9avHDG7/fe5mcP/YjEQAZyc7b86qpDxFPm3mO2KAhhp3N77LKJqNOnX0Pmkx6HmoDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770408085; c=relaxed/simple;
	bh=YftZjigvX3NGm5pNb1LZGGdkscqqIm7HhtWJBNklcdk=;
	h=Date:To:From:Subject:Message-Id; b=Y1o91urI5bMJvIbzUis4JGxWeUwztfJUiPjxQLLuNJO+Q3df+j7LVxltL+KFAR1WJR7/gGwXKidROWN840xU1NXUub1D3OXCyVzmGm98JuwwWvgY3jC/YG0p2j/ZrK2ee4BaWO5iv5mB+Py7z1eqj9j5OtlbVcl8BR/HtiLx7jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JFJr5gp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JFJr5gp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE47C116C6;
	Fri,  6 Feb 2026 20:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770408084;
	bh=YftZjigvX3NGm5pNb1LZGGdkscqqIm7HhtWJBNklcdk=;
	h=Date:To:From:Subject:From;
	b=JFJr5gp3cq8o1iFiskhVk1JnAFbSEGGBbrTxvsofTrSx1B2N57YMYZPjG6iw3ARpY
	 PTX21tjVAx1CyPnXkeyVEukd/TgKlvAA5ZOQKsrazgzG3MjnFNf47CBZiyLnGnDPHi
	 z3y+/I2hgJ4TbWxeNJh9U1SujyG0IvCj6l89QfV0=
Date: Fri, 06 Feb 2026 12:01:24 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,bingjiao@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix.patch added to mm-unstable branch
Message-Id: <20260206200124.DBE47C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix
Date: Fri Feb  6 12:00:18 PM PST 2026

fix comment typo, per Shakeel

Cc: Bing Jiao <bingjiao@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-tiers.c~mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix
+++ a/mm/memory-tiers.c
@@ -365,7 +365,7 @@ int next_demotion_node(int node, const n
 		return node_random(&mask);
 
 	/*
-	 * Preferred nodes are not in allowed_mask. Filp bits in
+	 * Preferred nodes are not in allowed_mask. Flip bits in
 	 * allowed_mask as used node mask. Then, use it to get the
 	 * closest demotion target.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-select-the-closest-perferred-node-in-demote_folio_list-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch

