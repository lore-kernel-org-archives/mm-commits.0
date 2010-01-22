From: akpm@linux-foundation.org
Subject: + scsi-sdc-quiet-all-sparse-noise.patch added to -mm tree
Date: Fri, 22 Jan 2010 14:49:48 -0800
Message-ID: <201001222249.o0MMnmTa000783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961Ab0AVWtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 17:49:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, James.Bottomley@suse.de, hsweeten@visionengravers.com


The patch titled
     scsi/sd.c: quiet all sparse noise
has been added to the -mm tree.  Its filename is
     scsi-sdc-quiet-all-sparse-noise.patch

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
Subject: scsi/sd.c: quiet all sparse noise
From: H Hartley Sweeten <hartleys@visionengravers.com>

In sd_store_cache_type the symbol 'len' is declared twice.  Remove the
second declaration to quiet the following sparse warning.

warning: symbol 'len' shadows an earlier one

In sd_probe the variable 'index' is declared as a u32.  This variable is
used in a call to ida_get_new which is expecting an int *.  Make the
variable an int to quiet the following sparse warning.

warning: incorrect type in argument 2 (different signedness)

There are 4 symbols in the file that are not exported and produce
the following sparse warnings.

warning: symbol 'sd_cdb_cache' was not declared. Should it be static?
warning: symbol 'sd_cdb_pool' was not declared. Should it be static?
warning: symbol 'sd_read_protection_type' was not declared. Should it be static?
warning: symbol 'sd_read_app_tag_own' was not declared. Should it be static?

Make them static to quiet the warnings.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/sd.c~scsi-sdc-quiet-all-sparse-noise drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-sdc-quiet-all-sparse-noise
+++ a/drivers/scsi/sd.c
@@ -116,8 +116,8 @@ static DEFINE_IDA(sd_index_ida);
  * object after last put) */
 static DEFINE_MUTEX(sd_ref_mutex);
 
-struct kmem_cache *sd_cdb_cache;
-mempool_t *sd_cdb_pool;
+static struct kmem_cache *sd_cdb_cache;
+static mempool_t *sd_cdb_pool;
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -144,7 +144,7 @@ sd_store_cache_type(struct device *dev, 
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(sd_cache_types); i++) {
-		const int len = strlen(sd_cache_types[i]);
+		len = strlen(sd_cache_types[i]);
 		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
 		    buf[len] == '\n') {
 			ct = i;
@@ -1369,7 +1369,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 /*
  * Determine whether disk supports Data Integrity Field.
  */
-void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
+static void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdp = sdkp->device;
 	u8 type;
@@ -1896,7 +1896,7 @@ defaults:
  * The ATO bit indicates whether the DIF application tag is available
  * for use by the operating system.
  */
-void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
+static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	int res, offset;
 	struct scsi_device *sdp = sdkp->device;
@@ -2221,7 +2221,7 @@ static int sd_probe(struct device *dev)
 	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	u32 index;
+	int index;
 	int error;
 
 	error = -ENODEV;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
scsi-sdc-quiet-all-sparse-noise.patch
init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch
nodemaskh-remove-macro-any_online_node.patch
init-mainc-make-setup_max_cpus-static-for-smp.patch

