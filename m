From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-unnecessary-variable-initializations.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:38 -0700
Message-ID: <200710162040.l9GKec5i015708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936057AbXJPVHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: remove unnecessary variable initializations
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-unnecessary-variable-initializations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: remove unnecessary variable initializations
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> >       struct mutex *tfm_mutex = NULL;
>
> This initialisation looks like it's here to kill bogus gcc warning
> (if it is, it should have been commented).  Please investigate
> uninitialized_var() and __maybe_unused sometime.

Remove some unnecessary variable initializations. There may be a few
more such intializations remaining in the code base; a future patch
will take care of those.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-remove-unnecessary-variable-initializations fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-remove-unnecessary-variable-initializations
+++ a/fs/ecryptfs/keystore.c
@@ -1009,7 +1009,7 @@ decrypt_passphrase_encrypted_session_key
 {
 	struct scatterlist dst_sg;
 	struct scatterlist src_sg;
-	struct mutex *tfm_mutex = NULL;
+	struct mutex *tfm_mutex;
 	struct blkcipher_desc desc = {
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
 	};
@@ -1123,8 +1123,8 @@ int ecryptfs_parse_packet_set(struct ecr
 	size_t found_auth_tok;
 	size_t next_packet_is_auth_tok_packet;
 	struct list_head auth_tok_list;
-	struct ecryptfs_auth_tok *matching_auth_tok = NULL;
-	struct ecryptfs_auth_tok *candidate_auth_tok = NULL;
+	struct ecryptfs_auth_tok *matching_auth_tok;
+	struct ecryptfs_auth_tok *candidate_auth_tok;
 	char *candidate_auth_tok_sig;
 	size_t packet_size;
 	struct ecryptfs_auth_tok *new_auth_tok;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
