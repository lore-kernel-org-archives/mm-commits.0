Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01323FBA5
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719598659; cv=none; b=frhCNQf17uEVMXImqDvD5501o+vNTyPLkMyPdOaKUtaTpirVXu8hDLG5Zuk7X5lgms/MdgwWvN12Zs4prtweyvhX1CeJIPJRyp7lBJ0KlvbxJ8qz0UOJugjqbzdoWJH95CytXf1+KNzXlJ03hBX33ziP2lTJrlN5b52j68bILaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719598659; c=relaxed/simple;
	bh=tXyYIhFlhbiWmvOFQ8tzbfDwKkQJaOjXblmTf0S+Ohg=;
	h=Date:To:From:Subject:Message-Id; b=EmS3KKh0xSv9BuKXcBD4XsePU2JY1hBaN1oTxY3c8M7nJtKdtjWZnYYMJS4fJ9KbdTh3kVwnEmcyr3JjwVTmCBN3H/y1kwuuhISj8E+BW/sa92lp8dysSq2aMngRJB8Q6vUIDJQw/E6zGL8f4/Ijd763KYUjfBzWo28eMa2/XtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eKm2jEYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKm2jEYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BE2C116B1;
	Fri, 28 Jun 2024 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719598659;
	bh=tXyYIhFlhbiWmvOFQ8tzbfDwKkQJaOjXblmTf0S+Ohg=;
	h=Date:To:From:Subject:From;
	b=eKm2jEYAXgU48mtkBm7QgccZQLsX4Z72i+6IKmNJ8hbh7KqRqxMbpe5gtOjHIKZOY
	 bJKVyIjnFq9I7Ol82EbQ+J3zGdXjh/aWvKRBo5L7xhiE6SZ5GsmbNvocCXJS5VkUYr
	 up8eTkrDt5cQI5g5+SZm8ZYI0Y1Q3Y+VPDFu++zY=
Date: Fri, 28 Jun 2024 11:17:38 -0700
To: mm-commits@vger.kernel.org,zxcvb600870024@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-the-example-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20240628181739.82BE2C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/rbtree.c: fix the example typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fix-the-example-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-the-example-typo.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

fix-the-example-typo.patch

