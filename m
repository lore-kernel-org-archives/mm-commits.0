From: akpm@linux-foundation.org
Subject: - pcmcia-include-bad-cis-filename-in-error-message.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:08 -0800
Message-ID: <200802052226.m15MQnlv011652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761745AbYBEWnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia: include bad CIS filename in error message
has been removed from the -mm tree.  Its filename was
     pcmcia-include-bad-cis-filename-in-error-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: include bad CIS filename in error message
From: Randy Dunlap <randy.dunlap@oracle.com>

- Print the invalid CIS filename in the invalid filename message.
- Use sizeof() instead of hard-coded constant for buffer size.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/ds.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/pcmcia/ds.c~pcmcia-include-bad-cis-filename-in-error-message drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~pcmcia-include-bad-cis-filename-in-error-message
+++ a/drivers/pcmcia/ds.c
@@ -865,11 +865,12 @@ static int pcmcia_load_firmware(struct p
 	ds_dbg(1, "trying to load CIS file %s\n", filename);
 
 	if (strlen(filename) > 14) {
-		printk(KERN_WARNING "pcmcia: CIS filename is too long\n");
+		printk(KERN_WARNING "pcmcia: CIS filename is too long [%s]\n",
+			filename);
 		return -EINVAL;
 	}
 
-	snprintf(path, 20, "%s", filename);
+	snprintf(path, sizeof(path), "%s", filename);
 
 	if (request_firmware(&fw, path, &dev->dev) == 0) {
 		if (fw->size >= CISTPL_MAX_CIS_SIZE) {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
