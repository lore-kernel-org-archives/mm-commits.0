Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2983128395
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 01:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780709576; cv=none; b=WeU2htqNwhrqkMuFH2v8q6SPhUVaWXXPMy12bHCSI+jMSRpUcxanHVO1ZMv3CgPujwHrrzFvG5KxAnEu9SjjhUB7mfWf5SwFkUU1DOFaqzZMOlIxfJI9DUOr/x3b9cIHA5ge+2cpocjXScmidWQ8CIXe40Rh/e6Vr9gpLMQ3ND8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780709576; c=relaxed/simple;
	bh=wr1ny6XbV2QZJGo+qJ5N52XyOwyvHjtCr+wwhLInF2c=;
	h=Date:To:From:Subject:Message-Id; b=TwhQF5hHEYZhKDgtO4WghIF4Ds/3i21kjA2HqKstIS6x7RLoigWeMw0R9eJsvlxaluEyRr5mdBOoT86Tm4GsyvD7FOvJvD1Dk7n0ctPwzMoRpQkShMiynRuUYG6iP0yZn2g5yZfH/iS75xM/XrQ4CRvzyUGnhNVL5KLREuXIRX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VofZ1C4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VofZ1C4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CA41F00893;
	Sat,  6 Jun 2026 01:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780709574;
	bh=ozR3QSoHED9UpcCyGhrnxtXjIyGmLvgvneUJEVlhTSM=;
	h=Date:To:From:Subject;
	b=VofZ1C4EJJP35HTEUXJwZq9yflixQU3zWEFhY4UFyoDspr7OCY6O7FQ5HnHBECZNW
	 FLj9dlvVXUMZycpiVWwgwVWEJwsJuX/9e66zAF8R6DrDismmlF16b5NolZoMktYge7
	 fS6hcGWb9UpVVsRk22st3ut4karOU/8dYIoVB4mk=
Date: Fri, 05 Jun 2026 18:32:54 -0700
To: mm-commits@vger.kernel.org,fabf@skynet.be,brauner@kernel.org,akpm@linux-foundation.org,m32285159@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-efs-remove-unneeded-debug-prints.patch added to mm-nonmm-unstable branch
Message-Id: <20260606013254.96CA41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: efs: remove unneeded debug prints
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-efs-remove-unneeded-debug-prints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-efs-remove-unneeded-debug-prints.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

fs-fat-inode-replace-sprintf-with-scnprintf.patch
fs-efs-remove-unneeded-debug-prints.patch

