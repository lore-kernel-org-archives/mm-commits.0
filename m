From: akpm@linux-foundation.org
Subject: + time-dont-inline-export_symbol-functions.patch added to -mm tree
Date: Fri, 11 May 2012 13:09:02 -0700
Message-ID: <20120511200902.C39A5A037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46448 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab2EKUJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 May 2012 16:09:04 -0400
Received: by qcsp5 with SMTP id p5so412846qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 11 May 2012 13:09:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gregkh@linuxfoundation.org, john.stultz@linaro.org, mcharleb@qualcomm.com, paul.gortmaker@windriver.com, pyu@redhat.com, tglx@linutronix.de


The patch titled
     Subject: time: don't inline EXPORT_SYMBOL functions
has been added to the -mm tree.  Its filename is
     time-dont-inline-export_symbol-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: time: don't inline EXPORT_SYMBOL functions

How is the compiler even handling exported functions that are marked
inline?  Anyway, these shouldn't be inline because of that, so remove that
marking.

Based on a larger patch by Mark Charlebois to get LLVM to build the
kernel.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Charlebois <mcharleb@qualcomm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: hank <pyu@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/time.c~time-dont-inline-export_symbol-functions kernel/time.c
--- a/kernel/time.c~time-dont-inline-export_symbol-functions
+++ a/kernel/time.c
@@ -232,7 +232,7 @@ EXPORT_SYMBOL(current_fs_time);
  * Avoid unnecessary multiplications/divisions in the
  * two most common HZ cases:
  */
-inline unsigned int jiffies_to_msecs(const unsigned long j)
+unsigned int jiffies_to_msecs(const unsigned long j)
 {
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
 	return (MSEC_PER_SEC / HZ) * j;
@@ -248,7 +248,7 @@ inline unsigned int jiffies_to_msecs(con
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
 
-inline unsigned int jiffies_to_usecs(const unsigned long j)
+unsigned int jiffies_to_usecs(const unsigned long j)
 {
 #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
 	return (USEC_PER_SEC / HZ) * j;
_
Subject: Subject: time: don't inline EXPORT_SYMBOL functions

Patches currently in -mm which might be from gregkh@linuxfoundation.org are

linux-next.patch
time-dont-inline-export_symbol-functions.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch
backlight-add-lm3533-backlight-driver.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch

