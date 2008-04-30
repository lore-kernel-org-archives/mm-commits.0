From: akpm@linux-foundation.org
Subject: - keys-check-starting-keyring-as-part-of-search.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:16 -0700
Message-ID: <200804300545.m3U5jGdY029488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758056AbYD3Fq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwc@citi.umich.edu, bfields@fieldses.org, chrisw@sous-sol.org, dhowells@redhat.com, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, trond.myklebust@fys.uio.no, mm-commits@vge


The patch titled
     keys: check starting keyring as part of search
has been removed from the -mm tree.  Its filename was
     keys-check-starting-keyring-as-part-of-search.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: check starting keyring as part of search
From: Kevin Coffman <kwc@citi.umich.edu>

Check the starting keyring as part of the search to (a) see if that is what
we're searching for, and (b) to check it is still valid for searching.

The scenario: User in process A does things that cause things to be created in
its process session keyring.  The user then does an su to another user and
starts a new process, B.  The two processes now share the same process session
keyring.

Process B does an NFS access which results in an upcall to gssd.  When gssd
attempts to instantiate the context key (to be linked into the process session
keyring), it is denied access even though it has an authorization key.

The order of calls is:

   keyctl_instantiate_key()
      lookup_user_key()				    (the default: case)
         search_process_keyrings(current)
	    search_process_keyrings(rka->context)   (recursive call)
	       keyring_search_aux()

keyring_search_aux() verifies the keys and keyrings underneath the top-level
keyring it is given, but that top-level keyring is neither fully validated nor
checked to see if it is the thing being searched for.

This patch changes keyring_search_aux() to:
1) do more validation on the top keyring it is given and
2) check whether that top-level keyring is the thing being searched for

Signed-off-by: Kevin Coffman <kwc@citi.umich.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Paul Moore <paul.moore@hp.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Kevin Coffman <kwc@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/keyring.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff -puN security/keys/keyring.c~keys-check-starting-keyring-as-part-of-search security/keys/keyring.c
--- a/security/keys/keyring.c~keys-check-starting-keyring-as-part-of-search
+++ a/security/keys/keyring.c
@@ -292,7 +292,7 @@ key_ref_t keyring_search_aux(key_ref_t k
 
 	struct keyring_list *keylist;
 	struct timespec now;
-	unsigned long possessed;
+	unsigned long possessed, kflags;
 	struct key *keyring, *key;
 	key_ref_t key_ref;
 	long err;
@@ -319,6 +319,32 @@ key_ref_t keyring_search_aux(key_ref_t k
 	err = -EAGAIN;
 	sp = 0;
 
+	/* firstly we should check to see if this top-level keyring is what we
+	 * are looking for */
+	key_ref = ERR_PTR(-EAGAIN);
+	kflags = keyring->flags;
+	if (keyring->type == type && match(keyring, description)) {
+		key = keyring;
+
+		/* check it isn't negative and hasn't expired or been
+		 * revoked */
+		if (kflags & (1 << KEY_FLAG_REVOKED))
+			goto error_2;
+		if (key->expiry && now.tv_sec >= key->expiry)
+			goto error_2;
+		key_ref = ERR_PTR(-ENOKEY);
+		if (kflags & (1 << KEY_FLAG_NEGATIVE))
+			goto error_2;
+		goto found;
+	}
+
+	/* otherwise, the top keyring must not be revoked, expired, or
+	 * negatively instantiated if we are to search it */
+	key_ref = ERR_PTR(-EAGAIN);
+	if (kflags & ((1 << KEY_FLAG_REVOKED) | (1 << KEY_FLAG_NEGATIVE)) ||
+	    (keyring->expiry && now.tv_sec >= keyring->expiry))
+		goto error_2;
+
 	/* start processing a new keyring */
 descend:
 	if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
@@ -331,13 +357,14 @@ descend:
 	/* iterate through the keys in this keyring first */
 	for (kix = 0; kix < keylist->nkeys; kix++) {
 		key = keylist->keys[kix];
+		kflags = key->flags;
 
 		/* ignore keys not of this type */
 		if (key->type != type)
 			continue;
 
 		/* skip revoked keys and expired keys */
-		if (test_bit(KEY_FLAG_REVOKED, &key->flags))
+		if (kflags & (1 << KEY_FLAG_REVOKED))
 			continue;
 
 		if (key->expiry && now.tv_sec >= key->expiry)
@@ -352,8 +379,8 @@ descend:
 					context, KEY_SEARCH) < 0)
 			continue;
 
-		/* we set a different error code if we find a negative key */
-		if (test_bit(KEY_FLAG_NEGATIVE, &key->flags)) {
+		/* we set a different error code if we pass a negative key */
+		if (kflags & (1 << KEY_FLAG_NEGATIVE)) {
 			err = -ENOKEY;
 			continue;
 		}
_

Patches currently in -mm which might be from kwc@citi.umich.edu are

origin.patch

