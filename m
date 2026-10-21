Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560419;
	b=Q4oK1dWtpt2uWdKjndRg0N/PaE9jwhSAi46FGaRkupDyz1Yaz3Wz5N1PLC3oHKiHQ7RU
	 USBo0vYkKGLrHR32CsZw/SMcJJFzWfOMoBPCPXdkRGphT1h0US2XjPcLyp81aBsuNABsx
	 gkbuF49dIUvUxI/zqjaBhRyCDlC090u6oyZogCWzvJv7nfp17rfu4HTAYCaDh56HhDPZL
	 nbNo0GYKNbEgaFjVID5+R+ckBKGs+XB83/GwmikbAzCit+0ul25Xh+uOnijL/70mywXl0
	 p2b6yaI7pbhfzlNWyqG+bOF4Zo6mFqUa4EsJt+s1pu+d8bef9Xy6t+fBOKiGO0qT8bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560419;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=giSWaroOQg/fozNuNH/GD/+HVWhmXsj3/Qu5YwUMiKc=;
	b=jMvbkdpp7Hr1EBjvSd87bPBQF6rODBATqocuYr2C6Yyzfc8Gm6N1o03++3aVOfYJxyD1
	 aVgab5gVfMU5hUXKeSTI5gVgFoMnIEtGuS24lfopYZUlG1EK0n0SJpljvLgLMfGc23tLW
	 RABCaOyE29YOwRBm8nTdx8wxc5y4brW79tUp31H9ggHd/R1KflYl13oqi6niCf8uaM56T
	 qfP48EWhniHHx1nEimLEvg/p/0McPW3qY2/spPSwzMY9u+BwhZrOC0roXqZBlGb30kp5o
	 sjuCkzdP8f+7s2qs/2Ic4Ho1k8Z9fP9pczlf3QAY2WhvDuu2dK2AOf71jCKQq99vwOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Vyacd+5y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCB6606A32F
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Vyacd+5y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B3E1F000CB;
	Wed, 21 Oct 2026 05:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560418;
	bh=giSWaroOQg/fozNuNH/GD/+HVWhmXsj3/Qu5YwUMiKc=;
	h=Date:To:From:Subject;
	b=Vyacd+5yl4Ceg4+SZIa2iylLT4mVEDMcrtUwCsVj6NxEyU7UV/YygsZPfbIHVYaKw
	 puTegojKg73tDnZqr0axakqSMSkvvHQJy0IpXryPlmzcdvl3pbrzHR4r1ulyKhHUmd
	 u/wFTVjKq7jbFYZRt6zXknA/lIrPh720NQOxOEJs=
Date: Tue, 20 Oct 2026 22:26:58 -0700
To: mm-commits@vger.kernel.org,teczm@foxmail.com,hirofumi@mail.parknet.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch removed from -mm tree
Message-Id: <20261021052658.B9B3E1F000CB@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix
has been removed from the -mm tree.  Its filename was
     fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch

This patch was dropped because it was folded into fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix
Date: Tue Oct 13 03:50:35 PM PDT 2026

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: zhoumin <teczm@foxmail.com>
---

 fs/fat/misc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fat/misc.c~fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix
+++ a/fs/fat/misc.c
@@ -62,6 +62,7 @@ void _fat_msg(struct super_block *sb, co
 	_printk(FAT_PRINTK_PREFIX "%pV\n", level, sb->s_id, &vaf);
 	va_end(args);
 }
+EXPORT_SYMBOL_GPL(_fat_msg);
 
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
fs-proc-task_mmu-pin-mm_users-in-do_pagemap_scan-fix.patch
fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch

