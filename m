From: akpm@osdl.org
Subject: - git-ubi-mtd_read-arg-fix.patch removed from -mm tree
Date: Wed, 03 Jan 2007 14:20:48 -0800
Message-ID: <200701032220.l03MKm2u000752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55629 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbXACWU7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:20:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@osdl.org, dedekind@infradead.org, mm-commits@vger.kernel.org


The patch titled
     git-ubi: mtd_read() arg fix
has been removed from the -mm tree.  Its filename was
     git-ubi-mtd_read-arg-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-ubi: mtd_read() arg fix
From: Andrew Morton <akpm@osdl.org>

drivers/mtd/ubi/io.c: In function 'mtd_read':
drivers/mtd/ubi/io.c:82: warning: passing argument 4 of 'mtd->read' from incompatible pointer type
drivers/mtd/ubi/io.c: In function 'mtd_write':
drivers/mtd/ubi/io.c:101: warning: passing argument 4 of 'mtd->write' from incompatible pointer type
drivers/mtd/ubi/gluebi.c: In function 'gluebi_read':
drivers/mtd/ubi/gluebi.c:223: warning: passing argument 8 of 'ubi_eba_read_leb' from incompatible pointer type
drivers/mtd/ubi/gluebi.c: In function 'gluebi_write':
drivers/mtd/ubi/gluebi.c:285: warning: passing argument 8 of 'ubi_eba_write_leb' from incompatible pointer type
drivers/mtd/ubi/debug.c: In function 'ubi_dbg_vprint_nolock':
drivers/mtd/ubi/debug.c:470: warning: 'cname' may be used uninitialized in this function
drivers/mtd/ubi/eba.c: In function 'ubi_eba_read_leb':
drivers/mtd/ubi/eba.c:372: warning: 'data_crc' may be used uninitialized in this function
drivers/mtd/ubi/scan.c: In function 'ubi_scan_add_volume':
drivers/mtd/ubi/scan.c:67: warning: 'sv' may be used uninitialized in this function

Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mtd/ubi/badeb.c |    4 +++-
 drivers/mtd/ubi/cdev.c  |    5 +++--
 drivers/mtd/ubi/eba.c   |    6 +++---
 drivers/mtd/ubi/eba.h   |    6 +++---
 drivers/mtd/ubi/io.c    |   32 ++++++++++++++++++++------------
 drivers/mtd/ubi/io.h    |    4 ++--
 drivers/mtd/ubi/misc.c  |    3 ++-
 drivers/mtd/ubi/scan.c  |    8 ++++++--
 drivers/mtd/ubi/uif.c   |    4 ++--
 drivers/mtd/ubi/upd.c   |   11 +++++++----
 drivers/mtd/ubi/vtbl.c  |    8 +++++---
 drivers/mtd/ubi/wl.c    |    4 +++-
 include/linux/mtd/ubi.h |    8 ++++----
 13 files changed, 63 insertions(+), 40 deletions(-)

diff -puN drivers/mtd/ubi/io.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/io.c
--- a/drivers/mtd/ubi/io.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/io.c
@@ -75,7 +75,7 @@ static int paranoid_check_all_ff(const s
  * This is a simple wrapper over mtd->read().
  */
 static inline int mtd_read(const struct ubi_io_info *io, void *buf,
-			   int pnum, int offset, int len, int *read)
+			   int pnum, int offset, int len, size_t *read)
 {
 	loff_t addr = (loff_t)pnum * io->peb_size + offset;
 
@@ -95,7 +95,7 @@ static inline int mtd_read(const struct 
  * This is a simple wrapper over mtd->write().
  */
 static inline int mtd_write(const struct ubi_io_info *io, const void *buf,
-			    int pnum, int offset, int len, int *written)
+			    int pnum, int offset, int len, size_t *written)
 {
 	loff_t addr = (loff_t)pnum * io->peb_size + offset;
 
@@ -103,7 +103,7 @@ static inline int mtd_write(const struct
 }
 
 int ubi_io_read(const struct ubi_info *ubi, void *buf, int pnum, int offset,
-		int len, int *read)
+		int len, size_t *read)
 {
 	int err, tries = 0;
 	const struct ubi_io_info *io = ubi->io;
@@ -144,7 +144,7 @@ retry:
 }
 
 int ubi_io_write(const struct ubi_info *ubi, const void *buf, int pnum,
-		 int offset, int len, int *written)
+		 int offset, int len, size_t *written)
 {
 	int err;
 	const struct ubi_io_info *io = ubi->io;
@@ -296,7 +296,8 @@ static int validate_ec_hdr(const struct 
 int ubi_io_read_ec_hdr(const struct ubi_info *ubi, int pnum,
 		       struct ubi_ec_hdr *ec_hdr, int verbose)
 {
-	int err, err1, read;
+	int err, err1;
+	size_t read;
 	uint32_t crc, magic, hdr_crc;
 
 	dbg_io("read EC header from PEB %d", pnum);
@@ -372,7 +373,8 @@ int ubi_io_read_ec_hdr(const struct ubi_
 int ubi_io_write_ec_hdr(const struct ubi_info *ubi, int pnum,
 			struct ubi_ec_hdr *ec_hdr)
 {
-	int err, written;
+	int err;
+	size_t written;
 	uint32_t crc;
 	const struct ubi_io_info *io = ubi->io;
 
@@ -402,7 +404,8 @@ static int validate_vid_hdr(const struct
 int ubi_io_read_vid_hdr(const struct ubi_info *ubi, int pnum,
 			struct ubi_vid_hdr *vid_hdr, int verbose)
 {
-	int err, err1, read;
+	int err, err1;
+	size_t read;
 	uint32_t crc, magic, hdr_crc;
 	const struct ubi_io_info *io = ubi->io;
 	void *p;
@@ -480,7 +483,8 @@ int ubi_io_read_vid_hdr(const struct ubi
 int ubi_io_write_vid_hdr(const struct ubi_info *ubi, int pnum,
 			 struct ubi_vid_hdr *vid_hdr)
 {
-	int err, written;
+	int err;
+	size_t written;
 	uint32_t crc;
 	const struct ubi_io_info *io = ubi->io;
 	void *p;
@@ -770,7 +774,8 @@ static int ubi_io_torture_peb(const stru
 
 	patt_count = ARRAY_SIZE(patterns);
 	for (i = 0; i < patt_count; i++) {
-		int read, written;
+		size_t read;
+		size_t written;
 
 		err = sync_erase(ubi, pnum);
 		if (unlikely(err))
@@ -1049,7 +1054,8 @@ static int paranoid_check_ec_hdr(const s
  */
 static int paranoid_check_peb_ec_hdr(const struct ubi_info *ubi, int pnum)
 {
-	int err, read;
+	int err;
+	size_t read;
 	uint32_t crc, hdr_crc;
 	struct ubi_ec_hdr *ec_hdr;
 
@@ -1120,7 +1126,8 @@ static int paranoid_check_vid_hdr(const 
  */
 static int paranoid_check_peb_vid_hdr(const struct ubi_info *ubi, int pnum)
 {
-	int err, read;
+	int err;
+	size_t read;
 	uint32_t crc, hdr_crc;
 	struct ubi_vid_hdr *vid_hdr;
 	const struct ubi_io_info *io = ubi->io;
@@ -1173,7 +1180,8 @@ fail:
 static int paranoid_check_all_ff(const struct ubi_info *ubi, int pnum,
 				 int offset, int len)
 {
-	int read, err;
+	size_t read;
+	int err;
 	void *buf;
 	const struct ubi_io_info *io = ubi->io;
 
diff -puN drivers/mtd/ubi/io.h~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/io.h
--- a/drivers/mtd/ubi/io.h~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/io.h
@@ -88,7 +88,7 @@ enum {
  * error (especially %-EBADMSG), the read data does not have to be correct.
  */
 int ubi_io_read(const struct ubi_info *ubi, void *buf, int pnum, int offset,
-		int len, int *read);
+		int len, size_t *read);
 
 /**
  * ubi_io_read_data - read logical eraseblock data from a physical eraseblock.
@@ -133,7 +133,7 @@ int ubi_io_read(const struct ubi_info *u
  * correctly and the same bytes may be read.
  */
 int ubi_io_write(const struct ubi_info *ubi, const void *buf, int pnum,
-		 int offset, int len, int *written);
+		 int offset, int len, size_t *written);
 
 /**
  * ubi_io_write_data - write logical eraseblock data to a physical eraseblock.
diff -puN drivers/mtd/ubi/badeb.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/badeb.c
--- a/drivers/mtd/ubi/badeb.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/badeb.c
@@ -88,7 +88,9 @@ void ubi_beb_maintain_reserved(const str
 int ubi_beb_recover_peb(const struct ubi_info *ubi, int pnum, int vol_id,
 			int lnum, const void *buf, int offset, int len)
 {
-	int err, new_pnum, data_size, read, tries = 0;
+	int err, new_pnum, data_size;
+	size_t read;
+	int tries = 0;
 	struct ubi_vid_hdr *vid_hdr;
 	unsigned char *new_buf;
 
diff -puN drivers/mtd/ubi/eba.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/eba.c
--- a/drivers/mtd/ubi/eba.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/eba.c
@@ -365,7 +365,7 @@ out_unlock:
 }
 
 int ubi_eba_read_leb(const struct ubi_info *ubi, int vol_id, int lnum,
-		     void *buf, int offset, int len, int check, int *read)
+		     void *buf, int offset, int len, int check, size_t *read)
 {
 	int err, pnum, scrub = 0;
 	const struct ubi_vtbl_vtr *vtr;
@@ -496,7 +496,7 @@ out_unlock:
 
 int ubi_eba_write_leb(const struct ubi_info *ubi, int vol_id, int lnum,
 		      const void *buf, int offset, int len,
-		      enum ubi_data_type dtype, int *written,
+		      enum ubi_data_type dtype, size_t *written,
 		      const void *ivol_data)
 {
 	int err, pnum, tries = 0;
@@ -648,7 +648,7 @@ no_bad_eraseblocks:
 
 int ubi_eba_write_leb_st(const struct ubi_info *ubi, int vol_id, int lnum,
 			 const void *buf, int len, enum ubi_data_type dtype,
-			 int *written, int used_ebs)
+			 size_t *written, int used_ebs)
 {
 	int err, pnum, data_size = len, tries = 0;
 	uint32_t leb_ver, crc;
diff -puN drivers/mtd/ubi/eba.h~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/eba.h
--- a/drivers/mtd/ubi/eba.h~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/eba.h
@@ -120,7 +120,7 @@ int ubi_eba_erase_leb(const struct ubi_i
  * error is returned, the read data may be incorrect.
  */
 int ubi_eba_read_leb(const struct ubi_info *ubi, int vol_id, int lnum,
-		     void *buf, int offset, int len, int check, int *read);
+		     void *buf, int offset, int len, int check, size_t *read);
 
 /**
  * ubi_eba_write_leb - write data to a logical eraseblock of a dynamic volume.
@@ -143,7 +143,7 @@ int ubi_eba_read_leb(const struct ubi_in
  */
 int ubi_eba_write_leb(const struct ubi_info *ubi, int vol_id, int lnum,
 		      const void *buf, int offset, int len,
-		      enum ubi_data_type dtype, int *written,
+		      enum ubi_data_type dtype, size_t *written,
 		      const void *ivol_data);
 
 /**
@@ -177,7 +177,7 @@ int ubi_eba_write_leb(const struct ubi_i
  */
 int ubi_eba_write_leb_st(const struct ubi_info *ubi, int vol_id, int lnum,
 			 const void *buf, int len, enum ubi_data_type dtype,
-			 int *written, int used_ebs);
+			 size_t *written, int used_ebs);
 
 /**
  * ubi_eba_leb_is_mapped - check if a logical eraseblock is mapped.
diff -puN drivers/mtd/ubi/cdev.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/cdev.c
--- a/drivers/mtd/ubi/cdev.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/cdev.c
@@ -352,7 +352,7 @@ static ssize_t vol_cdev_read(struct file
 	lnum = tmp;
 
 	do {
-		int read;
+		size_t read;
 
 		cond_resched();
 
@@ -951,7 +951,8 @@ static int check_rsvol_req(const struct 
 static ssize_t vol_cdev_direct_write(struct file *file, const char __user *buf,
 				     size_t count, loff_t *offp)
 {
-	int written, err = 0;
+	size_t written;
+	int err = 0;
 	const struct ubi_vtbl_vtr *vtr;
 	struct ubi_vol_desc *desc = file->private_data;
 	struct ubi_uif_volume *vol = desc->vol;
diff -puN drivers/mtd/ubi/misc.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/misc.c
--- a/drivers/mtd/ubi/misc.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/misc.c
@@ -138,7 +138,8 @@ void ubi_ro_mode(const struct ubi_info *
 int check_volume(const struct ubi_info *ubi, int vol_id)
 {
 	void *buf;
-	int err = 0, i, read;
+	int err = 0, i;
+	size_t read;
 	const struct ubi_vtbl_vtr *vtr;
 
 	vtr = ubi_vtbl_get_vtr(ubi, vol_id);
diff -puN drivers/mtd/ubi/upd.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/upd.c
--- a/drivers/mtd/ubi/upd.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/upd.c
@@ -115,14 +115,16 @@ out_unlock:
 }
 
 static int write_leb(const struct ubi_info *ubi, int vol_id, int lnum,
-		     void *buf, int len, int used_ebs, int *written);
+		     void *buf, int len, int used_ebs, size_t *written);
 
 int ubi_upd_write_data(const struct ubi_info *ubi, int vol_id,
 		       const void __user *buf, int count, int *written)
 {
 	const struct ubi_vtbl_vtr *vtr;
 	struct ubi_upd_info *upd = ubi->upd;
-	int lnum, off, len, wr, err = 0;
+	int lnum, off, len;
+	size_t wr;
+	int err = 0;
 	uint64_t tmp;
 
 	dbg_upd("write %d bytes requested", count);
@@ -427,7 +429,8 @@ void __exit ubi_upd_close(const struct u
  */
 static int put_marker(const struct ubi_info *ubi, int vol_id)
 {
-	int err, written;
+	int err;
+	size_t written;
 	struct ubi_upd_info *upd = ubi->upd;
 
 	dbg_upd("put update marker for volume %d", vol_id);
@@ -514,7 +517,7 @@ static int finish_update(const struct ub
  * volumes.
  */
 static int write_leb(const struct ubi_info *ubi, int vol_id, int lnum,
-		     void *buf, int len, int used_ebs, int *written)
+		     void *buf, int len, int used_ebs, size_t *written)
 {
 	int err;
 	const struct ubi_vtbl_vtr *vtr;
diff -puN drivers/mtd/ubi/uif.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/uif.c
--- a/drivers/mtd/ubi/uif.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/uif.c
@@ -339,7 +339,7 @@ void ubi_close_volume(struct ubi_vol_des
 EXPORT_SYMBOL_GPL(ubi_close_volume);
 
 int ubi_eraseblock_read(struct ubi_vol_desc *udesc, int lnum, char *buf,
-			int offset, int len, int check, int *read)
+			int offset, int len, int check, size_t *read)
 {
 	const struct ubi_vtbl_vtr *vtr;
 	struct ubi_vol_desc *desc = udesc;
@@ -394,7 +394,7 @@ EXPORT_SYMBOL_GPL(ubi_eraseblock_read);
 
 int ubi_eraseblock_write(struct ubi_vol_desc *udesc, int lnum, const void *buf,
 			 int offset, int len, enum ubi_data_type dtype,
-			 int *written)
+			 size_t *written)
 {
 	const struct ubi_vtbl_vtr *vtr;
 	struct ubi_vol_desc *desc = udesc;
diff -puN drivers/mtd/ubi/vtbl.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/vtbl.c
--- a/drivers/mtd/ubi/vtbl.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/vtbl.c
@@ -429,7 +429,7 @@ static int change_volume(const struct ub
 
 	/* Update both volume table copies */
 	for (i = 0; i < UBI_LAYOUT_VOLUME_EBS; i++) {
-		int written;
+		size_t written;
 
 		cond_resched();
 
@@ -578,7 +578,8 @@ static struct ubi_vol_tbl_record __init 
 process_lvol(const struct ubi_info *ubi, struct ubi_scan_info *si,
              struct ubi_scan_volume *sv)
 {
-	int err, read;
+	int err;
+	size_t read;
 	struct rb_node *rb;
 	struct ubi_scan_leb *seb;
 	struct ubi_vtbl_info *vtbl = ubi->vtbl;
@@ -692,7 +693,8 @@ out_free:
 static int __init create_vtbl(const struct ubi_info *ubi,
 			      struct ubi_scan_info *si, int copy, void *vol_tbl)
 {
-	int written, err, tries = 0, pnum, ec;
+	size_t written;
+	int err, tries = 0, pnum, ec;
 	unsigned int leb_ver;
 	struct ubi_vtbl_info *vtbl = ubi->vtbl;
 	static struct ubi_vid_hdr *vid_hdr;
diff -puN drivers/mtd/ubi/wl.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/wl.c
--- a/drivers/mtd/ubi/wl.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/wl.c
@@ -970,7 +970,9 @@ static int erase_worker(const struct ubi
 static int wear_leveling_worker(const struct ubi_info *ubi,
 				struct ubi_bgt_work *wrk, int cancel)
 {
-	int err, tmp, data_size, aldata_size, vol_id, lnum, scrub = 0;
+	int err;
+	size_t tmp;
+	int data_size, aldata_size, vol_id, lnum, scrub = 0;
 	struct ubi_wl_entry *e1, *e2;
 	struct ubi_vid_hdr *vid_hdr;
 	void *buf;
diff -puN include/linux/mtd/ubi.h~git-ubi-mtd_read-arg-fix include/linux/mtd/ubi.h
--- a/include/linux/mtd/ubi.h~git-ubi-mtd_read-arg-fix
+++ a/include/linux/mtd/ubi.h
@@ -238,7 +238,7 @@ void ubi_close_volume(struct ubi_vol_des
  * is still a possibility to read from corrupted static volumes.
  */
 int ubi_eraseblock_read(struct ubi_vol_desc *udesc, int lnum, char *buf,
-			int offset, int len, int check, int *read);
+			int offset, int len, int check, size_t *read);
 
 /**
  * ubi_read - read data from an logical eraseblock (simplified).
@@ -254,7 +254,7 @@ int ubi_eraseblock_read(struct ubi_vol_d
  * does not provide the checking capability.
  */
 static inline int ubi_read(struct ubi_vol_desc *udesc, int lnum, char *buf,
-			   int offset, int len, int *read)
+			   int offset, int len, size_t *read)
 {
 	return ubi_eraseblock_read(udesc, lnum, buf, offset, len, 0, read);
 }
@@ -286,7 +286,7 @@ static inline int ubi_read(struct ubi_vo
  */
 int ubi_eraseblock_write(struct ubi_vol_desc *udesc, int lnum, const void *buf,
 			 int offset, int len, enum ubi_data_type dtype,
-			 int *written);
+			 size_t *written);
 
 /**
  * ubi_write - write data to a logical eraseblock (simplified).
@@ -302,7 +302,7 @@ int ubi_eraseblock_write(struct ubi_vol_
  * does not have the data type argument.
  */
 static inline int ubi_write(struct ubi_vol_desc *udesc, int lnum,
-			    const void *buf, int offset, int len, int *written)
+			const void *buf, int offset, int len, size_t *written)
 {
 	return ubi_eraseblock_write(udesc, lnum, buf, offset, len,
 				    UBI_DATA_UNKNOWN, written);
diff -puN drivers/mtd/ubi/scan.c~git-ubi-mtd_read-arg-fix drivers/mtd/ubi/scan.c
--- a/drivers/mtd/ubi/scan.c~git-ubi-mtd_read-arg-fix
+++ a/drivers/mtd/ubi/scan.c
@@ -544,7 +544,9 @@ static int __init add_volume(const struc
 	 * check data CRC of this logical eraseblock.
 	 */
 	if (vid_hdr->copy_flag) {
-		int len, read, err;
+		int len;
+		size_t read;
+		int err;
 		void *buf;
 		uint32_t data_crc, crc;
 
@@ -612,7 +614,9 @@ static int __init compare_lebs(const str
 			       const struct ubi_vid_hdr *vid_hdr)
 {
 	void *buf;
-	int err, ret, read, len;
+	int err, ret;
+	size_t read;
+	int len;
 	uint32_t data_crc, crc;
 	uint32_t leb_ver = ubi32_to_cpu(vid_hdr->leb_ver);
 	long long abs, v1 = seb->leb_ver, v2 = leb_ver;
_

Patches currently in -mm which might be from akpm@osdl.org are

start_kernel-test-if-irqs-got-enabled-early-barf-and-disable-them-again-fix.patch
kernelparams-detect-if-and-which-parameter-parsing-enabled-irqs-fix.patch
pci-prevent-down_read-when-pci_devices-is-empty-fix.patch
atiixp-old-drivers-ide-layer-driver-for-the-atiixp-hang-tidy.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
pci-avoid-taking-pci_bus_sem-early-in-boot.patch
down_write-preserve-local-irqs.patch
shrink_all_memory-fix-lru_pages-handling.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
git-alsa-fixup.patch
sound-hda-detect-alc883-on-msi-k9a-platinum-motherboards.patch
git-agpgart.patch
cifs-sprintf-fix.patch
git-cpufreq.patch
fix-gregkh-driver-driver-core-fix-race-in-sysfs-between-sysfs_remove_file-and-read-write.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-input.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mtd.patch
git-ubi.patch
ubi-missing-include.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-use-bitrev8.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-qla3xxx-fixup.patch
nokia-e70-is-an-unusual-device.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
revert-x86_64-mm-copy-user-nocache.patch
add-memcpy_uncached_read.patch
add-i386-idle-notifier-take-3-fix.patch
fix-fake-numa-for-x86_64-machines-with-big-io-hole-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
bluetooth-blacklist-lenovo-r60e.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
ecryptfs-public-key-packet-management-slab-fix.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
toshiba-tc86c001-ide-driver-take-2-fix-2.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
remove-invalidate_inode_pages.patch
vmi-versus-hrtimers.patch
gtod-persistent-clock-support-i386.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i386-drivers.patch
debugging-feature-proc-timer_list-warning-fix.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
hpt3xx-rework-rate-filtering-tidy.patch
jmicron-warning-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
