From: akpm@osdl.org
Subject: - security-keys-user-kmemdup.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:46 -0800
Message-ID: <200612072258.kB7Mwkwe029428@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50837 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163659AbWLGW67 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snakebyte@gmx.de, adobriyan@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     security/keys/*: user kmemdup()
has been removed from the -mm tree.  Its filename was
     security-keys-user-kmemdup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: security/keys/*: user kmemdup()
From: Eric Sesterhenn <snakebyte@gmx.de>

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-By: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 security/keys/key.c     |    4 +---
 security/keys/keyring.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN security/keys/key.c~security-keys-user-kmemdup security/keys/key.c
--- a/security/keys/key.c~security-keys-user-kmemdup
+++ a/security/keys/key.c
@@ -290,11 +290,9 @@ struct key *key_alloc(struct key_type *t
 		goto no_memory_2;
 
 	if (desc) {
-		key->description = kmalloc(desclen, GFP_KERNEL);
+		key->description = kmemdup(desc, desclen, GFP_KERNEL);
 		if (!key->description)
 			goto no_memory_3;
-
-		memcpy(key->description, desc, desclen);
 	}
 
 	atomic_set(&key->usage, 1);
diff -puN security/keys/keyring.c~security-keys-user-kmemdup security/keys/keyring.c
--- a/security/keys/keyring.c~security-keys-user-kmemdup
+++ a/security/keys/keyring.c
@@ -706,12 +706,10 @@ int __key_link(struct key *keyring, stru
 				BUG_ON(size > PAGE_SIZE);
 
 				ret = -ENOMEM;
-				nklist = kmalloc(size, GFP_KERNEL);
+				nklist = kmemdup(klist, size, GFP_KERNEL);
 				if (!nklist)
 					goto error2;
 
-				memcpy(nklist, klist, size);
-
 				/* replace matched key */
 				atomic_inc(&key->usage);
 				nklist->keys[loop] = key;
_

Patches currently in -mm which might be from snakebyte@gmx.de are

origin.patch
git-ieee1394.patch
remove-unnecessary-check-in-drivers-scsi-sgc.patch
drivers-video-use-kmemdup.patch

