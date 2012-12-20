From: akpm@linux-foundation.org
Subject: + keys-use-keyring_alloc-to-create-module-signing-keyring.patch added to -mm tree
Date: Wed, 19 Dec 2012 16:22:37 -0800
Message-ID: <20121220002238.2658E82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60169 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2LTAWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 19:22:39 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so306831vcd.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 16:22:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, rusty@rustcorp.com.au


The patch titled
     Subject: keys: use keyring_alloc() to create module signing keyring
has been added to the -mm tree.  Its filename is
     keys-use-keyring_alloc-to-create-module-signing-keyring.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
