Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E9C3B3BE6
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 03:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784087973; cv=none; b=iPqV8n6dKDRIypDJ7rBjNsmWybQI20arUG9P8D+Q1BgmzMGAWPpCSewMvzbG0BtxThHQuYlY7zMar7QGdaOrFEWaESIv4Mg2/8y31k3cFz0BcBIYGSS6/hPsjUJ5Psk11R7cm5lWLi5b9zcIHWETbrJZ96xXHcO0mtQmXxlX2Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784087973; c=relaxed/simple;
	bh=k4GdeXAAfQRgmrJKiyG2xfvq9OFq5thA0wM7xDq8FVE=;
	h=Date:To:From:Subject:Message-Id; b=WNjZ4fNq0z6x7GTcfotiOY3Y+Gd7E8V8pz9RYunvv917fyF38cTVdwb2KLeGp8j8vqKW1MwRxeurRZM9HaZzpjKFXLJirS1NEe9EGVZ8UKWL+JT2VXC/VLRuhVm4kRTuBcI9V8vuYJxvtwvAP6hm6I+cKGDinr5QsTkEalmqutE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=prkm2oH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="prkm2oH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934BE1F000E9;
	Wed, 15 Jul 2026 03:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784087971;
	bh=wgFFk/sZb4c6SBj/eHcr8kajq6IFMY44DFZfXWRZ/6k=;
	h=Date:To:From:Subject;
	b=prkm2oH0lsqlW1LMdnh/R29O+LjNxS0m8YVKKYY1BXQ1iteDrn1Mkai9bnGqzQ6RY
	 cGYJc+cI7q6PdQ2kGfji4EYwxmNUzA+v/djRjHYc9B11KvQqQ3e1qUEt3NoQvQjhgX
	 z+G6OE2hYjBJ7iir8b8Cg2oJ2x2FMDoqcixOUiNQ=
Date: Tue, 14 Jul 2026 20:59:31 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,zhangcoder@yeah.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-allow-0xe9-near-jump-in-fat_read_static_bpb.patch added to mm-nonmm-unstable branch
Message-Id: <20260715035931.934BE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: FAT: allow 0xE9 near jump in fat_read_static_bpb()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-allow-0xe9-near-jump-in-fat_read_static_bpb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-allow-0xe9-near-jump-in-fat_read_static_bpb.patch

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

fat-allow-0xe9-near-jump-in-fat_read_static_bpb.patch

