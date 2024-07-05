Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB64143C6C
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 06:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161821; cv=none; b=dftTI0xOjQ+qkYGIEiH73SQggr55TyzIPV2BdseN6PqGp86eo7qg31qC/zK8Hv6+NTEKvwfdQYYk4bphwbHaPoqQnbxe0ZW0x5GHUfiAfSWRJEIRgkxyABpyjSIlq0ZIgxi1wJcvM4rtQ0VZUwJdXaDl71Qc3TRJPDI40HZLd4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161821; c=relaxed/simple;
	bh=TyI4w69nyyeZsJRN8SAS5B5UqpsmdZkFCuthUE8GVFY=;
	h=Date:To:From:Subject:Message-Id; b=G6Mv3+i9sWI6e/w75O+0USq771usraFynSq/kuj5g68IpQVCbd7+hxIgXu6iliYLd1lru55l+Ez++Vk7aMMp00L3JbeQWSsHwJ6F0QzGFPTbttH5UkxlW931Y7lTPILYXBTZFLnftkl6kvGxdrpnqoGsU7DLLWcBObHNk9TjU88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w4FxVKMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w4FxVKMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B30C116B1;
	Fri,  5 Jul 2024 06:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720161820;
	bh=TyI4w69nyyeZsJRN8SAS5B5UqpsmdZkFCuthUE8GVFY=;
	h=Date:To:From:Subject:From;
	b=w4FxVKMaQ3MV1NRmE4CfxkieDK090z6+TfYJMmfPf5Jsc0CqDX3Rgb6zve2O1Hhcw
	 j8svuOXhJcsFYWFhPT+Gc+f5z8Iqxe++FKGJRZLh5ogu4bR0hlBmf2RZrFMIiEk4Ty
	 CxhgKTe234pv98etZZNTIE+QkxsbLIt+EwlKYAVc=
Date: Thu, 04 Jul 2024 23:43:39 -0700
To: mm-commits@vger.kernel.org,zxcvb600870024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fix-the-example-typo.patch removed from -mm tree
Message-Id: <20240705064340.87B30C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/rbtree.c: fix the example typo
has been removed from the -mm tree.  Its filename was
     fix-the-example-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hsin Chang Yu <zxcvb600870024@gmail.com>
Subject: lib/rbtree.c: fix the example typo
Date: Fri, 28 Jun 2024 22:22:29 +0800

Replace the "Sr" with "sr", the example is wrong if sl and N don't have
child nodes, so sr should be red node.

Link: https://lkml.kernel.org/r/20240628142229.69419-1-zxcvb600870024@gmail.com
Signed-off-by: Hsin Chang Yu <zxcvb600870024@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/rbtree.c~fix-the-example-typo
+++ a/lib/rbtree.c
@@ -297,9 +297,9 @@ ____rb_erase_color(struct rb_node *paren
 				 *   / \           / \
 				 *  N   S    -->  N   sl
 				 *     / \             \
-				 *    sl  Sr            S
+				 *    sl  sr            S
 				 *                       \
-				 *                        Sr
+				 *                        sr
 				 *
 				 * Note: p might be red, and then both
 				 * p and sl are red after rotation(which
@@ -312,9 +312,9 @@ ____rb_erase_color(struct rb_node *paren
 				 *   / \            /  \
 				 *  N   sl   -->   P    S
 				 *       \        /      \
-				 *        S      N        Sr
+				 *        S      N        sr
 				 *         \
-				 *          Sr
+				 *          sr
 				 */
 				tmp1 = tmp2->rb_right;
 				WRITE_ONCE(sibling->rb_left, tmp1);
_

Patches currently in -mm which might be from zxcvb600870024@gmail.com are


