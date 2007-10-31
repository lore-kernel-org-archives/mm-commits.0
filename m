From: akpm@linux-foundation.org
Subject: + sanitize-the-type-of-struct-useru_ar0.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:20:59 -0700
Message-ID: <200710312120.l9VLKxdg029121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755077AbXJaVWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:22:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, bryan.wu@analog.com, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, ink@jurassic.park.msu.ru, kernel@wantstofly.org, lethal@linux-sh.org, linux-arch@vger.kernel.org, mingo@redhat.com, paulus@samba.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de, tony.luck@intel.com, ysato@users.sourceforge.jp, zippel@linux-m68k.org


The patch titled
     Sanitize the type of struct user.u_ar0
has been added to the -mm tree.  Its filename is
     sanitize-the-type-of-struct-useru_ar0.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: Sanitize the type of struct user.u_ar0
=46rom: "H. Peter Anvin" <hpa@zytor.com>

struct user.u_ar0 is defined to contain a pointer offset on all
architectures in which it is defined (all architectures which define an
a.out format except SPARC.) However, it has a pointer type in the heade=
rs,
which is pointless -- <asm/user.h> is not exported to userspace, and it
just makes the code messy.

Redefine the field as "unsigned long" (which is the same size as a poin=
ter
on all Linux architectures) and change the setting code to user offseto=
f()
instead of hand-coded arithmetic.

Cc: Linux Arch Mailing List <linux-arch@vger.kernel.org>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: H=C3=A5vard Skinnemoen <hskinnemoen@atmel.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/process.c |    2 +-
 arch/m68k/kernel/process.c     |    2 +-
 arch/x86/ia32/ia32_aout.c      |    2 +-
 fs/binfmt_aout.c               |    2 +-
 include/asm-alpha/user.h       |    2 +-
 include/asm-arm/user.h         |    2 +-
 include/asm-avr32/user.h       |    2 +-
 include/asm-blackfin/user.h    |    2 +-
 include/asm-cris/user.h        |    2 +-
 include/asm-h8300/user.h       |    3 +--
 include/asm-ia64/user.h        |    2 +-
 include/asm-m32r/user.h        |    2 +-
 include/asm-m68k/user.h        |    3 +--
 include/asm-mips/user.h        |    2 +-
 include/asm-powerpc/user.h     |    2 +-
 include/asm-s390/user.h        |    3 +--
 include/asm-sh/user.h          |    2 +-
 include/asm-sh64/user.h        |    2 +-
 include/asm-v850/user.h        |    2 +-
 include/asm-x86/user_32.h      |    2 +-
 include/asm-x86/user_64.h      |    2 +-
 21 files changed, 21 insertions(+), 24 deletions(-)

diff -puN arch/blackfin/kernel/process.c~sanitize-the-type-of-struct-us=
eru_ar0 arch/blackfin/kernel/process.c
--- a/arch/blackfin/kernel/process.c~sanitize-the-type-of-struct-useru_=
ar0
+++ a/arch/blackfin/kernel/process.c
@@ -257,7 +257,7 @@ void dump_thread(struct pt_regs *regs, s
 		    ((unsigned long)(TASK_SIZE -
 				     dump->start_stack)) >> PAGE_SHIFT;
=20
-	dump->u_ar0 =3D (struct user_regs_struct *)((int)&dump->regs - (int)d=
ump);
+	dump->u_ar0 =3D offsetof(struct user, regs);
=20
 	dump->regs.r0 =3D regs->r0;
 	dump->regs.r1 =3D regs->r1;
diff -puN arch/m68k/kernel/process.c~sanitize-the-type-of-struct-useru_=
ar0 arch/m68k/kernel/process.c
--- a/arch/m68k/kernel/process.c~sanitize-the-type-of-struct-useru_ar0
+++ a/arch/m68k/kernel/process.c
@@ -335,7 +335,7 @@ void dump_thread(struct pt_regs * regs,=20
 	if (dump->start_stack < TASK_SIZE)
 		dump->u_ssize =3D ((unsigned long) (TASK_SIZE - dump->start_stack)) =
>> PAGE_SHIFT;
=20
-	dump->u_ar0 =3D (struct user_regs_struct *)((int)&dump->regs - (int)d=
ump);
+	dump->u_ar0 =3D offsetof(struct user, regs);
 	sw =3D ((struct switch_stack *)regs) - 1;
 	dump->regs.d1 =3D regs->d1;
 	dump->regs.d2 =3D regs->d2;
diff -puN arch/x86/ia32/ia32_aout.c~sanitize-the-type-of-struct-useru_a=
r0 arch/x86/ia32/ia32_aout.c
--- a/arch/x86/ia32/ia32_aout.c~sanitize-the-type-of-struct-useru_ar0
+++ a/arch/x86/ia32/ia32_aout.c
@@ -162,7 +162,7 @@ static int aout_core_dump(long signr, st
 	has_dumped =3D 1;
 	current->flags |=3D PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
-	dump.u_ar0 =3D (u32)(((unsigned long)(&dump.regs)) - ((unsigned long)=
(&dump)));
+	dump.u_ar0 =3D offsetof(struct user32, regs);
 	dump.signal =3D signr;
 	dump_thread32(regs, &dump);
=20
diff -puN fs/binfmt_aout.c~sanitize-the-type-of-struct-useru_ar0 fs/bin=
fmt_aout.c
--- a/fs/binfmt_aout.c~sanitize-the-type-of-struct-useru_ar0
+++ a/fs/binfmt_aout.c
@@ -115,7 +115,7 @@ static int aout_core_dump(long signr, st
 	current->flags |=3D PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 #ifndef __sparc__
-	dump.u_ar0 =3D (void *)(((unsigned long)(&dump.regs)) - ((unsigned lo=
ng)(&dump)));
+	dump.u_ar0 =3D offsetof(struct user, regs);
 #endif
 	dump.signal =3D signr;
 	dump_thread(regs, &dump);
diff -puN include/asm-alpha/user.h~sanitize-the-type-of-struct-useru_ar=
0 include/asm-alpha/user.h
--- a/include/asm-alpha/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-alpha/user.h
@@ -39,7 +39,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff -puN include/asm-arm/user.h~sanitize-the-type-of-struct-useru_ar0 =
include/asm-arm/user.h
--- a/include/asm-arm/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-arm/user.h
@@ -67,7 +67,7 @@ struct user{
 				   esp register.  */
   long int signal;     		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
-  struct pt_regs * u_ar0;	/* Used by gdb to help find the values for *=
/
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   unsigned long magic;		/* To uniquely identify a core file */
   char u_comm[32];		/* User command that was responsible */
diff -puN include/asm-avr32/user.h~sanitize-the-type-of-struct-useru_ar=
0 include/asm-avr32/user.h
--- a/include/asm-avr32/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-avr32/user.h
@@ -51,7 +51,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff -puN include/asm-blackfin/user.h~sanitize-the-type-of-struct-useru=
_ar0 include/asm-blackfin/user.h
--- a/include/asm-blackfin/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-blackfin/user.h
@@ -75,7 +75,7 @@ struct user {
 					   esp register.  */
 	long int signal;	/* Signal that caused the core dump. */
 	int reserved;		/* No longer used */
-	struct user_regs_struct *u_ar0;
+	unsigned long u_ar0;
 	/* Used by gdb to help find the values for */
 	/* the registers. */
 	unsigned long magic;	/* To uniquely identify a core file */
diff -puN include/asm-cris/user.h~sanitize-the-type-of-struct-useru_ar0=
 include/asm-cris/user.h
--- a/include/asm-cris/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-cris/user.h
@@ -38,7 +38,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff -puN include/asm-h8300/user.h~sanitize-the-type-of-struct-useru_ar=
0 include/asm-h8300/user.h
--- a/include/asm-h8300/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-h8300/user.h
@@ -62,8 +62,7 @@ struct user{
 				   esp register.  */
   long int signal;     		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
-  struct user_regs_struct *u_ar0;
-				/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   unsigned long magic;		/* To uniquely identify a core file */
   char u_comm[32];		/* User command that was responsible */
diff -puN include/asm-ia64/user.h~sanitize-the-type-of-struct-useru_ar0=
 include/asm-ia64/user.h
--- a/include/asm-ia64/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-ia64/user.h
@@ -44,7 +44,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff -puN include/asm-m32r/user.h~sanitize-the-type-of-struct-useru_ar0=
 include/asm-m32r/user.h
--- a/include/asm-m32r/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-m32r/user.h
@@ -38,7 +38,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff -puN include/asm-m68k/user.h~sanitize-the-type-of-struct-useru_ar0=
 include/asm-m68k/user.h
--- a/include/asm-m68k/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-m68k/user.h
@@ -72,8 +72,7 @@ struct user{
 				   esp register.  */
   long int signal;		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
-  struct user_regs_struct *u_ar0;
-				/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   struct user_m68kfp_struct* u_fpstate;	/* Math Co-processor pointer. =
*/
   unsigned long magic;		/* To uniquely identify a core file */
diff -puN include/asm-mips/user.h~sanitize-the-type-of-struct-useru_ar0=
 include/asm-mips/user.h
--- a/include/asm-mips/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-mips/user.h
@@ -44,7 +44,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff -puN include/asm-powerpc/user.h~sanitize-the-type-of-struct-useru_=
ar0 include/asm-powerpc/user.h
--- a/include/asm-powerpc/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-powerpc/user.h
@@ -38,7 +38,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff -puN include/asm-s390/user.h~sanitize-the-type-of-struct-useru_ar0=
 include/asm-s390/user.h
--- a/include/asm-s390/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-s390/user.h
@@ -63,8 +63,7 @@ struct user {
 				   the top of the stack is always found in the
 				   esp register.  */
   long int signal;     		/* Signal that caused the core dump. */
-  struct user_regs_struct *u_ar0;
-				/* Used by gdb to help find the values for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   unsigned long magic;		/* To uniquely identify a core file */
   char u_comm[32];		/* User command that was responsible */
diff -puN include/asm-sh/user.h~sanitize-the-type-of-struct-useru_ar0 i=
nclude/asm-sh/user.h
--- a/include/asm-sh/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-sh/user.h
@@ -45,7 +45,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	struct user_fpu_struct* u_fpstate;	/* Math Co-processor pointer */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
diff -puN include/asm-sh64/user.h~sanitize-the-type-of-struct-useru_ar0=
 include/asm-sh64/user.h
--- a/include/asm-sh64/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-sh64/user.h
@@ -55,7 +55,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	struct user_fpu_struct* u_fpstate;	/* Math Co-processor pointer */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
diff -puN include/asm-v850/user.h~sanitize-the-type-of-struct-useru_ar0=
 include/asm-v850/user.h
--- a/include/asm-v850/user.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-v850/user.h
@@ -38,7 +38,7 @@ struct user {
 	unsigned long	start_data;		/* data starting address */
 	unsigned long	start_stack;		/* stack starting address */
 	long int	signal;			/* signal causing core dump */
-	struct regs *	u_ar0;			/* help gdb find registers */
+	unsigned long	u_ar0;			/* help gdb find registers */
 	unsigned long	magic;			/* identifies a core file */
 	char		u_comm[32];		/* user command name */
 };
diff -puN include/asm-x86/user_32.h~sanitize-the-type-of-struct-useru_a=
r0 include/asm-x86/user_32.h
--- a/include/asm-x86/user_32.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-x86/user_32.h
@@ -106,7 +106,7 @@ struct user{
 				   esp register.  */
   long int signal;     		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
-  struct user_pt_regs * u_ar0;	/* Used by gdb to help find the values =
for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   struct user_i387_struct* u_fpstate;	/* Math Co-processor pointer. */
   unsigned long magic;		/* To uniquely identify a core file */
diff -puN include/asm-x86/user_64.h~sanitize-the-type-of-struct-useru_a=
r0 include/asm-x86/user_64.h
--- a/include/asm-x86/user_64.h~sanitize-the-type-of-struct-useru_ar0
+++ a/include/asm-x86/user_64.h
@@ -97,7 +97,7 @@ struct user{
   long int signal;     		/* Signal that caused the core dump. */
   int reserved;			/* No longer used */
   int pad1;
-  struct user_pt_regs * u_ar0;	/* Used by gdb to help find the values =
for */
+  unsigned long u_ar0;		/* Used by gdb to help find the values for */
 				/* the registers. */
   struct user_i387_struct* u_fpstate;	/* Math Co-processor pointer. */
   unsigned long magic;		/* To uniquely identify a core file */
_

Patches currently in -mm which might be from hpa@zytor.com are

origin.patch
git-kvm.patch
i386-fix-reboot-with-no-keyboard-attached.patch
x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
unexport-asm-pageh.patch
unexport-asm-userh-and-linux-userh.patch
sanitize-the-type-of-struct-useru_ar0.patch
