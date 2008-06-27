From: akpm@linux-foundation.org
Subject: + edac-core-fix-workq-timer.patch added to -mm tree
Date: Fri, 27 Jun 2008 16:09:10 -0700
Message-ID: <200806272309.m5RN9B2E010816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763312AbYF0XJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 19:09:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajones@riverbed.com, dougthompson@xmission.com


The patch titled
     edac: core fix workq timer
has been added to the -mm tree.  Its filename is
     edac-core-fix-workq-timer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: core fix workq timer
From: Arthur Jones <ajones@riverbed.com>

When updating the edac_mc_poll_msec module parameter from the sysfs
/sys/module/edac_core/parameters/edac_mc_poll_msec file, we don't update
the workq timers.  So that, if we move from a big poll time to a small
one, the small one won't take effect until the big one has timed out.

Here we provide a new module parameter set method to call out to the
update routine.  This brings the /sys/module/edac_core/parameters
functionality up to that provided by the /sys/drivers/system/edac/mc sysfs
module parameter files so that we can remove them or at least link to the
/sys/module files...

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc_sysfs.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_mc_sysfs.c~edac-core-fix-workq-timer drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~edac-core-fix-workq-timer
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -44,6 +44,25 @@ int edac_mc_get_poll_msec(void)
 	return edac_mc_poll_msec;
 }
 
+static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
+{
+	long l;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = strict_strtol(val, 0, &l);
+	if (ret == -EINVAL || ((int)l != l))
+		return -EINVAL;
+	*((int *)kp->arg) = l;
+
+	/* notify edac_mc engine to reset the poll period */
+	edac_mc_reset_delay_period(l);
+
+	return 0;
+}
+
 /* Parameter declarations for above */
 module_param(edac_mc_panic_on_ue, int, 0644);
 MODULE_PARM_DESC(edac_mc_panic_on_ue, "Panic on uncorrected error: 0=off 1=on");
@@ -53,7 +72,8 @@ MODULE_PARM_DESC(edac_mc_log_ue,
 module_param(edac_mc_log_ce, int, 0644);
 MODULE_PARM_DESC(edac_mc_log_ce,
 		 "Log correctable error to console: 0=off 1=on");
-module_param(edac_mc_poll_msec, int, 0644);
+module_param_call(edac_mc_poll_msec, edac_set_poll_msec, param_get_int,
+		  &edac_mc_poll_msec, 0644);
 MODULE_PARM_DESC(edac_mc_poll_msec, "Polling period in milliseconds");
 
 /*
_

Patches currently in -mm which might be from ajones@riverbed.com are

edac-i5100-new-intel-chipset-driver.patch
edac-i5100-fix-missing-bits.patch
edac-i5100-fix-enable-ecc-hardware.patch
edac-i5100-fix-unmask-ecc-bits.patch
edac-core-fix-to-use-dynamic-kobject.patch
edac-core-fix-workq-timer.patch
edac-core-fix-redundant-sysfs-controls-to-parameters.patch
edac-core-fix-static-to-dynamic-kset.patch
edac-core-fix-added-newline-to-sysfs-dimm-labels.patch

