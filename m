From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:48 -0800
Message-ID: <200802070026.m170QTlV006922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935092AbYBGApi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: remove debug as mount option, and warn if set via modprobe
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: remove debug as mount option, and warn if set via modprobe
From: Eric Sandeen <sandeen@redhat.com>

ecryptfs_debug really should not be a mount option; it is not per-mount,
but rather sets a global "ecryptfs_verbosity" variable which affects all
mounted filesysytems.  It's already settable as a module load option,
I think we can leave it at that.

Also, if set, since secret values come out in debug messages, kick
things off with a stern warning.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c  |   23 +++++++----------------
 fs/ecryptfs/super.c |    4 ----
 2 files changed, 7 insertions(+), 20 deletions(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe
+++ a/fs/ecryptfs/main.c
@@ -226,17 +226,15 @@ out:
 	return rc;
 }
 
-enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig, ecryptfs_opt_debug,
-       ecryptfs_opt_ecryptfs_debug, ecryptfs_opt_cipher,
-       ecryptfs_opt_ecryptfs_cipher, ecryptfs_opt_ecryptfs_key_bytes,
+enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
+       ecryptfs_opt_cipher, ecryptfs_opt_ecryptfs_cipher,
+       ecryptfs_opt_ecryptfs_key_bytes,
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_err };
 
 static match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
 	{ecryptfs_opt_ecryptfs_sig, "ecryptfs_sig=%s"},
-	{ecryptfs_opt_debug, "debug=%u"},
-	{ecryptfs_opt_ecryptfs_debug, "ecryptfs_debug=%u"},
 	{ecryptfs_opt_cipher, "cipher=%s"},
 	{ecryptfs_opt_ecryptfs_cipher, "ecryptfs_cipher=%s"},
 	{ecryptfs_opt_ecryptfs_key_bytes, "ecryptfs_key_bytes=%u"},
@@ -313,7 +311,6 @@ static int ecryptfs_parse_options(struct
 	substring_t args[MAX_OPT_ARGS];
 	int token;
 	char *sig_src;
-	char *debug_src;
 	char *cipher_name_dst;
 	char *cipher_name_src;
 	char *cipher_key_bytes_src;
@@ -341,16 +338,6 @@ static int ecryptfs_parse_options(struct
 			}
 			sig_set = 1;
 			break;
-		case ecryptfs_opt_debug:
-		case ecryptfs_opt_ecryptfs_debug:
-			debug_src = args[0].from;
-			ecryptfs_verbosity =
-				(int)simple_strtol(debug_src, &debug_src,
-						   0);
-			ecryptfs_printk(KERN_DEBUG,
-					"Verbosity set to [%d]" "\n",
-					ecryptfs_verbosity);
-			break;
 		case ecryptfs_opt_cipher:
 		case ecryptfs_opt_ecryptfs_cipher:
 			cipher_name_src = args[0].from;
@@ -816,6 +803,10 @@ static int __init ecryptfs_init(void)
 		       "rc = [%d]\n", rc);
 		goto out_release_messaging;
 	}
+	if (ecryptfs_verbosity > 0)
+		printk(KERN_CRIT "eCryptfs verbosity set to %d. Secret values "
+			"will be written to the syslog!\n", ecryptfs_verbosity);
+
 	goto out;
 out_release_messaging:
 	ecryptfs_release_messaging(ecryptfs_transport);
diff -puN fs/ecryptfs/super.c~ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe
+++ a/fs/ecryptfs/super.c
@@ -174,10 +174,6 @@ static int ecryptfs_show_options(struct 
 	}
 	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 
-	/* Note this is global and probably shouldn't be a mount option */
-	if (ecryptfs_verbosity)
-		seq_printf(m, ",ecryptfs_debug=%d\n", ecryptfs_verbosity);
-
 	seq_printf(m, ",ecryptfs_cipher=%s",
 		mount_crypt_stat->global_default_cipher_name);
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
reduce-large-do_mount-stack-usage-with-noinlines.patch
