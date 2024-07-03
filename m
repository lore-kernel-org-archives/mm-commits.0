Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A6139D
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 01:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719971667; cv=none; b=gB2Dfyhx4VVrG4noZwNgXhSi4JE8YOfvGDLiYwHZUEUzTxvfkzjOe+BBr0/qnrBpd3HkFiER8svbTxtinmYJJXHviQtC6xz/h1ABH4tInb2RnkfxI0ZD9LC6EpjwvXX0IWjiBp/oO4HG+0qJEtfzv9V9wKmGgOi8MxKJaq03x38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719971667; c=relaxed/simple;
	bh=z5DGQGvB9eqHbAUIbpUYfqODvi4FF9xEP7oYfICcBiE=;
	h=Date:To:From:Subject:Message-Id; b=Wnwj5kDRkZ1lotpx274Pi4McMYWuGD6RNkIiCxa3FQZye5sKkcs9EtfcsPxtoqyEvlXGbFPVbOmonD92pdaRYj2rhdEm1CHA/JyQhhsA2vU23oWD0pkJe6Vuy+76zrtAnuR0TgAVhMUEr5MCjssOBNoUx/RWKG278W+Iofo3gSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GVRqZiUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GVRqZiUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75965C116B1;
	Wed,  3 Jul 2024 01:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719971665;
	bh=z5DGQGvB9eqHbAUIbpUYfqODvi4FF9xEP7oYfICcBiE=;
	h=Date:To:From:Subject:From;
	b=GVRqZiUM/Lcq46qE9Gtudsv2+Y+mLcFE0r/P5Z8NfhSkKV0+PrXH+RB5R0Aes/eRv
	 MKLMgxQdEPpJHlN95SUjQJ14l9FJED75ttJylwl+eNwtCFCsNmbkwjMqR9zV82AejY
	 rP2MXiGh/p1oxunTHqvs5SZIBeqzAAs9fAFX5rPY=
Date: Tue, 02 Jul 2024 18:54:24 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-avoid-undefined-behavior-in-nilfs_cnt32_ge-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240703015425.75965C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-avoid-undefined-behavior-in-nilfs_cnt32_ge-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-avoid-undefined-behavior-in-nilfs_cnt32_ge-macro.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro
Date: Wed, 3 Jul 2024 03:35:12 +0900

According to the C standard 3.4.3p3, the result of signed integer overflow
is undefined.  The macro nilfs_cnt32_ge(), which compares two sequence
numbers, uses signed integer subtraction that can overflow, and therefore
the result of the calculation may differ from what is expected due to
undefined behavior in different environments.

Similar to an earlier change to the jiffies-related comparison macros in
commit 5a581b367b5d ("jiffies: Avoid undefined behavior from signed
overflow"), avoid this potential issue by changing the definition of the
macro to perform the subtraction as unsigned integers, then cast the
result to a signed integer for comparison.

Link: https://lkml.kernel.org/r/20130727225828.GA11864@linux.vnet.ibm.com
Link: https://lkml.kernel.org/r/20240702183512.6390-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c~nilfs2-avoid-undefined-behavior-in-nilfs_cnt32_ge-macro
+++ a/fs/nilfs2/segment.c
@@ -136,7 +136,7 @@ static void nilfs_dispose_list(struct th
 
 #define nilfs_cnt32_ge(a, b)   \
 	(typecheck(__u32, a) && typecheck(__u32, b) && \
-	 ((__s32)(a) - (__s32)(b) >= 0))
+	 ((__s32)((a) - (b)) >= 0))
 
 static int nilfs_prepare_segment_lock(struct super_block *sb,
 				      struct nilfs_transaction_info *ti)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-kernel-bug-on-rename-operation-of-broken-directory.patch
nilfs2-avoid-undefined-behavior-in-nilfs_cnt32_ge-macro.patch

