From: akpm@linux-foundation.org
Subject: + ecryptfs-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:20:34 -0800
Message-ID: <200803052220.m25MKYRl024018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764658AbYCEWVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:21:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     ecryptfs-replace-remaining-__function__-occurrences.patch

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
Subject: ecryptfs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |   32 ++++++++++++++++----------------
 fs/ecryptfs/ecryptfs_kernel.h |    2 +-
 fs/ecryptfs/inode.c           |    2 +-
 fs/ecryptfs/main.c            |    2 +-
 fs/ecryptfs/mmap.c            |   18 +++++++++---------
 fs/ecryptfs/read_write.c      |   16 ++++++++--------
 6 files changed, 36 insertions(+), 36 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-replace-remaining-__function__-occurrences fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-replace-remaining-__function__-occurrences
+++ a/fs/ecryptfs/crypto.c
@@ -119,21 +119,21 @@ static int ecryptfs_calculate_md5(char *
 	if (rc) {
 		printk(KERN_ERR
 		       "%s: Error initializing crypto hash; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out;
 	}
 	rc = crypto_hash_update(&desc, &sg, len);
 	if (rc) {
 		printk(KERN_ERR
 		       "%s: Error updating crypto hash; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out;
 	}
 	rc = crypto_hash_final(&desc, dst);
 	if (rc) {
 		printk(KERN_ERR
 		       "%s: Error finalizing crypto hash; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out;
 	}
 out:
@@ -437,7 +437,7 @@ static int ecryptfs_encrypt_extent(struc
 	if (rc < 0) {
 		printk(KERN_ERR "%s: Error attempting to encrypt page with "
 		       "page->index = [%ld], extent_offset = [%ld]; "
-		       "rc = [%d]\n", __FUNCTION__, page->index, extent_offset,
+		       "rc = [%d]\n", __func__, page->index, extent_offset,
 		       rc);
 		goto out;
 	}
@@ -487,7 +487,7 @@ int ecryptfs_encrypt_page(struct page *p
 						       0, PAGE_CACHE_SIZE);
 		if (rc)
 			printk(KERN_ERR "%s: Error attempting to copy "
-			       "page at index [%ld]\n", __FUNCTION__,
+			       "page at index [%ld]\n", __func__,
 			       page->index);
 		goto out;
 	}
@@ -508,7 +508,7 @@ int ecryptfs_encrypt_page(struct page *p
 					     extent_offset);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting extent; "
-			       "rc = [%d]\n", __FUNCTION__, rc);
+			       "rc = [%d]\n", __func__, rc);
 			goto out;
 		}
 		ecryptfs_lower_offset_for_extent(
@@ -569,7 +569,7 @@ static int ecryptfs_decrypt_extent(struc
 	if (rc < 0) {
 		printk(KERN_ERR "%s: Error attempting to decrypt to page with "
 		       "page->index = [%ld], extent_offset = [%ld]; "
-		       "rc = [%d]\n", __FUNCTION__, page->index, extent_offset,
+		       "rc = [%d]\n", __func__, page->index, extent_offset,
 		       rc);
 		goto out;
 	}
@@ -622,7 +622,7 @@ int ecryptfs_decrypt_page(struct page *p
 						      ecryptfs_inode);
 		if (rc)
 			printk(KERN_ERR "%s: Error attempting to copy "
-			       "page at index [%ld]\n", __FUNCTION__,
+			       "page at index [%ld]\n", __func__,
 			       page->index);
 		goto out;
 	}
@@ -656,7 +656,7 @@ int ecryptfs_decrypt_page(struct page *p
 					     extent_offset);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting extent; "
-			       "rc = [%d]\n", __FUNCTION__, rc);
+			       "rc = [%d]\n", __func__, rc);
 			goto out;
 		}
 	}
@@ -1215,7 +1215,7 @@ int ecryptfs_read_and_validate_header_re
 				 ecryptfs_inode);
 	if (rc) {
 		printk(KERN_ERR "%s: Error reading header region; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out;
 	}
 	if (!contains_ecryptfs_marker(data + ECRYPTFS_FILE_SIZE_BYTES)) {
@@ -1319,7 +1319,7 @@ ecryptfs_write_metadata_to_contents(stru
 				  0, crypt_stat->num_header_bytes_at_front);
 	if (rc)
 		printk(KERN_ERR "%s: Error attempting to write header "
-		       "information to lower file; rc = [%d]\n", __FUNCTION__,
+		       "information to lower file; rc = [%d]\n", __func__,
 		       rc);
 	return rc;
 }
@@ -1364,14 +1364,14 @@ int ecryptfs_write_metadata(struct dentr
 		}
 	} else {
 		printk(KERN_WARNING "%s: Encrypted flag not set\n",
-		       __FUNCTION__);
+		       __func__);
 		rc = -EINVAL;
 		goto out;
 	}
 	/* Released in this function */
 	virt = kzalloc(crypt_stat->num_header_bytes_at_front, GFP_KERNEL);
 	if (!virt) {
-		printk(KERN_ERR "%s: Out of memory\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Out of memory\n", __func__);
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -1379,7 +1379,7 @@ int ecryptfs_write_metadata(struct dentr
 					 ecryptfs_dentry);
 	if (unlikely(rc)) {
 		printk(KERN_ERR "%s: Error whilst writing headers; rc = [%d]\n",
-		       __FUNCTION__, rc);
+		       __func__, rc);
 		goto out_free;
 	}
 	if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
@@ -1390,7 +1390,7 @@ int ecryptfs_write_metadata(struct dentr
 							 ecryptfs_dentry, virt);
 	if (rc) {
 		printk(KERN_ERR "%s: Error writing metadata out to lower file; "
-		       "rc = [%d]\n", __FUNCTION__, rc);
+		       "rc = [%d]\n", __func__, rc);
 		goto out_free;
 	}
 out_free:
@@ -1584,7 +1584,7 @@ int ecryptfs_read_metadata(struct dentry
 	if (!page_virt) {
 		rc = -ENOMEM;
 		printk(KERN_ERR "%s: Unable to allocate page_virt\n",
-		       __FUNCTION__);
+		       __func__);
 		goto out;
 	}
 	rc = ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-replace-remaining-__function__-occurrences fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-replace-remaining-__function__-occurrences
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -500,7 +500,7 @@ ecryptfs_set_dentry_lower_mnt(struct den
 }
 
 #define ecryptfs_printk(type, fmt, arg...) \
-        __ecryptfs_printk(type "%s: " fmt, __FUNCTION__, ## arg);
+        __ecryptfs_printk(type "%s: " fmt, __func__, ## arg);
 void __ecryptfs_printk(const char *fmt, ...);
 
 extern const struct file_operations ecryptfs_main_fops;
diff -puN fs/ecryptfs/inode.c~ecryptfs-replace-remaining-__function__-occurrences fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-replace-remaining-__function__-occurrences
+++ a/fs/ecryptfs/inode.c
@@ -121,7 +121,7 @@ ecryptfs_do_create(struct inode *directo
 					     ecryptfs_dentry, mode, nd);
 	if (rc) {
 		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
-		       "rc = [%d]\n", __FUNCTION__, rc);
+		       "rc = [%d]\n", __func__, rc);
 		goto out_lock;
 	}
 	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
diff -puN fs/ecryptfs/main.c~ecryptfs-replace-remaining-__function__-occurrences fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-replace-remaining-__function__-occurrences
+++ a/fs/ecryptfs/main.c
@@ -219,7 +219,7 @@ int ecryptfs_interpose(struct dentry *lo
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to initialize the "
 		       "persistent file for the dentry with name [%s]; "
-		       "rc = [%d]\n", __FUNCTION__, dentry->d_name.name, rc);
+		       "rc = [%d]\n", __func__, dentry->d_name.name, rc);
 		goto out;
 	}
 out:
diff -puN fs/ecryptfs/mmap.c~ecryptfs-replace-remaining-__function__-occurrences fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-replace-remaining-__function__-occurrences
+++ a/fs/ecryptfs/mmap.c
@@ -153,7 +153,7 @@ ecryptfs_copy_up_encrypted_with_header(s
 			flush_dcache_page(page);
 			if (rc) {
 				printk(KERN_ERR "%s: Error reading xattr "
-				       "region; rc = [%d]\n", __FUNCTION__, rc);
+				       "region; rc = [%d]\n", __func__, rc);
 				goto out;
 			}
 		} else {
@@ -169,7 +169,7 @@ ecryptfs_copy_up_encrypted_with_header(s
 			if (rc) {
 				printk(KERN_ERR "%s: Error attempting to read "
 				       "extent at offset [%lld] in the lower "
-				       "file; rc = [%d]\n", __FUNCTION__,
+				       "file; rc = [%d]\n", __func__,
 				       lower_offset, rc);
 				goto out;
 			}
@@ -212,7 +212,7 @@ static int ecryptfs_readpage(struct file
 				       "the encrypted content from the lower "
 				       "file whilst inserting the metadata "
 				       "from the xattr into the header; rc = "
-				       "[%d]\n", __FUNCTION__, rc);
+				       "[%d]\n", __func__, rc);
 				goto out;
 			}
 
@@ -293,7 +293,7 @@ static int ecryptfs_prepare_write(struct
 			if (rc) {
 				printk(KERN_ERR "%s: Error attemping to read "
 				       "lower page segment; rc = [%d]\n",
-				       __FUNCTION__, rc);
+				       __func__, rc);
 				ClearPageUptodate(page);
 				goto out;
 			} else
@@ -308,7 +308,7 @@ static int ecryptfs_prepare_write(struct
 					       "from the lower file whilst "
 					       "inserting the metadata from "
 					       "the xattr into the header; rc "
-					       "= [%d]\n", __FUNCTION__, rc);
+					       "= [%d]\n", __func__, rc);
 					ClearPageUptodate(page);
 					goto out;
 				}
@@ -320,7 +320,7 @@ static int ecryptfs_prepare_write(struct
 				if (rc) {
 					printk(KERN_ERR "%s: Error reading "
 					       "page; rc = [%d]\n",
-					       __FUNCTION__, rc);
+					       __func__, rc);
 					ClearPageUptodate(page);
 					goto out;
 				}
@@ -331,7 +331,7 @@ static int ecryptfs_prepare_write(struct
 			if (rc) {
 				printk(KERN_ERR "%s: Error decrypting page "
 				       "at index [%ld]; rc = [%d]\n",
-				       __FUNCTION__, page->index, rc);
+				       __func__, page->index, rc);
 				ClearPageUptodate(page);
 				goto out;
 			}
@@ -348,7 +348,7 @@ static int ecryptfs_prepare_write(struct
 			if (rc) {
 				printk(KERN_ERR "%s: Error on attempt to "
 				       "truncate to (higher) offset [%lld];"
-				       " rc = [%d]\n", __FUNCTION__,
+				       " rc = [%d]\n", __func__,
 				       prev_page_end_size, rc);
 				goto out;
 			}
@@ -389,7 +389,7 @@ static int ecryptfs_write_inode_size_to_
 	kfree(file_size_virt);
 	if (rc)
 		printk(KERN_ERR "%s: Error writing file size to header; "
-		       "rc = [%d]\n", __FUNCTION__, rc);
+		       "rc = [%d]\n", __func__, rc);
 out:
 	return rc;
 }
diff -puN fs/ecryptfs/read_write.c~ecryptfs-replace-remaining-__function__-occurrences fs/ecryptfs/read_write.c
--- a/fs/ecryptfs/read_write.c~ecryptfs-replace-remaining-__function__-occurrences
+++ a/fs/ecryptfs/read_write.c
@@ -55,7 +55,7 @@ int ecryptfs_write_lower(struct inode *e
 	set_fs(fs_save);
 	if (octets_written < 0) {
 		printk(KERN_ERR "%s: octets_written = [%td]; "
-		       "expected [%td]\n", __FUNCTION__, octets_written, size);
+		       "expected [%td]\n", __func__, octets_written, size);
 		rc = -EINVAL;
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
@@ -153,7 +153,7 @@ int ecryptfs_write(struct file *ecryptfs
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
 			       "index [%ld] from eCryptfs inode "
-			       "mapping; rc = [%d]\n", __FUNCTION__,
+			       "mapping; rc = [%d]\n", __func__,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
@@ -165,7 +165,7 @@ int ecryptfs_write(struct file *ecryptfs
 			if (rc) {
 				printk(KERN_ERR "%s: Error decrypting "
 				       "page; rc = [%d]\n",
-				       __FUNCTION__, rc);
+				       __func__, rc);
 				ClearPageUptodate(ecryptfs_page);
 				page_cache_release(ecryptfs_page);
 				goto out;
@@ -202,7 +202,7 @@ int ecryptfs_write(struct file *ecryptfs
 		page_cache_release(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting "
-			       "page; rc = [%d]\n", __FUNCTION__, rc);
+			       "page; rc = [%d]\n", __func__, rc);
 			goto out;
 		}
 		pos += num_bytes;
@@ -254,7 +254,7 @@ int ecryptfs_read_lower(char *data, loff
 	set_fs(fs_save);
 	if (octets_read < 0) {
 		printk(KERN_ERR "%s: octets_read = [%td]; "
-		       "expected [%td]\n", __FUNCTION__, octets_read, size);
+		       "expected [%td]\n", __func__, octets_read, size);
 		rc = -EINVAL;
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
@@ -327,7 +327,7 @@ int ecryptfs_read(char *data, loff_t off
 		printk(KERN_ERR "%s: Attempt to read data past the end of the "
 			"file; offset = [%lld]; size = [%td]; "
 		       "ecryptfs_file_size = [%lld]\n",
-		       __FUNCTION__, offset, size, ecryptfs_file_size);
+		       __func__, offset, size, ecryptfs_file_size);
 		goto out;
 	}
 	pos = offset;
@@ -345,14 +345,14 @@ int ecryptfs_read(char *data, loff_t off
 			rc = PTR_ERR(ecryptfs_page);
 			printk(KERN_ERR "%s: Error getting page at "
 			       "index [%ld] from eCryptfs inode "
-			       "mapping; rc = [%d]\n", __FUNCTION__,
+			       "mapping; rc = [%d]\n", __func__,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
 		rc = ecryptfs_decrypt_page(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error decrypting "
-			       "page; rc = [%d]\n", __FUNCTION__, rc);
+			       "page; rc = [%d]\n", __func__, rc);
 			ClearPageUptodate(ecryptfs_page);
 			page_cache_release(ecryptfs_page);
 			goto out;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
sh-replace-remaining-__function__-occurences.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
ext4-replace-remaining-__function__-occurrences.patch
nfs-replace-remaining-__function__-occurrences.patch
xfs-replace-remaining-__function__-occurrences.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cifs-replace-remaining-__function__-occurrences.patch
reiserfs-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch

