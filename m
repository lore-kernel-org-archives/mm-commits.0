Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1451F4C9F
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 21:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715828; cv=none; b=WSASM9VnZyQLPllCY2WS5QpW/xQgDofowBBLX3wZalJJivSe+1BgZlFSK45wwKuPhUZTDEKONY/IZEANkMlLvbLt34atrNhR/smHbANRlxY6nVzSclyCMsCSHuFoxqgJs4HQJiHlvEovOncnzu882oyWADSQlPzJbUOiIzoGx+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715828; c=relaxed/simple;
	bh=UdpQYM3R7XGI1G1yn032JM+F+Q8HsTUOTFdllxPl4OM=;
	h=Date:To:From:Subject:Message-Id; b=b/akgmZlNGnZML0ry2Br4UyipiRe3PGza6nTl/BoJCYOtzAq5GFAeHCuBhv7F/N/5rkkqLD+DKSXq8gCiudlWmVEgLeTl6QSZoFmSlL16crbjG+mw2dXMrUR9UzUdVANwx0yhPsRA/shQhweIlXzcD5J2xmME7pNtT1lk1uBgio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q/bfwT5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q/bfwT5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA72C4CEE3;
	Thu,  3 Apr 2025 21:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743715827;
	bh=UdpQYM3R7XGI1G1yn032JM+F+Q8HsTUOTFdllxPl4OM=;
	h=Date:To:From:Subject:From;
	b=Q/bfwT5rLgvceyWwhFkYBVi2Wryey8v+j1GAcuos158KAU93bmpUIYprxQzwv2sVr
	 KV2XBMWdvyXGGhIjd349POh3AN5bCNu5Q2b3n1Ujfm3AGyrPdWv4eWN/UFkU6cnBlU
	 D72CNkhIj9KGcKLBeXnhJnUJ2xiRo+SiC6xqKoR0=
Date: Thu, 03 Apr 2025 14:30:26 -0700
To: mm-commits@vger.kernel.org,zxcvb600870024@gmail.com,johnny1001s000602@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-rbtreec-fix-the-example-typo.patch added to mm-nonmm-unstable branch
Message-Id: <20250403213027.7CA72C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/rbtree.c: fix the example typo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-rbtreec-fix-the-example-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-rbtreec-fix-the-example-typo.patch

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
From: Chisheng Chen <johnny1001s000602@gmail.com>
Subject: lib/rbtree.c: fix the example typo
Date: Thu, 3 Apr 2025 19:26:14 +0800

Replace `sr` with `Sr`.  The condition `!tmp1 || rb_is_black(tmp1)`
ensures that `tmp1` (which is `sibling->rb_right`) is either NULL or a
black node.  Therefore, the right child of the sibling must be black, and
the example should use `Sr` instead of `sr`.

Link: https://lkml.kernel.org/r/20250403112614.570140-1-johnny1001s000602@gmail.com
Signed-off-by: Chisheng Chen <johnny1001s000602@gmail.com>
Cc: Hsin Chang Yu <zxcvb600870024@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/rbtree.c~lib-rbtreec-fix-the-example-typo
+++ a/lib/rbtree.c
@@ -297,9 +297,9 @@ ____rb_erase_color(struct rb_node *paren
 				 *   / \           / \
 				 *  N   S    -->  N   sl
 				 *     / \             \
-				 *    sl  sr            S
+				 *    sl  Sr            S
 				 *                       \
-				 *                        sr
+				 *                        Sr
 				 *
 				 * Note: p might be red, and then both
 				 * p and sl are red after rotation(which
@@ -312,9 +312,9 @@ ____rb_erase_color(struct rb_node *paren
 				 *   / \            /  \
 				 *  N   sl   -->   P    S
 				 *       \        /      \
-				 *        S      N        sr
+				 *        S      N        Sr
 				 *         \
-				 *          sr
+				 *          Sr
 				 */
 				tmp1 = tmp2->rb_right;
 				WRITE_ONCE(sibling->rb_left, tmp1);
_

Patches currently in -mm which might be from johnny1001s000602@gmail.com are

lib-rbtreec-fix-the-example-typo.patch

