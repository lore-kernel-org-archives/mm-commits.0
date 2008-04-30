From: akpm@linux-foundation.org
Subject: - keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:27 -0700
Message-ID: <200804300545.m3U5jR11029503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756446AbYD3FqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arunsr@cse.iitk.ac.in, dhowells@redhat.com, ssatyam@cse.iitk.ac.in, mm-commits@vger.kernel.org


The patch titled
     keys: allow clients to set key perms in key_create_or_update()
has been removed from the -mm tree.  Its filename was
     keys-allow-clients-to-set-key-perms-in-key_create_or_update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: allow clients to set key perms in key_create_or_update()
From: Arun Raghavan <arunsr@cse.iitk.ac.in>

The key_create_or_update() function provided by the keyring code has a default
set of permissions that are always applied to the key when created.  This
might not be desirable to all clients.

Here's a patch that adds a "perm" parameter to the function to address this,
which can be set to KEY_PERM_UNDEF to revert to the current behaviour.

Signed-off-by: Arun Raghavan <arunsr@cse.iitk.ac.in>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/key.h    |    3 +++
 security/keys/key.c    |   18 ++++++++++--------
 security/keys/keyctl.c |    3 ++-
 3 files changed, 15 insertions(+), 9 deletions(-)

diff -puN include/linux/key.h~keys-allow-clients-to-set-key-perms-in-key_create_or_update include/linux/key.h
--- a/include/linux/key.h~keys-allow-clients-to-set-key-perms-in-key_create_or_update
+++ a/include/linux/key.h
@@ -67,6 +67,8 @@ struct key;
 #define KEY_OTH_SETATTR	0x00000020
 #define KEY_OTH_ALL	0x0000003f
 
+#define KEY_PERM_UNDEF	0xffffffff
+
 struct seq_file;
 struct user_struct;
 struct signal_struct;
@@ -232,6 +234,7 @@ extern key_ref_t key_create_or_update(ke
 				      const char *description,
 				      const void *payload,
 				      size_t plen,
+				      key_perm_t perm,
 				      unsigned long flags);
 
 extern int key_update(key_ref_t key,
diff -puN security/keys/key.c~keys-allow-clients-to-set-key-perms-in-key_create_or_update security/keys/key.c
--- a/security/keys/key.c~keys-allow-clients-to-set-key-perms-in-key_create_or_update
+++ a/security/keys/key.c
@@ -757,11 +757,11 @@ key_ref_t key_create_or_update(key_ref_t
 			       const char *description,
 			       const void *payload,
 			       size_t plen,
+			       key_perm_t perm,
 			       unsigned long flags)
 {
 	struct key_type *ktype;
 	struct key *keyring, *key = NULL;
-	key_perm_t perm;
 	key_ref_t key_ref;
 	int ret;
 
@@ -806,15 +806,17 @@ key_ref_t key_create_or_update(key_ref_t
 			goto found_matching_key;
 	}
 
-	/* decide on the permissions we want */
-	perm = KEY_POS_VIEW | KEY_POS_SEARCH | KEY_POS_LINK | KEY_POS_SETATTR;
-	perm |= KEY_USR_VIEW | KEY_USR_SEARCH | KEY_USR_LINK | KEY_USR_SETATTR;
+	/* if the client doesn't provide, decide on the permissions we want */
+	if (perm == KEY_PERM_UNDEF) {
+		perm = KEY_POS_VIEW | KEY_POS_SEARCH | KEY_POS_LINK | KEY_POS_SETATTR;
+		perm |= KEY_USR_VIEW | KEY_USR_SEARCH | KEY_USR_LINK | KEY_USR_SETATTR;
 
-	if (ktype->read)
-		perm |= KEY_POS_READ | KEY_USR_READ;
+		if (ktype->read)
+			perm |= KEY_POS_READ | KEY_USR_READ;
 
-	if (ktype == &key_type_keyring || ktype->update)
-		perm |= KEY_USR_WRITE;
+		if (ktype == &key_type_keyring || ktype->update)
+			perm |= KEY_USR_WRITE;
+	}
 
 	/* allocate a new key */
 	key = key_alloc(ktype, description, current->fsuid, current->fsgid,
diff -puN security/keys/keyctl.c~keys-allow-clients-to-set-key-perms-in-key_create_or_update security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-allow-clients-to-set-key-perms-in-key_create_or_update
+++ a/security/keys/keyctl.c
@@ -112,7 +112,8 @@ asmlinkage long sys_add_key(const char _
 	/* create or update the requested key and add it to the target
 	 * keyring */
 	key_ref = key_create_or_update(keyring_ref, type, description,
-				       payload, plen, KEY_ALLOC_IN_QUOTA);
+				       payload, plen, KEY_PERM_UNDEF,
+				       KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key_ref)) {
 		ret = key_ref_to_ptr(key_ref)->serial;
 		key_ref_put(key_ref);
_

Patches currently in -mm which might be from arunsr@cse.iitk.ac.in are

origin.patch

