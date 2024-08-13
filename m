Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4D21A76BE
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583944; cv=none; b=UrCgKI+FbpM8r8T257m514pbEcuxdNwaMvDDY2rEvEqeDJVfekuiqiW8LwMd9TQZo21d09dmFAmSJKD7hDqVero32BVQ+Ebfpg8/KQyaZ/fRWlHD3Sn/Mg0hm59Mefc/FiTDrSfoCiubrRXl8qmGwogQrQEdUABYFW+umT1Ycj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583944; c=relaxed/simple;
	bh=YTKK3cqiebbw40Q/+a9m+AJncXpzU9nyO0as4del1Cs=;
	h=Date:To:From:Subject:Message-Id; b=jyRaggpz7Gt+N+KS716h7A8LcANXcXDNAwWXYhNrW/0LG5sld0Qk3ity7DvDTWg+T9K7TjxgFvckrrqH5AgBkDlg0gK/Qequ1TiLucplTlGgcPfRrBMK22P9tg2lySE9MeGbqGjpQM9QrEj5s/d1VIrfvIz3lPFnvfr+Q9JsSMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hOhGtAZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hOhGtAZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E766C4DE03;
	Tue, 13 Aug 2024 21:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723583943;
	bh=YTKK3cqiebbw40Q/+a9m+AJncXpzU9nyO0as4del1Cs=;
	h=Date:To:From:Subject:From;
	b=hOhGtAZcIOHz26UjC+EPtVb6718d+sTK3P6nryt2qpRjpnSFpa8LsLqsKmYuCE8OZ
	 k582p4GZp5z26bglE8Jah/3PjdJHwmKDzfCSg89yH6/QR5RxalRxoYSWJzBjvbWvsy
	 zCR9BJbgL0LqT92XlAMl111ctIBDERvoSzPkkyi8=
Date: Tue, 13 Aug 2024 14:19:02 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-comment-typo-with-corresponding-maple_status.patch added to mm-unstable branch
Message-Id: <20240813211903.4E766C4DE03@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix comment typo with corresponding maple_status
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-comment-typo-with-corresponding-maple_status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-comment-typo-with-corresponding-maple_status.patch

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
Subject: maple_tree: fix comment typo with corresponding maple_status
Date: Mon, 12 Aug 2024 15:09:25 +0000

In comment of function mas_start(), we list the return value of different
cases.  According to the comment context, tell the maple_status here is
more consistent with others.

Let's correct it with ma_active in the case it's a tree.

Link: https://lkml.kernel.org/r/20240812150925.31551-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-comment-typo-with-corresponding-maple_status
+++ a/lib/maple_tree.c
@@ -1347,7 +1347,7 @@ static void mas_node_count(struct ma_sta
  * - If mas->node is an error or not mas_start, return NULL.
  * - If it's an empty tree:     NULL & mas->status == ma_none
  * - If it's a single entry:    The entry & mas->status == ma_root
- * - If it's a tree:            NULL & mas->status == safe root node.
+ * - If it's a tree:            NULL & mas->status == ma_active
  */
 static inline struct maple_enode *mas_start(struct ma_state *mas)
 {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-improve-code-consistency-with-zonelist_-helper-functions.patch
mm-memory_hotplug-get-rid-of-__ref.patch
maple_tree-fix-comment-typo-of-ma_root.patch
maple_tree-fix-comment-typo-with-corresponding-maple_status.patch

