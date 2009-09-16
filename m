From: akpm@linux-foundation.org
Subject: + ssb-sdio-fix-printk-format-warnings.patch added to -mm tree
Date: Wed, 16 Sep 2009 16:49:56 -0700
Message-ID: <200909162349.n8GNnuPi032646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760181AbZIPXu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Sep 2009 19:50:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mb@bu3sch.de


The patch titled
     ssb/sdio: fix printk format warnings
has been added to the -mm tree.  Its filename is
     ssb-sdio-fix-printk-format-warnings.patch

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
Subject: ssb/sdio: fix printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

drivers/ssb/sdio.c:336: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'size_t'
drivers/ssb/sdio.c:443: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/sdio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ssb/sdio.c~ssb-sdio-fix-printk-format-warnings drivers/ssb/sdio.c
--- a/drivers/ssb/sdio.c~ssb-sdio-fix-printk-format-warnings
+++ a/drivers/ssb/sdio.c
@@ -333,7 +333,7 @@ static void ssb_sdio_block_read(struct s
 		goto out;
 
 err_out:
-	dev_dbg(ssb_sdio_dev(bus), "%04X:%04X (width=%u, len=%u), error %d\n",
+	dev_dbg(ssb_sdio_dev(bus), "%04X:%04X (width=%u, len=%zu), error %d\n",
 		bus->sdio_sbaddr >> 16, offset, reg_width, saved_count, error);
 out:
 	sdio_release_host(bus->host_sdio);
@@ -440,7 +440,7 @@ static void ssb_sdio_block_write(struct 
 		goto out;
 
 err_out:
-	dev_dbg(ssb_sdio_dev(bus), "%04X:%04X (width=%u, len=%u), error %d\n",
+	dev_dbg(ssb_sdio_dev(bus), "%04X:%04X (width=%u, len=%zu), error %d\n",
 		bus->sdio_sbaddr >> 16, offset, reg_width, saved_count, error);
 out:
 	sdio_release_host(bus->host_sdio);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
cciss-fix-schedule_timeout-parameters.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
flex_array-add-missing-kerneldoc-annotations.patch
ssb-sdio-fix-printk-format-warnings.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
docs-fix-various-documentation-paths-in-header-files.patch
reiser4-export-remove_from_page_cache-fix.patch

