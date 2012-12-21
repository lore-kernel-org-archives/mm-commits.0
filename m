From: akpm@linux-foundation.org
Subject: [merged] keys-use-keyring_alloc-to-create-module-signing-keyring.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:36 -0800
Message-ID: <20121221204036.B94C3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37500 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2LUUkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:37 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so548898qaq.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: keys: use keyring_alloc() to create module signing keyring
has been removed from the -mm tree.  Its filename was
     keys-use-keyring_alloc-to-create-module-signing-keyring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: keys: use keyring_alloc() to create module signing keyring

Use keyring_alloc() to create special keyrings now that it has a
permissions parameter rather than using key_alloc() +
key_instantiate_and_link().

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/modsign_pubkey.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN kernel/modsign_pubkey.c~keys-use-keyring_alloc-to-create-module-signing-keyring kernel/modsign_pubkey.c
--- a/kernel/modsign_pubkey.c~keys-use-keyring_alloc-to-create-module-signing-keyring
+++ a/kernel/modsign_pubkey.c
@@ -34,18 +34,15 @@ static __init int module_verify_init(voi
 {
 	pr_notice("Initialise module verification\n");
 
-	modsign_keyring = key_alloc(&key_type_keyring, ".module_sign",
-				    KUIDT_INIT(0), KGIDT_INIT(0),
-				    current_cred(),
-				    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
-				    KEY_USR_VIEW | KEY_USR_READ,
-				    KEY_ALLOC_NOT_IN_QUOTA);
+	modsign_keyring = keyring_alloc(".module_sign",
+					KUIDT_INIT(0), KGIDT_INIT(0),
+					current_cred(),
+					((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					 KEY_USR_VIEW | KEY_USR_READ),
+					KEY_ALLOC_NOT_IN_QUOTA, NULL);
 	if (IS_ERR(modsign_keyring))
 		panic("Can't allocate module signing keyring\n");
 
-	if (key_instantiate_and_link(modsign_keyring, NULL, 0, NULL, NULL) < 0)
-		panic("Can't instantiate module signing keyring\n");
