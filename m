Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3D2438483
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816331; cv=none; b=lo1lUxEJdlY+inmTDB9AztJQO1XPK9dt69vy64ZW/Q0b6C7USpDoshSMPQ0yOHceSJ3kpc5zev5uvxtMsdNCyzZwIFIv99SzGUpj4oDslBnPqctoKlpcoFfY4koZbFe0SuX2aQ+u+ezB0Ah7m86K6OUVzip39RAPluvEIIN4Rcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816331; c=relaxed/simple;
	bh=NDFUWPtZ6yUhqhBapg9MWs5Hg6wxMnzvn1Akq2SeZAg=;
	h=Date:To:From:Subject:Message-Id; b=Z4rs6OOM4CfIsHecR2BeZUoB00f7Hy42HF+8dhl3qq31UHv5pw6NyxR2nI+6dd3mjoDUpkWsKjIaYhLbyew/ueyMdGukhvceWgHtG0G58ALrVkxHI7SUd9YpWhrZbIrrUnk38ogudayPNSetTq0X3gMWzWe7fiD3rfTDjD5hTJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AymKFUIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AymKFUIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3223D1F00A3A;
	Tue,  4 Aug 2026 04:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816330;
	bh=EalQXaSr262LwOZG7a4dMdbPwOD+wGrsqf3MarZZ3CM=;
	h=Date:To:From:Subject;
	b=AymKFUIgA1sMP0czk4f97gwHbY1dGjU0YxGIZAd+gJf53a9jwkVMLo+M7H8fknA8E
	 jFfTptG5Simljj4hTzVqFZfWz+2TDktI/UWSFfDaqDrzwMQGhB28QR/ziasO5OUrZv
	 QR5fDa/ze3hOWwB+FTuDyj/QQIH79kVITFcye880=
Date: Mon, 03 Aug 2026 21:05:29 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,zhangcoder@yeah.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-allow-0xe9-near-jump-in-fat_read_static_bpb.patch removed from -mm tree
Message-Id: <20260804040530.3223D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: FAT: allow 0xE9 near jump in fat_read_static_bpb()
has been removed from the -mm tree.  Its filename was
     fat-allow-0xe9-near-jump-in-fat_read_static_bpb.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ziran Zhang <zhangcoder@yeah.net>
Subject: FAT: allow 0xE9 near jump in fat_read_static_bpb()
Date: Sun, 12 Apr 2026 14:59:41 +0800

fat_read_static_bpb() only accepts a short jump as a valid bootstrap code
signature for DOS 1.x volumes when the dos1xfloppy mount option is used.

However, according to the Microsoft fatgen103.doc, the BS_jmpBoot field
has two allowed forms: 0xEB 0x??  0x90 (short jump + NOP) and 0xE9 0x?? 
0x??  (near jump).  The specification explicitly states that either form
is acceptable.

This patch relaxes the check to also accept 0xE9 as the first byte of the
jump instruction.

Link: https://lore.kernel.org/20260412070109.5197-1-zhangcoder@yeah.net
Signed-off-by: Ziran Zhang <zhangcoder@yeah.net>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/fat/inode.c~fat-allow-0xe9-near-jump-in-fat_read_static_bpb
+++ a/fs/fat/inode.c
@@ -1479,8 +1479,9 @@ static int fat_read_static_bpb(struct su
 	int error = -EINVAL;
 	unsigned i;
 
-	/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp code */
-	if (b->ignored[0] != 0xeb || b->ignored[2] != 0x90) {
+	/* 16-bit DOS 1.x reliably wrote bootstrap short-jmp or near-jmp code */
+	if ((b->ignored[0] != 0xeb || b->ignored[2] != 0x90) &&
+	    (b->ignored[0] != 0xe9)) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR,
 				"%s; no bootstrapping code", notdos1x);
_

Patches currently in -mm which might be from zhangcoder@yeah.net are


