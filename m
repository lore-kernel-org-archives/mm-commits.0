From: akpm@linux-foundation.org
Subject: + pcmcia-include-bad-cis-filename-in-error-message.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:29:08 -0800
Message-ID: <200712052229.lB5MT8io028336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182AbXLEW3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:29:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     pcmcia: include bad CIS filename in error message
has been added to the -mm tree.  Its filename is
     pcmcia-include-bad-cis-filename-in-error-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pcmcia-fix-kernel-doc-comments.patch
git-dvb.patch
git-kbuild.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
