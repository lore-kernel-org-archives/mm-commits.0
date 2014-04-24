From: akpm@linux-foundation.org
Subject: + fs-pstore-logging-clean-up.patch added to -mm tree
Date: Thu, 24 Apr 2014 10:53:00 -0700
Message-ID: <53594f7c.eGe5k1C2t+m7xTzg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbaDXRxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Apr 2014 13:53:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, ccross@android.com, anton@enomsg.org, fabf@skynet.be

Subject: + fs-pstore-logging-clean-up.patch added to -mm tree
To: fabf@skynet.be,anton@enomsg.org,ccross@android.com,joe@perches.com
From: akpm@linux-foundation.org
Date: Thu, 24 Apr 2014 10:53:00 -0700


The patch titled
     Subject: fs/pstore: logging clean-up
has been added to the -mm tree.  Its filename is
     fs-pstore-logging-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-pstore-logging-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-pstore-logging-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/pstore: logging clean-up

-Define pr_fmt in plateform.c and ram_core.c for global prefix.

-Coalesce format fragments.

-Separate format/arguments on lines > 80 characters.

Note: Some pr_foo() were initially declared without prefix and therefore
this could break existing log analyzer.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joe Perches <joe@perches.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/platform.c |   16 ++++++++--------
 fs/pstore/ram_core.c |   36 +++++++++++++++++-------------------
 2 files changed, 25 insertions(+), 27 deletions(-)

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
 
@@ -502,8 +502,8 @@ void pstore_get_records(int quiet)
 				size = unzipped_len;
 				compressed = false;
 			} else {
-				pr_err("pstore: decompression failed;"
-					"returned %d\n", unzipped_len);
+				pr_err("pstore: decompression failed;returned %d\n",
+				       unzipped_len);
 				compressed = true;
 			}
 		}
@@ -524,8 +524,8 @@ out:
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

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

