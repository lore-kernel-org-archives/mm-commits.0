From: akpm@linux-foundation.org
Subject: + random-kmalloc-failure-ignored-in-init_std_data.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:49:28 -0700
Message-ID: <200909292149.n8TLnS1A019413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385AbZI2VuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mpm@selenic.com


The patch titled
     random: kmalloc failure ignored in init_std_data()
has been added to the -mm tree.  Its filename is
     random-kmalloc-failure-ignored-in-init_std_data.patch

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
Subject: random: kmalloc failure ignored in init_std_data()
From: Roel Kluin <roel.kluin@gmail.com>

kmalloc may fail so build the array into the statically allocated pool
structures instead.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/char/random.c~random-kmalloc-failure-ignored-in-init_std_data drivers/char/random.c
--- a/drivers/char/random.c~random-kmalloc-failure-ignored-in-init_std_data
+++ a/drivers/char/random.c
@@ -400,6 +400,8 @@ module_param(debug, bool, 0644);
  *
  **********************************************************************/
 
+#define EXTRACT_SIZE 10
+
 struct entropy_store;
 struct entropy_store {
 	/* read-only data: */
@@ -414,7 +416,9 @@ struct entropy_store {
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
-	__u8 *last_data;
+#ifdef CONFIG_CRYPTO_FIPS
+	__u8 last_data[EXTRACT_SIZE];
+#endif
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -714,8 +718,6 @@ void add_disk_randomness(struct gendisk 
 }
 #endif
 
-#define EXTRACT_SIZE 10
-
 /*********************************************************************
  *
  * Entropy extraction routines
@@ -951,9 +953,6 @@ static void init_std_data(struct entropy
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
-	/* Enable continuous test in fips mode */
-	if (fips_enabled)
-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
 }
 
 static int rand_initialize(void)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
random-kmalloc-failure-ignored-in-init_std_data.patch

