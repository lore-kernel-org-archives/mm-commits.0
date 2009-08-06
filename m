From: akpm@linux-foundation.org
Subject: + staging-udlfb-fix-printk-format-warning.patch added to -mm tree
Date: Wed, 05 Aug 2009 17:30:10 -0700
Message-ID: <200908060030.n760UAQx026467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbZHFAaP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 20:30:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     staging/udlfb: fix printk format warning
has been added to the -mm tree.  Its filename is
     staging-udlfb-fix-printk-format-warning.patch

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
Subject: staging/udlfb: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning: use %td for ptrdiff:

drivers/staging/udlfb/udlfb.h:209: warning: format '%d' expects type 'int', but argument 3 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/udlfb/udlfb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/udlfb/udlfb.h~staging-udlfb-fix-printk-format-warning drivers/staging/udlfb/udlfb.h
--- a/drivers/staging/udlfb/udlfb.h~staging-udlfb-fix-printk-format-warning
+++ a/drivers/staging/udlfb/udlfb.h
@@ -205,7 +205,7 @@ static int dlfb_set_video_mode(struct dl
 
 			/* send */
 			ret = dlfb_bulk_msg(dev_info, bufptr - dev_info->buf);
-			printk("ret bulk 2: %d %d\n", ret,
+			printk("ret bulk 2: %d %td\n", ret,
 			       bufptr - dev_info->buf);
 
 			/* flush */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
media-zr364xx-fix-build-errors.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
staging-udlfb-fix-printk-format-warning.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
ummunotify-userspace-support-for-mmu-notifications-v3-fix-fix.patch
add-a-driver-for-the-winbond-wpcd376i-ir-functionality-select-bitreverse.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
reiser4-export-remove_from_page_cache-fix.patch

