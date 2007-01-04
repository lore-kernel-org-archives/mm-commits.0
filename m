From: akpm@osdl.org
Subject: - convert-i386-pda-code-to-use-%fs-ptrace-make-putgetreg-work-again-for-gs-and-fs.patch removed from -mm tree
Date: Thu, 04 Jan 2007 14:17:00 -0800
Message-ID: <200701042217.l04MH2Vk000599@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:58845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965098AbXADWRX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:17:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deweerdt@free.fr, ak@suse.de, frederik.deweerdt@gmail.com, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     ptrace: make {put,get}reg work again for gs and fs
has been removed from the -mm tree.  Its filename was
     convert-i386-pda-code-to-use-%fs-ptrace-make-putgetreg-work-again-for-gs-and-fs.patch

This patch was dropped because it was folded into convert-i386-pda-code-to-use-%fs.patch

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

diff -puN arch/i386/kernel/ptrace.c~convert-i386-pda-code-to-use-%fs-ptrace-make-putgetreg-work-again-for-gs-and-fs arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~convert-i386-pda-code-to-use-%fs-ptrace-make-putgetreg-work-again-for-gs-and-fs
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

convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-ptrace-make-putgetreg-work-again-for-gs-and-fs.patch
disable-init-initramfsc-updated-fix.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-user-ns-unshare.patch
