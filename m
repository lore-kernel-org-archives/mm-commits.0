From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-assignments-in-if-statements.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:46 -0700
Message-ID: <200710162040.l9GKekmF015720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935166AbXJPVHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: remove assignments in if-statements
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-assignments-in-if-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: remove assignments in if-statements
From: Michael Halcrow <mhalcrow@us.ibm.com>

Remove assignments in if-statements.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c    |   17 ++++++-----
 fs/ecryptfs/file.c      |    8 +++--
 fs/ecryptfs/inode.c     |   35 ++++++++++++++----------
 fs/ecryptfs/keystore.c  |   55 ++++++++++++++++++++------------------
 fs/ecryptfs/main.c      |   28 +++++++++++--------
 fs/ecryptfs/messaging.c |    5 ++-
 fs/ecryptfs/mmap.c      |    5 ++-
 7 files changed, 89 insertions(+), 64 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-remove-assignments-in-if-statements fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-remove-assignments-in-if-statements
+++ a/fs/ecryptfs/crypto.c
@@ -1277,8 +1277,8 @@ static int ecryptfs_read_header_region(c
 	mm_segment_t oldfs;
 	int rc;
 
-	if ((rc = ecryptfs_open_lower_file(&lower_file, dentry, mnt,
-					   O_RDONLY))) {
+	rc = ecryptfs_open_lower_file(&lower_file, dentry, mnt, O_RDONLY);
+	if (rc) {
 		printk(KERN_ERR
 		       "Error opening lower_file to read header region\n");
 		goto out;
@@ -1289,7 +1289,8 @@ static int ecryptfs_read_header_region(c
 	rc = lower_file->f_op->read(lower_file, (char __user *)data,
 			      ECRYPTFS_DEFAULT_EXTENT_SIZE, &lower_file->f_pos);
 	set_fs(oldfs);
-	if ((rc = ecryptfs_close_lower_file(lower_file))) {
+	rc = ecryptfs_close_lower_file(lower_file);
+	if (rc) {
 		printk(KERN_ERR "Error closing lower_file\n");
 		goto out;
 	}
@@ -1951,9 +1952,10 @@ ecryptfs_add_new_key_tfm(struct ecryptfs
 	strncpy(tmp_tfm->cipher_name, cipher_name,
 		ECRYPTFS_MAX_CIPHER_NAME_SIZE);
 	tmp_tfm->key_size = key_size;
-	if ((rc = ecryptfs_process_key_cipher(&tmp_tfm->key_tfm,
-					      tmp_tfm->cipher_name,
-					      &tmp_tfm->key_size))) {
+	rc = ecryptfs_process_key_cipher(&tmp_tfm->key_tfm,
+					 tmp_tfm->cipher_name,
+					 &tmp_tfm->key_size);
+	if (rc) {
 		printk(KERN_ERR "Error attempting to initialize key TFM "
 		       "cipher with name = [%s]; rc = [%d]\n",
 		       tmp_tfm->cipher_name, rc);
@@ -1988,7 +1990,8 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 		}
 	}
 	mutex_unlock(&key_tfm_list_mutex);
-	if ((rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0))) {
+	rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0);
+	if (rc) {
 		printk(KERN_ERR "Error adding new key_tfm to list; rc = [%d]\n",
 		       rc);
 		goto out;
diff -puN fs/ecryptfs/file.c~ecryptfs-remove-assignments-in-if-statements fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-remove-assignments-in-if-statements
+++ a/fs/ecryptfs/file.c
@@ -230,8 +230,9 @@ static int ecryptfs_open(struct inode *i
 		lower_flags &= ~O_APPEND;
 	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
 	/* Corresponding fput() in ecryptfs_release() */
-	if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-					   lower_flags))) {
+	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
+				      lower_flags);
+	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error opening lower file\n");
 		goto out_puts;
 	}
@@ -300,7 +301,8 @@ static int ecryptfs_release(struct inode
 	struct inode *lower_inode = ecryptfs_inode_to_lower(inode);
 	int rc;
 
-	if ((rc = ecryptfs_close_lower_file(lower_file))) {
+	rc = ecryptfs_close_lower_file(lower_file);
+	if (rc) {
 		printk(KERN_ERR "Error closing lower_file\n");
 		goto out;
 	}
diff -puN fs/ecryptfs/inode.c~ecryptfs-remove-assignments-in-if-statements fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-remove-assignments-in-if-statements
+++ a/fs/ecryptfs/inode.c
@@ -202,8 +202,9 @@ static int ecryptfs_initialize_file(stru
 	lower_flags = ((O_CREAT | O_TRUNC) & O_ACCMODE) | O_RDWR;
 	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
 	/* Corresponding fput() at end of this function */
-	if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-					   lower_flags))) {
+	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
+				      lower_flags);
+	if (rc) {
 		ecryptfs_printk(KERN_ERR,
 				"Error opening dentry; rc = [%i]\n", rc);
 		goto out;
@@ -229,7 +230,8 @@ static int ecryptfs_initialize_file(stru
 	}
 	rc = grow_file(ecryptfs_dentry, lower_file, inode, lower_inode);
 out_fput:
-	if ((rc = ecryptfs_close_lower_file(lower_file)))
+	rc = ecryptfs_close_lower_file(lower_file);
+	if (rc)
 		printk(KERN_ERR "Error closing lower_file\n");
 out:
 	return rc;
@@ -779,8 +781,9 @@ int ecryptfs_truncate(struct dentry *den
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	/* This dget & mntget is released through fput at out_fput: */
 	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-	if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-					   O_RDWR))) {
+	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
+				      O_RDWR);
+	if (rc) {
 		ecryptfs_printk(KERN_ERR,
 				"Error opening dentry; rc = [%i]\n", rc);
 		goto out_free;
@@ -813,11 +816,12 @@ int ecryptfs_truncate(struct dentry *den
 			end_pos_in_page = ((new_length - 1) & ~PAGE_CACHE_MASK);
 		}
 		if (end_pos_in_page != (PAGE_CACHE_SIZE - 1)) {
-			if ((rc = ecryptfs_write_zeros(&fake_ecryptfs_file,
-						       index,
-						       (end_pos_in_page + 1),
-						       ((PAGE_CACHE_SIZE - 1)
-							- end_pos_in_page)))) {
+			rc = ecryptfs_write_zeros(&fake_ecryptfs_file,
+						  index,
+						  (end_pos_in_page + 1),
+						  ((PAGE_CACHE_SIZE - 1)
+						   - end_pos_in_page));
+			if (rc) {
 				printk(KERN_ERR "Error attempting to zero out "
 				       "the remainder of the end page on "
 				       "reducing truncate; rc = [%d]\n", rc);
@@ -849,7 +853,8 @@ int ecryptfs_truncate(struct dentry *den
 		= CURRENT_TIME;
 	mark_inode_dirty_sync(inode);
 out_fput:
-	if ((rc = ecryptfs_close_lower_file(lower_file)))
+	rc = ecryptfs_close_lower_file(lower_file);
+	if (rc)
 		printk(KERN_ERR "Error closing lower_file\n");
 out_free:
 	if (ecryptfs_file_to_private(&fake_ecryptfs_file))
@@ -917,8 +922,9 @@ static int ecryptfs_setattr(struct dentr
 
 		lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 		lower_flags = O_RDONLY;
-		if ((rc = ecryptfs_open_lower_file(&lower_file, lower_dentry,
-						   lower_mnt, lower_flags))) {
+		rc = ecryptfs_open_lower_file(&lower_file, lower_dentry,
+					      lower_mnt, lower_flags);
+		if (rc) {
 			printk(KERN_ERR
 			       "Error opening lower file; rc = [%d]\n", rc);
 			mutex_unlock(&crypt_stat->cs_mutex);
@@ -926,7 +932,8 @@ static int ecryptfs_setattr(struct dentr
 		}
 		mount_crypt_stat = &ecryptfs_superblock_to_private(
 			dentry->d_sb)->mount_crypt_stat;
-		if ((rc = ecryptfs_read_metadata(dentry, lower_file))) {
+		rc = ecryptfs_read_metadata(dentry, lower_file);
+		if (rc) {
 			if (!(mount_crypt_stat->flags
 			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
 				rc = -EIO;
diff -puN fs/ecryptfs/keystore.c~ecryptfs-remove-assignments-in-if-statements fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-remove-assignments-in-if-statements
+++ a/fs/ecryptfs/keystore.c
@@ -436,7 +436,8 @@ decrypt_pki_encrypted_session_key(struct
 	size_t netlink_message_length;
 	int rc;
 
-	if ((rc = ecryptfs_get_auth_tok_sig(&auth_tok_sig, auth_tok))) {
+	rc = ecryptfs_get_auth_tok_sig(&auth_tok_sig, auth_tok);
+	if (rc) {
 		printk(KERN_ERR "Unrecognized auth tok type: [%d]\n",
 		       auth_tok->token_type);
 		goto out;
@@ -569,8 +570,9 @@ parse_tag_1_packet(struct ecryptfs_crypt
 		goto out;
 	}
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
-	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				      &length_size))) {
+	rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				 &length_size);
+	if (rc) {
 		printk(KERN_WARNING "Error parsing packet length; "
 		       "rc = [%d]\n", rc);
 		goto out_free;
@@ -702,8 +704,9 @@ parse_tag_3_packet(struct ecryptfs_crypt
 		goto out;
 	}
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
-	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				      &length_size))) {
+	rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				 &length_size);
+	if (rc) {
 		printk(KERN_WARNING "Error parsing packet length; rc = [%d]\n",
 		       rc);
 		goto out_free;
@@ -849,8 +852,9 @@ parse_tag_11_packet(unsigned char *data,
 		rc = -EINVAL;
 		goto out;
 	}
-	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				      &length_size))) {
+	rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				 &length_size);
+	if (rc) {
 		printk(KERN_WARNING "Invalid tag 11 packet format\n");
 		goto out;
 	}
@@ -1052,9 +1056,10 @@ decrypt_passphrase_encrypted_session_key
 		       crypt_stat->cipher, rc);
 		goto out;
 	}
-	if ((rc = virt_to_scatterlist(auth_tok->session_key.encrypted_key,
-				      auth_tok->session_key.encrypted_key_size,
-				      &src_sg, 1)) != 1) {
+	rc = virt_to_scatterlist(auth_tok->session_key.encrypted_key,
+				 auth_tok->session_key.encrypted_key_size,
+				 &src_sg, 1);
+	if (rc != 1) {
 		printk(KERN_ERR "Internal error whilst attempting to convert "
 			"auth_tok->session_key.encrypted_key to scatterlist; "
 			"expected rc = 1; got rc = [%d]. "
@@ -1064,9 +1069,10 @@ decrypt_passphrase_encrypted_session_key
 	}
 	auth_tok->session_key.decrypted_key_size =
 		auth_tok->session_key.encrypted_key_size;
-	if ((rc = virt_to_scatterlist(auth_tok->session_key.decrypted_key,
-				      auth_tok->session_key.decrypted_key_size,
-				      &dst_sg, 1)) != 1) {
+	rc = virt_to_scatterlist(auth_tok->session_key.decrypted_key,
+				 auth_tok->session_key.decrypted_key_size,
+				 &dst_sg, 1);
+	if (rc != 1) {
 		printk(KERN_ERR "Internal error whilst attempting to convert "
 			"auth_tok->session_key.decrypted_key to scatterlist; "
 			"expected rc = 1; got rc = [%d]\n", rc);
@@ -1236,18 +1242,17 @@ find_next_matching_auth_tok:
 					"Considering cadidate auth tok:\n");
 			ecryptfs_dump_auth_tok(candidate_auth_tok);
 		}
-		if ((rc = ecryptfs_get_auth_tok_sig(&candidate_auth_tok_sig,
-						    candidate_auth_tok))) {
+		rc = ecryptfs_get_auth_tok_sig(&candidate_auth_tok_sig,
+					       candidate_auth_tok);
+		if (rc) {
 			printk(KERN_ERR
 			       "Unrecognized candidate auth tok type: [%d]\n",
 			       candidate_auth_tok->token_type);
 			rc = -EINVAL;
 			goto out_wipe_list;
 		}
-		if ((rc = ecryptfs_find_auth_tok_for_sig(
-			     &matching_auth_tok, crypt_stat,
-			     candidate_auth_tok_sig)))
-			rc = 0;
+		ecryptfs_find_auth_tok_for_sig(&matching_auth_tok, crypt_stat,
+					       candidate_auth_tok_sig);
 		if (matching_auth_tok) {
 			found_auth_tok = 1;
 			goto found_matching_auth_tok;
@@ -1605,9 +1610,9 @@ write_tag_3_packet(char *dest, size_t *r
 		ecryptfs_printk(KERN_DEBUG, "Session key encryption key:\n");
 		ecryptfs_dump_hex(session_key_encryption_key, 16);
 	}
-	if ((rc = virt_to_scatterlist(crypt_stat->key,
-				      key_rec->enc_key_size, &src_sg, 1))
-	    != 1) {
+	rc = virt_to_scatterlist(crypt_stat->key, key_rec->enc_key_size,
+				 &src_sg, 1);
+	if (rc != 1) {
 		ecryptfs_printk(KERN_ERR, "Error generating scatterlist "
 				"for crypt_stat session key; expected rc = 1; "
 				"got rc = [%d]. key_rec->enc_key_size = [%d]\n",
@@ -1615,9 +1620,9 @@ write_tag_3_packet(char *dest, size_t *r
 		rc = -ENOMEM;
 		goto out;
 	}
-	if ((rc = virt_to_scatterlist(key_rec->enc_key,
-				      key_rec->enc_key_size, &dst_sg, 1))
-	    != 1) {
+	rc = virt_to_scatterlist(key_rec->enc_key, key_rec->enc_key_size,
+				 &dst_sg, 1);
+	if (rc != 1) {
 		ecryptfs_printk(KERN_ERR, "Error generating scatterlist "
 				"for crypt_stat encrypted session key; "
 				"expected rc = 1; got rc = [%d]. "
diff -puN fs/ecryptfs/main.c~ecryptfs-remove-assignments-in-if-statements fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-remove-assignments-in-if-statements
+++ a/fs/ecryptfs/main.c
@@ -188,10 +188,11 @@ static int ecryptfs_init_global_auth_tok
 	list_for_each_entry(global_auth_tok,
 			    &mount_crypt_stat->global_auth_tok_list,
 			    mount_crypt_stat_list) {
-		if ((rc = ecryptfs_keyring_auth_tok_for_sig(
-			     &global_auth_tok->global_auth_tok_key,
-			     &global_auth_tok->global_auth_tok,
-			     global_auth_tok->sig))) {
+		rc = ecryptfs_keyring_auth_tok_for_sig(
+			&global_auth_tok->global_auth_tok_key,
+			&global_auth_tok->global_auth_tok,
+			global_auth_tok->sig);
+		if (rc) {
 			printk(KERN_ERR "Could not find valid key in user "
 			       "session keyring for sig specified in mount "
 			       "option: [%s]\n", global_auth_tok->sig);
@@ -355,9 +356,10 @@ static int ecryptfs_parse_options(struct
 	if (!cipher_key_bytes_set) {
 		mount_crypt_stat->global_default_cipher_key_size = 0;
 	}
-	if ((rc = ecryptfs_add_new_key_tfm(
-		     NULL, mount_crypt_stat->global_default_cipher_name,
-		     mount_crypt_stat->global_default_cipher_key_size))) {
+	rc = ecryptfs_add_new_key_tfm(
+		NULL, mount_crypt_stat->global_default_cipher_name,
+		mount_crypt_stat->global_default_cipher_key_size);
+	if (rc) {
 		printk(KERN_ERR "Error attempting to initialize cipher with "
 		       "name = [%s] and key size = [%td]; rc = [%d]\n",
 		       mount_crypt_stat->global_default_cipher_name,
@@ -365,7 +367,8 @@ static int ecryptfs_parse_options(struct
 		rc = -EINVAL;
 		goto out;
 	}
-	if ((rc = ecryptfs_init_global_auth_toks(mount_crypt_stat))) {
+	rc = ecryptfs_init_global_auth_toks(mount_crypt_stat);
+	if (rc) {
 		printk(KERN_WARNING "One or more global auth toks could not "
 		       "properly register; rc = [%d]\n", rc);
 	}
@@ -458,7 +461,8 @@ static int ecryptfs_read_super(struct su
 	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;
 	ecryptfs_set_dentry_lower(sb->s_root, lower_root);
 	ecryptfs_set_dentry_lower_mnt(sb->s_root, lower_mnt);
-	if ((rc = ecryptfs_interpose(lower_root, sb->s_root, sb, 0)))
+	rc = ecryptfs_interpose(lower_root, sb->s_root, sb, 0);
+	if (rc)
 		goto out_free;
 	rc = 0;
 	goto out;
@@ -765,7 +769,8 @@ static int do_sysfs_registration(void)
 {
 	int rc;
 
-	if ((rc = subsystem_register(&ecryptfs_subsys))) {
+	rc = subsystem_register(&ecryptfs_subsys);
+	if (rc) {
 		printk(KERN_ERR
 		       "Unable to register ecryptfs sysfs subsystem\n");
 		goto out;
@@ -796,7 +801,8 @@ static void do_sysfs_unregistration(void
 {
 	int rc;
 
-	if ((rc = ecryptfs_destroy_crypto())) {
+	rc = ecryptfs_destroy_crypto();
+	if (rc) {
 		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
 		       "rc = [%d]\n", rc);
 	}
diff -puN fs/ecryptfs/messaging.c~ecryptfs-remove-assignments-in-if-statements fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-remove-assignments-in-if-statements
+++ a/fs/ecryptfs/messaging.c
@@ -419,8 +419,9 @@ int ecryptfs_init_messaging(unsigned int
 	}
 	mutex_init(&ecryptfs_daemon_id_hash_mux);
 	mutex_lock(&ecryptfs_daemon_id_hash_mux);
-	ecryptfs_hash_buckets = 0;
-	while (ecryptfs_number_of_users >> ++ecryptfs_hash_buckets);
+	ecryptfs_hash_buckets = 1;
+	while (ecryptfs_number_of_users >> ecryptfs_hash_buckets)
+		ecryptfs_hash_buckets++;
 	ecryptfs_daemon_id_hash = kmalloc(sizeof(struct hlist_head)
 					  * ecryptfs_hash_buckets, GFP_KERNEL);
 	if (!ecryptfs_daemon_id_hash) {
diff -puN fs/ecryptfs/mmap.c~ecryptfs-remove-assignments-in-if-statements fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-remove-assignments-in-if-statements
+++ a/fs/ecryptfs/mmap.c
@@ -762,8 +762,9 @@ ecryptfs_write_zeros(struct file *file, 
 		rc = PTR_ERR(tmp_page);
 		goto out;
 	}
-	if ((rc = ecryptfs_prepare_write_no_truncate(file, tmp_page, start,
-						     (start + num_zeros)))) {
+	rc = ecryptfs_prepare_write_no_truncate(file, tmp_page, start,
+						(start + num_zeros));
+	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error preparing to write zero's "
 				"to page at index [0x%.16x]\n",
 				index);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
