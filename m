From: akpm@linux-foundation.org
Subject: + fix-mtrr-compat-ioctl.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:59:05 -0800
Message-ID: <200702052159.l15Lx5oO032596@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812AbXBEWAb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:00:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zwane@infradead.org, ak@suse.de, stable@kernel.org


The patch titled
     Fix MTRR compat ioctl
has been added to the -mm tree.  Its filename is
     fix-mtrr-compat-ioctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix MTRR compat ioctl
From: Zwane Mwaikambo <zwane@infradead.org>

The MTRR compat code wasn't calling the lowlevel MTRR setup due to a switch
block not handling the compat case.

Before:
(WW) I810(0): Failed to set up write-combining range (0xd0000000,0x10000000)

After:
reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
reg02: base=0x5f700000 (1527MB), size=   1MB: uncachable, count=1
reg03: base=0x5f800000 (1528MB), size=   8MB: uncachable, count=1
reg04: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/if.c |   33 +++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/if.c~fix-mtrr-compat-ioctl arch/i386/kernel/cpu/mtrr/if.c
--- a/arch/i386/kernel/cpu/mtrr/if.c~fix-mtrr-compat-ioctl
+++ a/arch/i386/kernel/cpu/mtrr/if.c
@@ -158,8 +158,9 @@ mtrr_ioctl(struct file *file, unsigned i
 	struct mtrr_sentry sentry;
 	struct mtrr_gentry gentry;
 	void __user *arg = (void __user *) __arg;
+	unsigned int compat_cmd = cmd;
 
-	switch (cmd) {
+	switch (compat_cmd) {
 	case MTRRIOC_ADD_ENTRY:
 	case MTRRIOC_SET_ENTRY:
 	case MTRRIOC_DEL_ENTRY:
@@ -177,14 +178,20 @@ mtrr_ioctl(struct file *file, unsigned i
 			return -EFAULT;
 		break;
 #ifdef CONFIG_COMPAT
-	case MTRRIOC32_ADD_ENTRY:
-	case MTRRIOC32_SET_ENTRY:
-	case MTRRIOC32_DEL_ENTRY:
-	case MTRRIOC32_KILL_ENTRY:
-	case MTRRIOC32_ADD_PAGE_ENTRY:
-	case MTRRIOC32_SET_PAGE_ENTRY:
-	case MTRRIOC32_DEL_PAGE_ENTRY:
-	case MTRRIOC32_KILL_PAGE_ENTRY: {
+#define MTRR_COMPAT_OP(op, type)\
+	case MTRRIOC32_##op:	\
+	cmd = MTRRIOC_##op;	\
+	goto compat_get_##type
+
+	MTRR_COMPAT_OP(ADD_ENTRY, sentry);
+	MTRR_COMPAT_OP(SET_ENTRY, sentry);
+	MTRR_COMPAT_OP(DEL_ENTRY, sentry);
+	MTRR_COMPAT_OP(KILL_ENTRY, sentry);
+	MTRR_COMPAT_OP(ADD_PAGE_ENTRY, sentry);
+	MTRR_COMPAT_OP(SET_PAGE_ENTRY, sentry);
+	MTRR_COMPAT_OP(DEL_PAGE_ENTRY, sentry);
+	MTRR_COMPAT_OP(KILL_PAGE_ENTRY, sentry);
+compat_get_sentry: {
 		struct mtrr_sentry32 __user *s32 = (struct mtrr_sentry32 __user *)__arg;
 		err = get_user(sentry.base, &s32->base);
 		err |= get_user(sentry.size, &s32->size);
@@ -193,8 +200,9 @@ mtrr_ioctl(struct file *file, unsigned i
 			return err;
 		break;
 	}
-	case MTRRIOC32_GET_ENTRY:
-	case MTRRIOC32_GET_PAGE_ENTRY: {
+	MTRR_COMPAT_OP(GET_ENTRY, gentry);
+	MTRR_COMPAT_OP(GET_PAGE_ENTRY, gentry);
+compat_get_gentry: {
 		struct mtrr_gentry32 __user *g32 = (struct mtrr_gentry32 __user *)__arg;
 		err = get_user(gentry.regnum, &g32->regnum);
 		err |= get_user(gentry.base, &g32->base);
@@ -204,6 +212,7 @@ mtrr_ioctl(struct file *file, unsigned i
 			return err;
 		break;
 	}
+#undef MTRR_COMPAT_OP
 #endif
 	}
 
@@ -317,7 +326,7 @@ mtrr_ioctl(struct file *file, unsigned i
 	if (err)
 		return err;
 
-	switch(cmd) {
+	switch(compat_cmd) {
 	case MTRRIOC_GET_ENTRY:
 	case MTRRIOC_GET_PAGE_ENTRY:
 		if (copy_to_user(arg, &gentry, sizeof gentry))
_

Patches currently in -mm which might be from zwane@infradead.org are

git-agpgart.patch
fix-mtrr-compat-ioctl.patch
