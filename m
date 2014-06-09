From: akpm@linux-foundation.org
Subject: [merged] fs-pstore-logging-clean-up.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:36:32 -0700
Message-ID: <53960cc0.HTa08BivxD7jc2HO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFITgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, ccross@android.com, anton@enomsg.org, fabf@skynet.be

Subject: [merged] fs-pstore-logging-clean-up.patch removed from -mm tree
To: fabf@skynet.be,anton@enomsg.org,ccross@android.com,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:36:32 -0700


The patch titled
     Subject: fs/pstore: logging clean-up
has been removed from the -mm tree.  Its filename was
     fs-pstore-logging-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/pstore: logging clean-up

- Define pr_fmt in plateform.c and ram_core.c for global prefix.

- Coalesce format fragments.

- Separate format/arguments on lines > 80 characters.

Note: Some pr_foo() were initially declared without prefix and therefore
this could break existing log analyzer.

[akpm@linux-foundation.org: missed a couple of prefix removals]
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/platform.c |   19 +++++++++----------
 fs/pstore/ram_core.c |   36 +++++++++++++++++-------------------
 2 files changed, 26 insertions(+), 29 deletions(-)

diff -puN fs/pstore/platform.c~fs-pstore-logging-clean-up fs/pstore/platform.c
--- a/fs/pstore/platform.c~fs-pstore-logging-clean-up
+++ a/fs/pstore/platform.c
@@ -18,6 +18,8 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) "pstore: " fmt
+
 #include <linux/atomic.h>
 #include <linux/types.h>
 #include <linux/errno.h>
@@ -224,14 +226,12 @@ static void allocate_buf_for_compression
 			zlib_inflate_workspacesize());
 		stream.workspace = kmalloc(size, GFP_KERNEL);
 		if (!stream.workspace) {
-			pr_err("pstore: No memory for compression workspace; "
-				"skipping compression\n");
+			pr_err("No memory for compression workspace; skipping compression\n");
 			kfree(big_oops_buf);
 			big_oops_buf = NULL;
 		}
 	} else {
-		pr_err("No memory for uncompressed data; "
-			"skipping compression\n");
+		pr_err("No memory for uncompressed data; skipping compression\n");
 		stream.workspace = NULL;
 	}
 
@@ -455,8 +455,7 @@ int pstore_register(struct pstore_info *
 		add_timer(&pstore_timer);
 	}
 
-	pr_info("pstore: Registered %s as persistent store backend\n",
-		psi->name);
+	pr_info("Registered %s as persistent store backend\n", psi->name);
 
 	return 0;
 }
@@ -502,8 +501,8 @@ void pstore_get_records(int quiet)
 				size = unzipped_len;
 				compressed = false;
 			} else {
-				pr_err("pstore: decompression failed;"
-					"returned %d\n", unzipped_len);
+				pr_err("decompression failed;returned %d\n",
+				       unzipped_len);
 				compressed = true;
 			}
 		}
@@ -524,8 +523,8 @@ out:
 	mutex_unlock(&psi->read_mutex);
 
 	if (failed)
-		printk(KERN_WARNING "pstore: failed to load %d record(s) from '%s'\n",
-		       failed, psi->name);
+		pr_warn("failed to load %d record(s) from '%s'\n",
+			failed, psi->name);
 }
 
 static void pstore_dowork(struct work_struct *work)
diff -puN fs/pstore/ram_core.c~fs-pstore-logging-clean-up fs/pstore/ram_core.c
--- a/fs/pstore/ram_core.c~fs-pstore-logging-clean-up
+++ a/fs/pstore/ram_core.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) "persistent_ram: " fmt
+
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -205,12 +207,10 @@ static void persistent_ram_ecc_old(struc
 			size = buffer->data + prz->buffer_size - block;
 		numerr = persistent_ram_decode_rs8(prz, block, size, par);
 		if (numerr > 0) {
-			pr_devel("persistent_ram: error in block %p, %d\n",
-			       block, numerr);
+			pr_devel("error in block %p, %d\n", block, numerr);
 			prz->corrected_bytes += numerr;
 		} else if (numerr < 0) {
-			pr_devel("persistent_ram: uncorrectable error in block %p\n",
-				block);
+			pr_devel("uncorrectable error in block %p\n", block);
 			prz->bad_blocks++;
 		}
 		block += prz->ecc_info.block_size;
@@ -257,7 +257,7 @@ static int persistent_ram_init_ecc(struc
 	prz->rs_decoder = init_rs(prz->ecc_info.symsize, prz->ecc_info.poly,
 				  0, 1, prz->ecc_info.ecc_size);
 	if (prz->rs_decoder == NULL) {
-		pr_info("persistent_ram: init_rs failed\n");
+		pr_info("init_rs failed\n");
 		return -EINVAL;
 	}
 
@@ -267,10 +267,10 @@ static int persistent_ram_init_ecc(struc
 	numerr = persistent_ram_decode_rs8(prz, buffer, sizeof(*buffer),
 					   prz->par_header);
 	if (numerr > 0) {
-		pr_info("persistent_ram: error in header, %d\n", numerr);
+		pr_info("error in header, %d\n", numerr);
 		prz->corrected_bytes += numerr;
 	} else if (numerr < 0) {
-		pr_info("persistent_ram: uncorrectable error in header\n");
+		pr_info("uncorrectable error in header\n");
 		prz->bad_blocks++;
 	}
 
@@ -317,7 +317,7 @@ void persistent_ram_save_old(struct pers
 		prz->old_log = kmalloc(size, GFP_KERNEL);
 	}
 	if (!prz->old_log) {
-		pr_err("persistent_ram: failed to allocate buffer\n");
+		pr_err("failed to allocate buffer\n");
 		return;
 	}
 
@@ -396,8 +396,8 @@ static void *persistent_ram_vmap(phys_ad
 
 	pages = kmalloc(sizeof(struct page *) * page_count, GFP_KERNEL);
 	if (!pages) {
-		pr_err("%s: Failed to allocate array for %u pages\n", __func__,
-			page_count);
+		pr_err("%s: Failed to allocate array for %u pages\n",
+		       __func__, page_count);
 		return NULL;
 	}
 
@@ -462,19 +462,17 @@ static int persistent_ram_post_init(stru
 	if (prz->buffer->sig == sig) {
 		if (buffer_size(prz) > prz->buffer_size ||
 		    buffer_start(prz) > buffer_size(prz))
-			pr_info("persistent_ram: found existing invalid buffer,"
-				" size %zu, start %zu\n",
-			       buffer_size(prz), buffer_start(prz));
+			pr_info("found existing invalid buffer, size %zu, start %zu\n",
+				buffer_size(prz), buffer_start(prz));
 		else {
-			pr_debug("persistent_ram: found existing buffer,"
-				" size %zu, start %zu\n",
-			       buffer_size(prz), buffer_start(prz));
+			pr_debug("found existing buffer, size %zu, start %zu\n",
+				 buffer_size(prz), buffer_start(prz));
 			persistent_ram_save_old(prz);
 			return 0;
 		}
 	} else {
-		pr_debug("persistent_ram: no valid data in buffer"
-			" (sig = 0x%08x)\n", prz->buffer->sig);
+		pr_debug("no valid data in buffer (sig = 0x%08x)\n",
+			 prz->buffer->sig);
 	}
 
 	prz->buffer->sig = sig;
@@ -509,7 +507,7 @@ struct persistent_ram_zone *persistent_r
 
 	prz = kzalloc(sizeof(struct persistent_ram_zone), GFP_KERNEL);
 	if (!prz) {
-		pr_err("persistent_ram: failed to allocate persistent ram zone\n");
+		pr_err("failed to allocate persistent ram zone\n");
 		goto err;
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

