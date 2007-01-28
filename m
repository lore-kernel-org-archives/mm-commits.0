From: akpm@osdl.org
Subject: + m68k-work-around-binutils-tokenizer-change.patch added to -mm tree
Date: Sun, 28 Jan 2007 14:30:51 -0800
Message-ID: <200701282230.l0SMUpLr004848@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929AbXA1WbW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 17:31:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, geert@linux-m68k.org, viro@zeniv.linux.org.uk, zippel@linux-m68k.org


The patch titled
     m68k: work around binutils tokenizer change
has been added to the -mm tree.  Its filename is
     m68k-work-around-binutils-tokenizer-change.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68k: work around binutils tokenizer change
From: Al Viro <viro@ftp.linux.org.uk>

Recent as(1) doesn't think that .  terminates a macro name, so getuser.l is
_not_ treated as invoking getuser with .l as the first argument. 
arch/m68k/math-emu relies on old behaviour, so it gets a lot of undefined
macros with more or less current binutils.

Note that this behaviour remains in all recent versions and is unrelated to
another binutils problems we used to have for a while (having (%a0)+ parsed
as two arguments).  This one is there to stay; it's an intentional and
documented change.

.irp <identifier> <words>
[text]
.endr
expands to a copy of text per each word, with \<identifier> replaced with
corresponding word.  Again, what happens depends on whether gas_ident.x
is treated as one or as two tokens; in the former case we'll get old_gas
incremented once, in the latter - twice.  The rest is obvious.

Unlike .macro argument list _anything_ is explicitly allowed after
.irp <identifier>; here we are on very safe ground.  And yes, it does
work with all gas variants I've got here (including vanilla 2.15, 2.16,
2.16.1 and 2.17, plus debian and FC binutils).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-m68k/math-emu.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/asm-m68k/math-emu.h~m68k-work-around-binutils-tokenizer-change include/asm-m68k/math-emu.h
--- a/include/asm-m68k/math-emu.h~m68k-work-around-binutils-tokenizer-change
+++ a/include/asm-m68k/math-emu.h
@@ -226,6 +226,21 @@ extern unsigned int fp_debugprint;
 	.previous
 .endm
 
+/* work around binutils idiocy */
+old_gas=-1
+.irp    gas_ident.x .x
+old_gas=old_gas+1
+.endr
+.if !old_gas
+.irp	m b,w,l
+.macro	getuser.\m src,dest,label,addr
+	getuser .\m,\src,\dest,\label,\addr
+.endm
+.macro	putuser.\m src,dest,label,addr
+	putuser .\m,\src,\dest,\label,\addr
+.endm
+.endr
+.endif
 
 .macro	movestack	nr,arg1,arg2,arg3,arg4,arg5
 	.if	\nr
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

m68k-work-around-binutils-tokenizer-change.patch
slab-leaks3-default-y.patch
