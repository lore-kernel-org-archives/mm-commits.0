From: akpm@linux-foundation.org
Subject: +
 kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 16:02:29 -0700
Message-ID: <523b8285.7ex+vqYNJeAtVibL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3ISXCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, robinmholt@linux.com, fei.li@intel.com, chuansheng.liu@intel.com

Subject: + kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch added to -mm tree
To: chuansheng.liu@intel.com,fei.li@intel.com,robinmholt@linux.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:02:29 -0700


The patch titled
     Subject: kernel/reboot.c: re-enable the function of variable reboot_default
has been added to the -mm tree.  Its filename is
     kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chuansheng Liu <chuansheng.liu@intel.com>
Subject: kernel/reboot.c: re-enable the function of variable reboot_default

1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic kernel")
did some cleanup for reboot= command line, but it made the reboot_default
inoperative.

The default value of variable reboot_default should be 1, and if command
line reboot= is not set, system will use the default reboot mode.

Signed-off-by: Li Fei <fei.li@intel.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Acked-by: Robin Holt <robinmholt@linux.com>
Cc: <stable@vger.kernel.org>	[3.11.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN kernel/reboot.c~kernel-rebootc-re-enable-the-function-of-variable-reboot_default kernel/reboot.c
--- a/kernel/reboot.c~kernel-rebootc-re-enable-the-function-of-variable-reboot_default
+++ a/kernel/reboot.c
@@ -32,7 +32,14 @@ EXPORT_SYMBOL(cad_pid);
 #endif
 enum reboot_mode reboot_mode DEFAULT_REBOOT_MODE;
 
-int reboot_default;
+/*
+ * This variable is used privately to keep track of whether or not
+ * reboot_type is still set to its default value (i.e., reboot= hasn't
+ * been set on the command line).  This is needed so that we can
+ * suppress DMI scanning for reboot quirks.  Without it, it's
+ * impossible to override a faulty reboot quirk without recompiling.
+*/
+int reboot_default = 1;
 int reboot_cpu;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
_

Patches currently in -mm which might be from chuansheng.liu@intel.com are

kernel-rebootc-re-enable-the-function-of-variable-reboot_default.patch
linux-next.patch

