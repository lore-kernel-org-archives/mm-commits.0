From: akpm@linux-foundation.org
Subject: + ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes.patch added to -mm tree
Date: Thu, 17 Apr 2008 10:43:34 -0700
Message-ID: <200804171743.m3HHhYYg020264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756373AbYDQRtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 13:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     ecryptfs printk fixes
has been added to the -mm tree.  Its filename is
     ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes.patch

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
Subject: ecryptfs printk fixes
From: Michael Halcrow <mhalcrow@us.ibm.com>

On Thu, Apr 17, 2008 at 03:54:24AM -0700, Andrew Morton wrote:
> fs/ecryptfs/messaging.c: In function 'ecryptfs_spawn_daemon':
> fs/ecryptfs/messaging.c:205: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> fs/ecryptfs/miscdev.c: In function 'ecryptfs_send_miscdev':
> fs/ecryptfs/miscdev.c:200: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
> fs/ecryptfs/miscdev.c: At top level:
> fs/ecryptfs/miscdev.c:534: warning: initialization from incompatible pointer type

Fix types for 64-bit build.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c  |    6 +++---
 fs/ecryptfs/messaging.c |    2 +-
 fs/ecryptfs/miscdev.c   |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes
+++ a/fs/ecryptfs/keystore.c
@@ -358,7 +358,7 @@ parse_tag_67_packet(struct ecryptfs_key_
 	/* verify that everything through the encrypted FEK size is present */
 	if (message_len < 4) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: message_len is [%d]; minimum acceptable "
+		printk(KERN_ERR "%s: message_len is [%Zd]; minimum acceptable "
 		       "message length is [%d]\n", __func__, message_len, 4);
 		goto out;
 	}
@@ -385,13 +385,13 @@ parse_tag_67_packet(struct ecryptfs_key_
 	i += data_len;
 	if (message_len < (i + key_rec->enc_key_size)) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: message_len [%d]; max len is [%d]\n",
+		printk(KERN_ERR "%s: message_len [%Zd]; max len is [%Zd]\n",
 		       __func__, message_len, (i + key_rec->enc_key_size));
 		goto out;
 	}
 	if (key_rec->enc_key_size > ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES) {
 		rc = -EIO;
-		printk(KERN_ERR "%s: Encrypted key_size [%d] larger than "
+		printk(KERN_ERR "%s: Encrypted key_size [%Zd] larger than "
 		       "the maximum key size [%d]\n", __func__,
 		       key_rec->enc_key_size,
 		       ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES);
diff -puN fs/ecryptfs/messaging.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes
+++ a/fs/ecryptfs/messaging.c
@@ -201,7 +201,7 @@ ecryptfs_spawn_daemon(struct ecryptfs_da
 	(*daemon) = kzalloc(sizeof(**daemon), GFP_KERNEL);
 	if (!(*daemon)) {
 		rc = -ENOMEM;
-		printk(KERN_ERR "%s: Failed to allocate [%d] bytes of "
+		printk(KERN_ERR "%s: Failed to allocate [%Zd] bytes of "
 		       "GFP_KERNEL memory\n", __func__, sizeof(**daemon));
 		goto out;
 	}
diff -puN fs/ecryptfs/miscdev.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes fs/ecryptfs/miscdev.c
--- a/fs/ecryptfs/miscdev.c~ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes
+++ a/fs/ecryptfs/miscdev.c
@@ -196,7 +196,7 @@ int ecryptfs_send_miscdev(char *data, si
 		if (!msg_ctx->msg) {
 			rc = -ENOMEM;
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
-			       "to kmalloc(%d, GFP_KERNEL)\n", __func__,
+			       "to kmalloc(%Zd, GFP_KERNEL)\n", __func__,
 			       (sizeof(*msg_ctx->msg) + data_size));
 			goto out_unlock;
 		}
@@ -232,7 +232,7 @@ out_unlock:
  *
  * Returns the number of bytes copied into the user buffer
  */
-static int
+static ssize_t
 ecryptfs_miscdev_read(struct file *file, char __user *buf, size_t count,
 		      loff_t *ppos)
 {
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
remove-ecryptfs_header_cache_0.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
ecryptfs-add-missing-lock-around-notify_change.patch
ecryptfs-introduce-device-handle-for-userspace-daemon-communications.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module.patch
ecryptfs-integrate-ecryptfs-device-handle-into-the-module-printk-fixes.patch
remove-duplicated-unlikely-in-is_err.patch
notify_change-callers-must-hold-i_mutex.patch

