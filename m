From: akpm@linux-foundation.org
Subject: + kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch added to -mm tree
Date: Thu, 10 Jun 2010 16:46:30 -0700
Message-ID: <201006102346.o5ANkVAn030128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942Ab0FJXrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 19:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, hpa@zytor.com, mingo@elte.hu, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de


The patch titled
     kernel.h: add HW_ERR printk prefix for hardware error logging
has been added to the -mm tree.  Its filename is
     kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch

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
Subject: kernel.h: add HW_ERR printk prefix for hardware error logging
From: Huang Ying <ying.huang@intel.com>

This makes hardware error related log in printk log more explicit. So
that the users can report it to hardware vendor instead of LKML or
software vendor.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/kernel.h~kernelh-add-hw_err-printk-prefix-for-hardware-error-logging include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-hw_err-printk-prefix-for-hardware-error-logging
+++ a/include/linux/kernel.h
@@ -247,6 +247,13 @@ extern struct pid *session_of_pgrp(struc
 #define FW_WARN		"[Firmware Warn]: "
 #define FW_INFO		"[Firmware Info]: "
 
+/*
+ * HW_ERR
+ * Add this to a message for hardware errors, so that user can report
+ * it to hardware vendor instead of LKML or software vendor.
+ */
+#define HW_ERR		"[Hardware Error]: "
+
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch

