From: akpm@linux-foundation.org
Subject: + fix-gregkh-usb-usb-isp1760-hcd-driver.patch added to -mm tree
Date: Wed, 30 Apr 2008 14:14:35 -0700
Message-ID: <200804302114.m3ULEZa7003416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757858AbYD3VPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 17:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     gregkh-usb-usb-isp1760-hcd-driver: fix printk format
has been added to the -mm tree.  Its filename is
     fix-gregkh-usb-usb-isp1760-hcd-driver.patch

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
Subject: gregkh-usb-usb-isp1760-hcd-driver: fix printk format
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in isp1760 (in linux-next):

next-20080430/drivers/usb/host/isp1760-hcd.c:994: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
next-20080430/drivers/usb/host/isp1760-hcd.c:1092: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/isp1760-hcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/host/isp1760-hcd.c~fix-gregkh-usb-usb-isp1760-hcd-driver drivers/usb/host/isp1760-hcd.c
--- a/drivers/usb/host/isp1760-hcd.c~fix-gregkh-usb-usb-isp1760-hcd-driver
+++ a/drivers/usb/host/isp1760-hcd.c
@@ -988,7 +988,7 @@ static void do_atl_int(struct usb_hcd *u
 			 * This did not trigger for a long time now.
 			 */
 			printk(KERN_ERR "Reloading ptd %p/%p... qh %p readed: "
-					"%d of %d done: %08x cur: %08x\n", qtd,
+					"%d of %zu done: %08x cur: %08x\n", qtd,
 					urb, qh, PTD_XFERRED_LENGTH(dw3),
 					qtd->length, done_map,
 					(1 << queue_entry));
@@ -1088,7 +1088,7 @@ static void do_atl_int(struct usb_hcd *u
 		} else if (usb_pipebulk(urb->pipe) && (length < qtd->length)) {
 			/* short BULK received */
 
-			printk(KERN_ERR "short bulk, %d instead %d\n", length,
+			printk(KERN_ERR "short bulk, %d instead %zu\n", length,
 					qtd->length);
 			if (urb->transfer_flags & URB_SHORT_NOT_OK) {
 				urb->status = -EREMOTEIO;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch
docbook-fix-vmalloc-missing-parameter-notation.patch
rapidio-fix-docbook-references.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

