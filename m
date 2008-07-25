From: akpm@linux-foundation.org
Subject: - edac-core-fix-added-newline-to-sysfs-dimm-labels.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:04:07 -0700
Message-ID: <200807252304.m6PN47Ac004022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbYGYXEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ajones@riverbed.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: core fix added newline to sysfs dimm labels
has been removed from the -mm tree.  Its filename was
     edac-core-fix-added-newline-to-sysfs-dimm-labels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: core fix added newline to sysfs dimm labels
From: Arthur Jones <ajones@riverbed.com>

The channel DIMM label does not seem to be used much in the edac code. 
However, where it is used (in the core code), it is assumed to not have a
newline embedded.  This leaves the sysfs file newline free which looks
funny when cat'ing it.  Here we just add the trailing newline to the sysfs
chX_dimm_label output...

[Doug Thompson note: the DIMM label is one of the primary uses of EDAC. 
User space daemon scripts, edac-utils@sourceforge, populate the DIMM label
fields, via /sys/devices/system/edac attributes, with the silk screen
labels of the motherboard in use.  dmidecode access BIOS tables, but BIOS
tables are well known to be incorrect and useless in these respects. 
edac-utils will strip off any newlines before its use of the output, when
displaying DIMM slot silk screen labels.

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc_sysfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_mc_sysfs.c~edac-core-fix-added-newline-to-sysfs-dimm-labels drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~edac-core-fix-added-newline-to-sysfs-dimm-labels
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -178,7 +178,11 @@ static ssize_t csrow_edac_mode_show(stru
 static ssize_t channel_dimm_label_show(struct csrow_info *csrow,
 				char *data, int channel)
 {
-	return snprintf(data, EDAC_MC_LABEL_LEN, "%s",
+	/* if field has not been initialized, there is nothing to send */
+	if (!csrow->channels[channel].label[0])
+		return 0;
+
+	return snprintf(data, EDAC_MC_LABEL_LEN, "%s\n",
 			csrow->channels[channel].label);
 }
 
_

Patches currently in -mm which might be from ajones@riverbed.com are

origin.patch

