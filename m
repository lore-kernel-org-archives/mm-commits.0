Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAFC144D11
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 06:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161825; cv=none; b=dlpGwJAvJS/PvOVLMB0kT5/RtXiBU1rWMwhBgTkVfDA8fA6TZA5ps6RmnNVl5N4zZ7OMb5Qf8RTHlUlTZApA6oekpmnZ72+K7UOrbzIKLD5italFFJga8IvG2coyI9b8UpB6fh1P+ttoCa7eDtE7Cz5hOOam/MsF18DPAwehHj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161825; c=relaxed/simple;
	bh=4wDqDS+ILP9L7LG0vh2pampIJICcCnYWgo0pL1Jwp7s=;
	h=Date:To:From:Subject:Message-Id; b=I80RN74dIFkkpaSYQlCDrxXADlZ9z9rHzF9Sg0IWv61TGX6axHouh4vPspcnh8qsHScYgMxdICzqGA1nFMFnRN6MCdvHk3r5hDZ6SoeZ+GlrSNnsEUi99ff4bESxZdxIBNBufTIUhWeQEggtcTqSIHvrflVfp1a1/SYPWdEe/S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W3Qbz6i9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W3Qbz6i9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E41C4AF07;
	Fri,  5 Jul 2024 06:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720161825;
	bh=4wDqDS+ILP9L7LG0vh2pampIJICcCnYWgo0pL1Jwp7s=;
	h=Date:To:From:Subject:From;
	b=W3Qbz6i9cE7jTnqaOTKlsN23cOMa14fKfTpsx/5fA2TxY8RnOibpAGa6M1pwlWOr9
	 PrBt/b42UwIKrRZeoJn0DpnGHe5nhanRxGzhhT8mVVSUgO1isrXmlbbfVG9DLM4Ox2
	 0j+kmQ4rph7iz9oHSuLtVM9GwRsmWREStO1NA3fQ=
Date: Thu, 04 Jul 2024 23:43:44 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-avoid-undefined-behavior-in-nilfs_cnt32_ge-macro.patch removed from -mm tree
Message-Id: <20240705064344.E9E41C4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro
has been removed from the -mm tree.  Its filename was
     nilfs2-avoid-undefined-behavior-in-nilfs_cnt32_ge-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
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


