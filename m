From: akpm@linux-foundation.org
Subject: - flat-binaries-drop-binfmt_flat-bad-header-magic-warning.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:24 -0500
Message-ID: <200802150719.m1F7Jkpg025733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763074AbYBOHUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, bernds_cb1@t-online.de, gerg@snapgear.com, jie.zhang@analog.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     FLAT binaries: drop BINFMT_FLAT bad header magic warning
has been removed from the -mm tree.  Its filename was
     flat-binaries-drop-binfmt_flat-bad-header-magic-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FLAT binaries: drop BINFMT_FLAT bad header magic warning
From: Mike Frysinger <vapier.adi@gmail.com>

The warning issued by fs/binfmt_flat.c when the format handler is given a
non-FLAT and non-script executable is annoying to say the least when working
with FDPIC ELF objects.  If you build a kernel that supports both FLAT and
FDPIC ELFs on no-mmu, every time you execute an FDPIC ELF, the kernel spits
out this message.  While I understand a lot of newcomers to the no-mmu world
screw up generation of FLAT binaries, this warning is not usable for systems
that support more than just FLAT.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Bernd Schmidt <bernds_cb1@t-online.de>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_flat.c~flat-binaries-drop-binfmt_flat-bad-header-magic-warning fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-binaries-drop-binfmt_flat-bad-header-magic-warning
+++ a/fs/binfmt_flat.c
@@ -443,12 +443,12 @@ static int load_flat_file(struct linux_b
 
 	if (strncmp(hdr->magic, "bFLT", 4)) {
 		/*
+		 * Previously, here was a printk to tell people
+		 *   "BINFMT_FLAT: bad header magic".
+		 * But for the kernel which also use ELF FD-PIC format, this
+		 * error message is confusing.
 		 * because a lot of people do not manage to produce good
-		 * flat binaries,  we leave this printk to help them realise
-		 * the problem.  We only print the error if its not a script file
 		 */
-		if (strncmp(hdr->magic, "#!", 2))
-			printk("BINFMT_FLAT: bad header magic\n");
 		ret = -ENOEXEC;
 		goto err;
 	}
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
git-watchdog.patch
