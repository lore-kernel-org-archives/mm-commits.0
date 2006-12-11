From: akpm@osdl.org
Subject: + m68k-work-around-binutils-tokenizer-change.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:18:56 -0800
Message-ID: <200612112018.kBBKIuZ3006031@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33052 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937638AbWLKUTl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:19:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, geert@linux-m68k.org, viro@zeniv.linux.org.uk, zippel@linux-m68k.org


The patch titled
     m68k: work around binutils tokenizer change
has been added to the -mm tree.  Its filename is
     m68k-work-around-binutils-tokenizer-change.patch

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

Patch works by having a macro with name that would be treated differently
by new and old rules; if expanded, it adds definition for getuser.b, etc.
via getuser.  Old as(1) sees
definition of gas_workaround with one argument
redefinition of gas_workaround (with empty body and ignored argument)
invocation of gas_workaround with .x as argument
=> expands to nothing
New as(1) sees
definition of gas_workaround.x
definition of gas_workaround (independent from gas_workaround.x)
invocation of gas_workaround.x
=> expands to definitions of getuser.l, etc.

IOW, the trigger for workaround is precisely the behaviour we need to work
around.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-m68k/math-emu.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

diff -puN include/asm-m68k/math-emu.h~m68k-work-around-binutils-tokenizer-change include/asm-m68k/math-emu.h
--- a/include/asm-m68k/math-emu.h~m68k-work-around-binutils-tokenizer-change
+++ a/include/asm-m68k/math-emu.h
@@ -226,6 +226,20 @@ extern unsigned int fp_debugprint;
 	.previous
 .endm
 
+/* work around binutils idiocy */
+.macro  gas_workaround.x
+.irp	m b,w,l
+.macro  getuser.\m src,dest,label,addr
+        getuser .\m,"\src","\dest","\label","\addr"
+.endm
+.macro  putuser.\m src,dest,label,addr
+	putuser .\m,"\src","\dest","\label","\addr"
+.endm
+.endr
+.endm
+.macro  gas_workaround x=0
+.endm
+        gas_workaround.x
 
 .macro	movestack	nr,arg1,arg2,arg3,arg4,arg5
 	.if	\nr
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
m68k-work-around-binutils-tokenizer-change.patch
config_computone-should-depend-on-isaeisapci.patch
appldata_mem-dependes-on-vm-counters.patch
uml-problems-with-linux-ioh.patch
missing-includes-in-hilkbd.patch
hci-endianness-annotations.patch
lockd-endianness-annotations-rebased.patch
slab-leaks3-default-y.patch

