Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215F71AAE07
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 21:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583942; cv=none; b=Qk+50hWQqOEQ6EfejZB7qLqhn6lmR+q3JeoAekDcPuZd/CU+Gm6l6ScXDhvadyzwLrU5YLcUjSyZeF5aOig7Tui4T/bb0R4LPWK9DI/E/RntPo4xy0SFWi9IuUTZB44yYIBGNEpA6SRuCVWNWaDkN1i6OY9gtoLTfH7IGcBjrJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583942; c=relaxed/simple;
	bh=DmYNwSJM5BC6hRcurAkszellZSFK/5/vXnmBN0wfEh4=;
	h=Date:To:From:Subject:Message-Id; b=MSAI+mwwEthWeVWyx4W1HlrmRoevbY0qrRnOMOglTupgnklM3ZZTT+Pph9Ajkf1vhV+SMwge/Y5w/et95zAY9v5QSjdAN7kA51O4+FH/1zuRJR/rU4dRhNz/2+1YjSPkWbJI7DXhG0TTwnDkgDjETQ+SEhQQRLKMcLgEIOlq3L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XhSn8o8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XhSn8o8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFAFC32782;
	Tue, 13 Aug 2024 21:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723583941;
	bh=DmYNwSJM5BC6hRcurAkszellZSFK/5/vXnmBN0wfEh4=;
	h=Date:To:From:Subject:From;
	b=XhSn8o8BgkEjTGOtndLNbWb0qvsjMLBk6sjPgyb/Dje7SzochGf+dcRC4g7lWKvJU
	 oDPvBxwnPxnO5Ct27itrdfO5SjpnGbcUEZo5fLjRCZRuzqyYLYiF2fwRxjikKUaNWG
	 Xm6hn0A2/D6Yeg9TKoRpGML1vWfQLC/Gg9tindSw=
Date: Tue, 13 Aug 2024 14:19:00 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-comment-typo-of-ma_root.patch added to mm-unstable branch
Message-Id: <20240813211901.6FFAFC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix comment typo of ma_root
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-comment-typo-of-ma_root.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-comment-typo-of-ma_root.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: fix comment typo of ma_root
Date: Mon, 12 Aug 2024 15:09:24 +0000

In comment of mas_start(), we lists the return value for different cases. 
In case of a single entry, we set mas->status to ma_root, while the
comment uses mas_root, which is not a maple_status.

Fix the typo according to the code.

Link: https://lkml.kernel.org/r/20240812150925.31551-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-comment-typo-of-ma_root
+++ a/lib/maple_tree.c
@@ -1346,7 +1346,7 @@ static void mas_node_count(struct ma_sta
  * Return:
  * - If mas->node is an error or not mas_start, return NULL.
  * - If it's an empty tree:     NULL & mas->status == ma_none
- * - If it's a single entry:    The entry & mas->status == mas_root
+ * - If it's a single entry:    The entry & mas->status == ma_root
  * - If it's a tree:            NULL & mas->status == safe root node.
  */
 static inline struct maple_enode *mas_start(struct ma_state *mas)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-improve-code-consistency-with-zonelist_-helper-functions.patch
mm-memory_hotplug-get-rid-of-__ref.patch
maple_tree-fix-comment-typo-of-ma_root.patch
maple_tree-fix-comment-typo-with-corresponding-maple_status.patch

