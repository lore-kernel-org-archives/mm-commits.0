From: akpm@osdl.org
Subject: + ptrace-make-putgetreg-work-again-for-gs-and-fs.patch added to -mm tree
Date: Thu, 21 Dec 2006 23:03:40 -0800
Message-ID: <200612220703.kBM73eI0016438@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50924 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423190AbWLVHDt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Dec 2006 02:03:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, ak@suse.de, frederik.deweerdt@gmail.com, jeremy@goop.org


The patch titled
     ptrace: make {put,get}reg work again for gs and fs
has been added to the -mm tree.  Its filename is
     ptrace-make-putgetreg-work-again-for-gs-and-fs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ptrace: make {put,get}reg work again for gs and fs
From: Frederik Deweerdt <deweerdt@free.fr>

Following the i386 pda patches, it's not possible to set gs or fs value from
gdb anymore.  When you use gdb/ptrace to modify %fs, the value gets written in
the wrong place.

The patch restores the old behaviour of getting and setting thread.gs of
thread.fs respectively.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/ptrace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/ptrace.c~ptrace-make-putgetreg-work-again-for-gs-and-fs arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~ptrace-make-putgetreg-work-again-for-gs-and-fs
+++ a/arch/i386/kernel/ptrace.c
@@ -89,14 +89,14 @@ static int putreg(struct task_struct *ch
 	unsigned long regno, unsigned long value)
 {
 	switch (regno >> 2) {
-		case FS:
+		case GS:
 			if (value && (value & 3) != 3)
 				return -EIO;
-			child->thread.fs = value;
+			child->thread.gs = value;
 			return 0;
 		case DS:
 		case ES:
-		case GS:
+		case FS:
 			if (value && (value & 3) != 3)
 				return -EIO;
 			value &= 0xffff;
_

Patches currently in -mm which might be from deweerdt@free.fr are

ptrace-fix-efl_offset-value-according-to-i386-pda-changes.patch
ptrace-make-putgetreg-work-again-for-gs-and-fs.patch
disable-init-initramfsc-updated-fix.patch

