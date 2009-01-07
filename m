From: akpm@linux-foundation.org
Subject: - ecryptfs-filename-encryption-mount-option.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:26 -0800
Message-ID: <200901072218.n07MIQo3017906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763389AbZAGWh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Filename Encryption: mount option
has been removed from the -mm tree.  Its filename was
     ecryptfs-filename-encryption-mount-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Filename Encryption: mount option
From: Michael Halcrow <mhalcrow@us.ibm.com>

Enable mount-wide filename encryption by providing the Filename Encryption
Key (FNEK) signature as a mount option.  Note that the ecryptfs-utils
userspace package versions 61 or later support this option.

When mounting with ecryptfs-utils version 61 or later, the mount helper
will detect the availability of the passphrase-based filename encryption
in the kernel (via the eCryptfs sysfs handle) and query the user
interactively as to whether or not he wants to enable the feature for the
mount.  If the user enables filename encryption, the mount helper will
then prompt for the FNEK signature that the user wishes to use, suggesting
by default the signature for the mount passphrase that the user has
already entered for encrypting the file contents.

When not using the mount helper, the user can specify the signature for
the passphrase key with the ecryptfs_fnek_sig= mount option.  This key
must be available in the user's keyring.  The mount helper usually takes
care of this step.  If, however, the user is not mounting with the mount
helper, then he will need to enter the passphrase key into his keyring
with some other utility prior to mounting, such as ecryptfs-manager.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |  126 +++++++++++++++++++++++++++++++++----------
 1 file changed, 99 insertions(+), 27 deletions(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-filename-encryption-mount-option fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-filename-encryption-mount-option
+++ a/fs/ecryptfs/main.c
@@ -206,7 +206,9 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ec
        ecryptfs_opt_cipher, ecryptfs_opt_ecryptfs_cipher,
        ecryptfs_opt_ecryptfs_key_bytes,
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
-       ecryptfs_opt_encrypted_view, ecryptfs_opt_err };
+       ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
+       ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
+       ecryptfs_opt_err };
 
 static const match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
@@ -217,6 +219,9 @@ static const match_table_t tokens = {
 	{ecryptfs_opt_passthrough, "ecryptfs_passthrough"},
 	{ecryptfs_opt_xattr_metadata, "ecryptfs_xattr_metadata"},
 	{ecryptfs_opt_encrypted_view, "ecryptfs_encrypted_view"},
+	{ecryptfs_opt_fnek_sig, "ecryptfs_fnek_sig=%s"},
+	{ecryptfs_opt_fn_cipher, "ecryptfs_fn_cipher=%s"},
+	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=%u"},
 	{ecryptfs_opt_err, NULL}
 };
 
@@ -281,8 +286,11 @@ static int ecryptfs_parse_options(struct
 	int rc = 0;
 	int sig_set = 0;
 	int cipher_name_set = 0;
+	int fn_cipher_name_set = 0;
 	int cipher_key_bytes;
 	int cipher_key_bytes_set = 0;
+	int fn_cipher_key_bytes;
+	int fn_cipher_key_bytes_set = 0;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(sb)->mount_crypt_stat;
 	substring_t args[MAX_OPT_ARGS];
@@ -290,7 +298,12 @@ static int ecryptfs_parse_options(struct
 	char *sig_src;
 	char *cipher_name_dst;
 	char *cipher_name_src;
+	char *fn_cipher_name_dst;
+	char *fn_cipher_name_src;
+	char *fnek_dst;
+	char *fnek_src;
 	char *cipher_key_bytes_src;
+	char *fn_cipher_key_bytes_src;
 
 	if (!options) {
 		rc = -EINVAL;
@@ -322,10 +335,7 @@ static int ecryptfs_parse_options(struct
 				global_default_cipher_name;
 			strncpy(cipher_name_dst, cipher_name_src,
 				ECRYPTFS_MAX_CIPHER_NAME_SIZE);
-			ecryptfs_printk(KERN_DEBUG,
-					"The mount_crypt_stat "
-					"global_default_cipher_name set to: "
-					"[%s]\n", cipher_name_dst);
+			cipher_name_dst[ECRYPTFS_MAX_CIPHER_NAME_SIZE] = '\0';
 			cipher_name_set = 1;
 			break;
 		case ecryptfs_opt_ecryptfs_key_bytes:
@@ -335,11 +345,6 @@ static int ecryptfs_parse_options(struct
 						   &cipher_key_bytes_src, 0);
 			mount_crypt_stat->global_default_cipher_key_size =
 				cipher_key_bytes;
-			ecryptfs_printk(KERN_DEBUG,
-					"The mount_crypt_stat "
-					"global_default_cipher_key_size "
-					"set to: [%d]\n", mount_crypt_stat->
-					global_default_cipher_key_size);
 			cipher_key_bytes_set = 1;
 			break;
 		case ecryptfs_opt_passthrough:
@@ -356,11 +361,51 @@ static int ecryptfs_parse_options(struct
 			mount_crypt_stat->flags |=
 				ECRYPTFS_ENCRYPTED_VIEW_ENABLED;
 			break;
+		case ecryptfs_opt_fnek_sig:
+			fnek_src = args[0].from;
+			fnek_dst =
+				mount_crypt_stat->global_default_fnek_sig;
+			strncpy(fnek_dst, fnek_src, ECRYPTFS_SIG_SIZE_HEX);
+			mount_crypt_stat->global_default_fnek_sig[
+				ECRYPTFS_SIG_SIZE_HEX] = '\0';
+			rc = ecryptfs_add_global_auth_tok(
+				mount_crypt_stat,
+				mount_crypt_stat->global_default_fnek_sig);
+			if (rc) {
+				printk(KERN_ERR "Error attempting to register "
+				       "global fnek sig [%s]; rc = [%d]\n",
+				       mount_crypt_stat->global_default_fnek_sig,
+				       rc);
+				goto out;
+			}
+			mount_crypt_stat->flags |=
+				(ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES
+				 | ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK);
+			break;
+		case ecryptfs_opt_fn_cipher:
+			fn_cipher_name_src = args[0].from;
+			fn_cipher_name_dst =
+				mount_crypt_stat->global_default_fn_cipher_name;
+			strncpy(fn_cipher_name_dst, fn_cipher_name_src,
+				ECRYPTFS_MAX_CIPHER_NAME_SIZE);
+			mount_crypt_stat->global_default_fn_cipher_name[
+				ECRYPTFS_MAX_CIPHER_NAME_SIZE] = '\0';
+			fn_cipher_name_set = 1;
+			break;
+		case ecryptfs_opt_fn_cipher_key_bytes:
+			fn_cipher_key_bytes_src = args[0].from;
+			fn_cipher_key_bytes =
+				(int)simple_strtol(fn_cipher_key_bytes_src,
+						   &fn_cipher_key_bytes_src, 0);
+			mount_crypt_stat->global_default_fn_cipher_key_bytes =
+				fn_cipher_key_bytes;
+			fn_cipher_key_bytes_set = 1;
+			break;
 		case ecryptfs_opt_err:
 		default:
-			ecryptfs_printk(KERN_WARNING,
-					"eCryptfs: unrecognized option '%s'\n",
-					p);
+			printk(KERN_WARNING
+			       "%s: eCryptfs: unrecognized option [%s]\n",
+			       __func__, p);
 		}
 	}
 	if (!sig_set) {
@@ -374,33 +419,60 @@ static int ecryptfs_parse_options(struct
 		int cipher_name_len = strlen(ECRYPTFS_DEFAULT_CIPHER);
 
 		BUG_ON(cipher_name_len >= ECRYPTFS_MAX_CIPHER_NAME_SIZE);
-
 		strcpy(mount_crypt_stat->global_default_cipher_name,
 		       ECRYPTFS_DEFAULT_CIPHER);
 	}
-	if (!cipher_key_bytes_set) {
+	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
+	    && !fn_cipher_name_set)
+		strcpy(mount_crypt_stat->global_default_fn_cipher_name,
+		       mount_crypt_stat->global_default_cipher_name);
+	if (!cipher_key_bytes_set)
 		mount_crypt_stat->global_default_cipher_key_size = 0;
-	}
+	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
+	    && !fn_cipher_key_bytes_set)
+		mount_crypt_stat->global_default_fn_cipher_key_bytes =
+			mount_crypt_stat->global_default_cipher_key_size;
 	mutex_lock(&key_tfm_list_mutex);
 	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
-				 NULL))
+				 NULL)) {
 		rc = ecryptfs_add_new_key_tfm(
 			NULL, mount_crypt_stat->global_default_cipher_name,
 			mount_crypt_stat->global_default_cipher_key_size);
-	mutex_unlock(&key_tfm_list_mutex);
-	if (rc) {
-		printk(KERN_ERR "Error attempting to initialize cipher with "
-		       "name = [%s] and key size = [%td]; rc = [%d]\n",
-		       mount_crypt_stat->global_default_cipher_name,
-		       mount_crypt_stat->global_default_cipher_key_size, rc);
-		rc = -EINVAL;
-		goto out;
+		if (rc) {
+			printk(KERN_ERR "Error attempting to initialize "
+			       "cipher with name = [%s] and key size = [%td]; "
+			       "rc = [%d]\n",
+			       mount_crypt_stat->global_default_cipher_name,
+			       mount_crypt_stat->global_default_cipher_key_size,
+			       rc);
+			rc = -EINVAL;
+			mutex_unlock(&key_tfm_list_mutex);
+			goto out;
+		}
 	}
+	if ((mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
+	    && !ecryptfs_tfm_exists(
+		    mount_crypt_stat->global_default_fn_cipher_name, NULL)) {
+		rc = ecryptfs_add_new_key_tfm(
+			NULL, mount_crypt_stat->global_default_fn_cipher_name,
+			mount_crypt_stat->global_default_fn_cipher_key_bytes);
+		if (rc) {
+			printk(KERN_ERR "Error attempting to initialize "
+			       "cipher with name = [%s] and key size = [%td]; "
+			       "rc = [%d]\n",
+			       mount_crypt_stat->global_default_fn_cipher_name,
+			       mount_crypt_stat->global_default_fn_cipher_key_bytes,
+			       rc);
+			rc = -EINVAL;
+			mutex_unlock(&key_tfm_list_mutex);
+			goto out;
+		}
+	}
+	mutex_unlock(&key_tfm_list_mutex);
 	rc = ecryptfs_init_global_auth_toks(mount_crypt_stat);
-	if (rc) {
+	if (rc)
 		printk(KERN_WARNING "One or more global auth toks could not "
 		       "properly register; rc = [%d]\n", rc);
-	}
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
notify_change-callers-must-hold-i_mutex.patch

