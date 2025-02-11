Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F18627291B
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739317562; cv=none; b=Oe5rWZRTeS8R3rKBGFOjnP/Qdtlx3YseH0/ZsEJzudGliRU7mJP09/jLaLnr0vtGfO/+jI8TzcJVR8pDezn/w8wVaZD95Tp+UN08vCUooBL2DAOZtNop7UP3xZjlS5BB5mbIH+rMZbtD2e8eEApABFe+iXmsVsQcYpJ+16gdZIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739317562; c=relaxed/simple;
	bh=iuhZq8jDg92OLcavHk9fnc+h5QWT71ADdMF3eLOSDHY=;
	h=Date:To:From:Subject:Message-Id; b=uAbb8+lPUx312ibo+b+8ZUlA7D2ThdtpUNwNNcB2GB1KudvkFuIzGuVftdDrFganHbw+zD/sdNkJ6KBjNFVa6DjU9/A5HzLKkhK+1Ic4bfqX5qj9toJDEe0ti0XaR4i2MR5A8ui9S28IW4cXkrwX0miqd1pDxKpbmMG0cGNiPkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zD6ZBCuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zD6ZBCuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9399CC4CEDD;
	Tue, 11 Feb 2025 23:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739317561;
	bh=iuhZq8jDg92OLcavHk9fnc+h5QWT71ADdMF3eLOSDHY=;
	h=Date:To:From:Subject:From;
	b=zD6ZBCuYOaG8JgB2czinLsKdn0pB3Z/bPbwi3BmEqRJFCHPZQ1JupScs5gq5GgR5I
	 jtAKrT/vAOKrUkJYmD/lxctSLfyoDYy9y+4iVTA9Ff0W6gY+Ym66j9VM/DVE8sw0Ww
	 ENWn2ylxrsgdRoKQKstKC6ZQmsthWHv4UUsXLR7Y=
Date: Tue, 11 Feb 2025 15:46:00 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,Liam.Howlett@Oracle.com,jserv@ccns.ncku.edu.tw,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-ma_dead_node-in-mte_dead_node.patch added to mm-unstable branch
Message-Id: <20250211234601.9399CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use ma_dead_node() in mte_dead_node()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-ma_dead_node-in-mte_dead_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-ma_dead_node-in-mte_dead_node.patch

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
From: I Hsin Cheng <richard120310@gmail.com>
Subject: maple_tree: use ma_dead_node() in mte_dead_node()
Date: Tue, 11 Feb 2025 15:18:50 +0800

Utilize ma_dead_node() in mte_dead_node().  It can prevent decoding the
maple enode for a second time.  Use the "node" to find parent for
comparison.

Link: https://lkml.kernel.org/r/20250211071850.330632-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Shuah khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-ma_dead_node-in-mte_dead_node
+++ a/lib/maple_tree.c
@@ -584,13 +584,10 @@ static __always_inline bool ma_dead_node
  */
 static __always_inline bool mte_dead_node(const struct maple_enode *enode)
 {
-	struct maple_node *parent, *node;
+	struct maple_node *node;
 
 	node = mte_to_node(enode);
-	/* Do not reorder reads from the node prior to the parent check */
-	smp_rmb();
-	parent = mte_parent(enode);
-	return (parent == node);
+	return ma_dead_node(node);
 }
 
 /*
_

Patches currently in -mm which might be from richard120310@gmail.com are

maple_tree-correct-comment-for-mas_start.patch
maple_tree-use-ma_dead_node-in-mte_dead_node.patch
lib-plistc-add-shortcut-for-plist_requeue.patch

