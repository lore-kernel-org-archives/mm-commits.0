From: akpm@linux-foundation.org
Subject: - git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:42:17 -0700
Message-ID: <200804261642.m3QGgHj5031187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757705AbYDZQmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, greg@kroah.com, kai.makisara@kolumbus.fi, sfr@canb.auug.org.au, tonyj@suse.de, mm-commits@vger.kernel.org


The patch titled
     git-scsi-misc vs gregkh-driver-driver-core-remove-no-longer-used-struct-class_device
has been removed from the -mm tree.  Its filename was
     git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-scsi-misc vs gregkh-driver-driver-core-remove-no-longer-used-struct-class_device
From: James Bottomley <James.Bottomley@HansenPartnership.com>

On Fri, 2008-03-14 at 12:39 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      revert gregkh-driver-driver-core-remove-no-longer-used-struct-class_device
> has been added to the -mm tree.  Its filename is
>      revert-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
> ------------------------------------------------------
> Subject: revert gregkh-driver-driver-core-remove-no-longer-used-struct-class_device
> From: Andrew Morton <akpm@linux-foundation.org>
>
> This breaks git-scsi-misc.

Try this instead:  It fixes up st to work with Greg's patches; I've got
it combined with 2.6.25-rc5-mc5 all up and running with this patch.

I'm still not sure what the final solution will be.  Either I'll do a
post merge tree to capture all this, or I'll just pull the SCSI piece
from greg's tree into scsi-misc.

There's also a functional problem with ses and the conversion that I'm
looking into.

Cc: Kai Makisara <kai.makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Cc: Tony Jones <tonyj@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/st.c~git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device drivers/scsi/st.c
--- a/drivers/scsi/st.c~git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device
+++ a/drivers/scsi/st.c
@@ -4370,9 +4370,9 @@ st_defcompression_show(struct device *de
 
 DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
 
-static ssize_t st_options_show(struct class_device *class_dev, char *buf)
+static ssize_t st_options_show(struct device *class_dev, struct device_attribute *attr, char *buf)
 {
-	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
+	struct st_modedef *STm = (struct st_modedef *)dev_get_drvdata(class_dev);
 	struct scsi_tape *STp;
 	int i, j, options;
 	ssize_t l = 0;
@@ -4408,7 +4408,7 @@ static ssize_t st_options_show(struct cl
 	return l;
 }
 
-CLASS_DEVICE_ATTR(options, S_IRUGO, st_options_show, NULL);
+DEVICE_ATTR(options, S_IRUGO, st_options_show, NULL);
 
 static int do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 {
@@ -4447,8 +4447,8 @@ static int do_create_class_files(struct 
 		error = device_create_file(st_class_member,
 					   &dev_attr_default_compression);
 		if (error) goto out;
-		error = class_device_create_file(st_class_member,
-				        &class_device_attr_options);
+		error = device_create_file(st_class_member,
+					   &dev_attr_options);
 		if (error) goto out;
 
 		if (mode == 0 && rew == 0) {
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

origin.patch
git-scsi-misc.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
aic79xx_core-remove-ascii-art.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
doc-fix-dma-api-function-parameters.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
remove-duplicated-unlikely-in-is_err.patch

