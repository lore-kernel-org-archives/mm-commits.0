From: akpm@linux-foundation.org
Subject: + x86-i8259-only-register-sysdev-for-real-pic.patch added to -mm tree
Date: Thu, 03 Jun 2010 09:45:51 -0700
Message-ID: <201006031645.o53GjlZx003535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756779Ab0FCQqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 12:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adam@os.inf.tu-dresden.de, hpa@zytor.com, jacob.jun.pan@intel.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de


The patch titled
     x86, i8259: only register sysdev for real PIC
has been added to the -mm tree.  Its filename is
     x86-i8259-only-register-sysdev-for-real-pic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, i8259: only register sysdev for real PIC
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

My platform makes use of the null_legacy_pic choice and oopses when doing
a shutdown as the shutdown code goes through all the registered sysdevs
and calls their shutdown method which in my case poke on a non-existing
i8259.  Imho the i8259 specific sysdev should only be registered if the
i8259 is actually there.

Do not register the sysdev function when the null_legacy_pic is used so
that the i8259 resume, suspend and shutdown functions are not called.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/i8259.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/i8259.c~x86-i8259-only-register-sysdev-for-real-pic arch/x86/kernel/i8259.c
--- a/arch/x86/kernel/i8259.c~x86-i8259-only-register-sysdev-for-real-pic
+++ a/arch/x86/kernel/i8259.c
@@ -276,16 +276,6 @@ static struct sys_device device_i8259A =
 	.cls	= &i8259_sysdev_class,
 };
 
-static int __init i8259A_init_sysfs(void)
-{
-	int error = sysdev_class_register(&i8259_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_i8259A);
-	return error;
-}
-
-device_initcall(i8259A_init_sysfs);
-
 static void mask_8259A(void)
 {
 	unsigned long flags;
@@ -407,3 +397,19 @@ struct legacy_pic default_legacy_pic = {
 };
 
 struct legacy_pic *legacy_pic = &default_legacy_pic;
+
+static int __init i8259A_init_sysfs(void)
+{
+	int error;
+
+	if (legacy_pic != &default_legacy_pic)
+		return 0;
+
+	error = sysdev_class_register(&i8259_sysdev_class);
+	if (!error)
+		error = sysdev_register(&device_i8259A);
+	return error;
+}
+
+device_initcall(i8259A_init_sysfs);
+
_

Patches currently in -mm which might be from adam@os.inf.tu-dresden.de are

x86-i8259-only-register-sysdev-for-real-pic.patch

