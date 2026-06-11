Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813064611C5
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781203384; cv=none; b=tAMnHqFALGpyRl7WopNX3Mnkx6gZkO6JmSqXD6NQmp2p2rDd5bQbtvykymUNol/uWgICkqLhWMncwkhyH7H0lLx0R8tSRRQWo+gPVZAH7By9nk8A7urGNvOA2xBWOCMNsa1ZDXxJxspY/nHAwKoDN32bwXOUwkTeG5Td/ekwlq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781203384; c=relaxed/simple;
	bh=Bc6ie0gwC+BvsiKThAVk5ImY+j9IR+bm/vKDOY0rIVk=;
	h=Date:To:From:Subject:Message-Id; b=B0u6IRPQqYSAgrRubEu4sIJamww9AcJ9rI4ns2w3sg6t/iJScVHGD+VDVG5swQwG8lIHaBuAEjrbhH8YA5rq7l10oypN6oT+ZHu4F7gmkAfuHYuNFl5ymIpY00DnYRJY/XDDRaiX9PPCVhJEHNtmII2zw4DHGJyyACvyEOoJPnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u0N+S14I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u0N+S14I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B501F000E9;
	Thu, 11 Jun 2026 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781203383;
	bh=Bgr4AfmwksY7eX+/FovPTZtrZCavuT8WejL/C2nXgS8=;
	h=Date:To:From:Subject;
	b=u0N+S14IHyNY6W9g7bE/bsjrWzhQ0kiJJ2IB9WeO5fVuB9unJGVWSigQdF4XGdZdE
	 vTrYWcfnxYLsP0xkmuWUmc5bygYN6Un4ceuJKa9d2pTmlj9btH8MYGW8ZLzzyH3iic
	 hSQBPNhdqaiyJPNVkaSc0gWlW65C4B0oasBp0+Jw=
Date: Thu, 11 Jun 2026 11:43:02 -0700
To: mm-commits@vger.kernel.org,fabf@skynet.be,brauner@kernel.org,akpm@linux-foundation.org,m32285159@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-efs-remove-unneeded-debug-prints.patch removed from -mm tree
Message-Id: <20260611184303.58B501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: efs: remove unneeded debug prints
has been removed from the -mm tree.  Its filename was
     fs-efs-remove-unneeded-debug-prints.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maxwell Doose <m32285159@gmail.com>
Subject: fs: efs: remove unneeded debug prints
Date: Thu, 4 Jun 2026 22:52:51 -0500

The current code uses debug prints conditionally compiled with #ifdef
DEBUG.  However, that code, when compiled, causes compiler errors due to
incompatible formatters and undefined variables, notably:

fs/efs/file.c: In function `efs_get_block':
fs/efs/file.c:26:35: error: `block' undeclared (first use in this
function); did you mean `iblock'?
  26 |                         __func__, block, inode->i_blocks, inode->i_size);
     |                                   ^~~~~

and:

fs/efs/file.c: In function `efs_bmap':
./include/linux/kern_levels.h:5:25: error: format `%ld' expects
argument of type `long int', but argument 4 has type `blkcnt_t' {aka
`long long unsigned int'} [-Werror=format=]
   5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
     |                         ^~~~~~

which also extends to the other formatters.  As this part of the code has
been dead for just about 14 years now, it has not been modernized to stay
compatible with the most recent gcc compilers.  Fix these issues by
removing the debug prints.

Link: https://lore.kernel.org/20260605035251.89305-2-m32285159@gmail.com
Fixes: f403d1dbac6d ("fs/efs: add pr_fmt / use __func__")
Signed-off-by: Maxwell Doose <m32285159@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/file.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

--- a/fs/efs/file.c~fs-efs-remove-unneeded-debug-prints
+++ a/fs/efs/file.c
@@ -18,16 +18,9 @@ int efs_get_block(struct inode *inode, s
 
 	if (create)
 		return error;
-	if (iblock >= inode->i_blocks) {
-#ifdef DEBUG
-		/*
-		 * i have no idea why this happens as often as it does
-		 */
-		pr_warn("%s(): block %d >= %ld (filesize %ld)\n",
-			__func__, block, inode->i_blocks, inode->i_size);
-#endif
+	if (iblock >= inode->i_blocks)
 		return 0;
-	}
+
 	phys = efs_map_block(inode, iblock);
 	if (phys)
 		map_bh(bh_result, inode->i_sb, phys);
@@ -42,16 +35,8 @@ int efs_bmap(struct inode *inode, efs_bl
 	}
 
 	/* are we about to read past the end of a file ? */
-	if (!(block < inode->i_blocks)) {
-#ifdef DEBUG
-		/*
-		 * i have no idea why this happens as often as it does
-		 */
-		pr_warn("%s(): block %d >= %ld (filesize %ld)\n",
-			__func__, block, inode->i_blocks, inode->i_size);
-#endif
+	if (!(block < inode->i_blocks))
 		return 0;
-	}
 
 	return efs_map_block(inode, block);
 }
_

Patches currently in -mm which might be from m32285159@gmail.com are


