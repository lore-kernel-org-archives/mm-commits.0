From: akpm@linux-foundation.org
Subject: + firmware-fix-the-request_firmware-dummy.patch added to -mm tree
Date: Tue, 24 Jun 2008 00:33:27 -0700
Message-ID: <200806240733.m5O7XRMN006986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbYFXHds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 03:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, bunk@kernel.org, rjw@sisk.pl, toralf.foerster@gmx.de


The patch titled
     firmware: fix the request_firmware() dummy
has been added to the -mm tree.  Its filename is
     firmware-fix-the-request_firmware-dummy.patch

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
Subject: firmware: fix the request_firmware() dummy
From: James Bottomley <James.Bottomley@HansenPartnership.com>

> the build (.config attached) failed, make ends with :
> ...
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      vmlinux
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33bab): undefined reference to `request_firmware'
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x33c3f): undefined reference to `release_firmware'
> make: *** [vmlinux] Error 1

There's a slight fault in the stub logic.  It fails for FW_LOADER=m and
the user =y.

This should fix it.

This patch fixes the following 2.6.26-rc regression:
  http://bugzilla.kernel.org/show_bug.cgi?id=10730

Reviewed-by: Toralf Foerster <toralf.foerster@gmx.de>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/firmware.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/firmware.h~firmware-fix-the-request_firmware-dummy include/linux/firmware.h
--- a/include/linux/firmware.h~firmware-fix-the-request_firmware-dummy
+++ a/include/linux/firmware.h
@@ -13,7 +13,7 @@ struct firmware {
 
 struct device;
 
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
 int request_firmware_nowait(
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

firmware-fix-the-request_firmware-dummy.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
ipr-use-memory_read_from_buffer.patch
qla2xxx-use-memory_read_from_buffer.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
scsi-sr-avoids-useless-buffer-allocation.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch

