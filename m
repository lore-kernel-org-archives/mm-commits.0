Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC36E286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127178; cv=none; b=MvdQvOWHxCQTS5gwF8UYiR4eKmyquq2KR06VKdVfIiiPTImVdAW77TGCgyJUlzZ8F6O5owUdcdJnj74ZQRHegze9+YnLBYVueDgpBntxMT5uR/ox9pyyK7nNpgQe67+VHnNLVMG3xv7aAbVNkP6BfOQf0m5RuaTNiMZLPZmKoas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127178; c=relaxed/simple;
	bh=U2Vz6UXugDrl4rCgatk6lZJg+NLitInuH4dLPLy25TE=;
	h=Date:To:From:Subject:Message-Id; b=hKTQrkeSc1zt6kYnG6Waumpg/hk5EgfR8AGUStKOyOzVlLoAsZbVKaHCFoEmqAyV4+KUmkTWa1+fdSq9yCBf0GgphCeO4u/vhFMugZTfJ3wMsm3fwn9kG3Q0MROsMmynCtpdmBjJg/chMofOC3vZPRxI2HskEUZ/w0mO03p3GIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N+TIDOQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N+TIDOQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AACC4CEE3;
	Thu, 10 Jul 2025 05:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127178;
	bh=U2Vz6UXugDrl4rCgatk6lZJg+NLitInuH4dLPLy25TE=;
	h=Date:To:From:Subject:From;
	b=N+TIDOQk/aH2pYaFQfYjt49ew4A1MUJtVlktSKdPW4t9a5yjiw3Ha4Hclf9gmgxnC
	 YmfDniqWvk8R1d0fko6sFH78I0YMbawNZkuQxsDZUTQuZcW6mGNFL+NmwuvVa8BnQn
	 RQs+GgYQxcea+MCDLA51yigc2sOG3QYI85dMlaOU=
Date: Wed, 09 Jul 2025 22:59:38 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,chenl311@chinatelecom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-fat-prevent-fsfuzzer-from-dominating-the-console.patch removed from -mm tree
Message-Id: <20250710055938.96AACC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: fat: Prevent fsfuzzer from dominating the console
has been removed from the -mm tree.  Its filename was
     fs-fat-prevent-fsfuzzer-from-dominating-the-console.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Chen <chenl311@chinatelecom.cn>
Subject: fs: fat: Prevent fsfuzzer from dominating the console
Date: Fri, 20 Jun 2025 10:02:31 +0800

fsfuzzer may make many invalid access for FAT-fs and generate many kmsg
like "FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)".

For platforms & os that enables hardware serial device whose speed are
slow, this may cause softlockup easily.

So let's ratelimit the error log.

The log as below:
[11916.242560] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.254485] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.266388] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.278287] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.290180] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.302068] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.313962] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.325848] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.337732] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.349619] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.361505] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.373391] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.385272] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.397144] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.409025] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.420909] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.432791] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.444674] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.456558] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.468446] FAT-fs (loop2): error, invalid access to FAT (entry 0x00000ccb)
[11916.480352] watchdog: BUG: soft lockup - CPU#58 stuck for 26s! [cat:2446035]
[11916.480357] Modules linked in: ...
[11916.480503] CPU: 58 PID: 2446035 Comm: cat Kdump: loaded Tainted: ...
[11916.480508] Hardware name: vclusters VSFT5000 B/VSFT5000 B, BIOS ...
[11916.480510] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[11916.480513] pc : console_emit_next_record+0x1b4/0x288
[11916.480524] lr : console_emit_next_record+0x1ac/0x288
[11916.480525] sp : ffff80009bcdae90
[11916.480527] x29: ffff80009bcdaec0 x28: ffff800082513810 x27: 0000000000000001
[11916.480530] x26: 0000000000000001 x25: ffff800081f66000 x24: 0000000000000000
[11916.480533] x23: 0000000000000000 x22: ffff80009bcdaf8f x21: 0000000000000001
[11916.480535] x20: 0000000000000000 x19: ffff800082513810 x18: ffffffffffffffff
[11916.480538] x17: 0000000000000002 x16: 0000000000000001 x15: ffff80009bcdab30
[11916.480541] x14: 0000000000000000 x13: 205d353330363434 x12: 32545b5d36343438
[11916.480543] x11: 652820544146206f x10: 7420737365636361 x9 : ffff800080159a6c
[11916.480546] x8 : 69202c726f727265 x7 : 545b5d3634343836 x6 : 342e36313931315b
[11916.480549] x5 : ffff800082513a01 x4 : ffff80009bcdad31 x3 : 0000000000000000
[11916.480551] x2 : 00000000ffffffff x1 : 0000000001b9b000 x0 : ffff8000836cef00
[11916.480554] Call trace:
[11916.480557]  console_emit_next_record+0x1b4/0x288
[11916.480560]  console_flush_all+0xcc/0x190
[11916.480563]  console_unlock+0x78/0x138
[11916.480565]  vprintk_emit+0x1c4/0x210
[11916.480568]  vprintk_default+0x40/0x58
[11916.480570]  vprintk+0x84/0xc8
[11916.480572]  _printk+0x68/0xa0
[11916.480578]  _fat_msg+0x6c/0xa0 [fat]
[11916.480593]  __fat_fs_error+0xf8/0x118 [fat]
[11916.480601]  fat_ent_read+0x164/0x238 [fat]
[11916.480609]  fat_get_cluster+0x180/0x2c8 [fat]
[11916.480617]  fat_get_mapped_cluster+0xb8/0x170 [fat]

Link: https://lkml.kernel.org/r/20250620020231.9292-1-me@linux.beauty
Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fatent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/fatent.c~fs-fat-prevent-fsfuzzer-from-dominating-the-console
+++ a/fs/fat/fatent.c
@@ -356,7 +356,7 @@ int fat_ent_read(struct inode *inode, st
 
 	if (!fat_valid_entry(sbi, entry)) {
 		fatent_brelse(fatent);
-		fat_fs_error(sb, "invalid access to FAT (entry 0x%08x)", entry);
+		fat_fs_error_ratelimit(sb, "invalid access to FAT (entry 0x%08x)", entry);
 		return -EIO;
 	}
 
_

Patches currently in -mm which might be from chenl311@chinatelecom.cn are


