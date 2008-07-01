From: akpm@linux-foundation.org
Subject: + ecryptfs-propagate-key-errors-up-at-mount-time.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:10:28 -0700
Message-ID: <200807010510.m615ASoj010138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbYGAFLD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, jtluka@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: propagate key errors up at mount time
has been added to the -mm tree.  Its filename is
     ecryptfs-propagate-key-errors-up-at-mount-time.patch

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
Subject: ecryptfs: propagate key errors up at mount time
From: Eric Sandeen <sandeen@redhat.com>

Mounting with invalid key signatures should probably fail, if they were
specifically requested but not available.

Also fix case checks in process_request_key_err() for the right sign of
the errnos, as spotted by Jan Tluka.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Jan Tluka <jtluka@redhat.com>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |    9 ++++-----
 fs/ecryptfs/main.c     |    4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-propagate-key-errors-up-at-mount-time fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-propagate-key-errors-up-at-mount-time
+++ a/fs/ecryptfs/keystore.c
@@ -44,15 +44,15 @@ static int process_request_key_err(long 
 	int rc = 0;
 
 	switch (err_code) {
-	case ENOKEY:
+	case -ENOKEY:
 		ecryptfs_printk(KERN_WARNING, "No key\n");
 		rc = -ENOENT;
 		break;
-	case EKEYEXPIRED:
+	case -EKEYEXPIRED:
 		ecryptfs_printk(KERN_WARNING, "Key expired\n");
 		rc = -ETIME;
 		break;
-	case EKEYREVOKED:
+	case -EKEYREVOKED:
 		ecryptfs_printk(KERN_WARNING, "Key revoked\n");
 		rc = -EINVAL;
 		break;
@@ -963,8 +963,7 @@ int ecryptfs_keyring_auth_tok_for_sig(st
 	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
 		printk(KERN_ERR "Could not find key with description: [%s]\n",
 		       sig);
-		process_request_key_err(PTR_ERR(*auth_tok_key));
-		rc = -EINVAL;
+		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
 		goto out;
 	}
 	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
diff -puN fs/ecryptfs/main.c~ecryptfs-propagate-key-errors-up-at-mount-time fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-propagate-key-errors-up-at-mount-time
+++ a/fs/ecryptfs/main.c
@@ -248,10 +248,11 @@ static int ecryptfs_init_global_auth_tok
 			       "session keyring for sig specified in mount "
 			       "option: [%s]\n", global_auth_tok->sig);
 			global_auth_tok->flags |= ECRYPTFS_AUTH_TOK_INVALID;
-			rc = 0;
+			goto out;
 		} else
 			global_auth_tok->flags &= ~ECRYPTFS_AUTH_TOK_INVALID;
 	}
+out:
 	return rc;
 }
 
@@ -416,7 +417,6 @@ static int ecryptfs_parse_options(struct
 		printk(KERN_WARNING "One or more global auth toks could not "
 		       "properly register; rc = [%d]\n", rc);
 	}
-	rc = 0;
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from sandeen@redhat.com are

find-dynamic-stack-allocations-in-checkstackpl.patch
fix-checkstackpl-arch-detection.patch
ecryptfs-privileged-kthread-for-lower-file-opens.patch
ecryptfs-propagate-key-errors-up-at-mount-time.patch

