From: akpm@linux-foundation.org
Subject: - cred-document-the-credential-apis-abuse-of-const-pointers.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:48:45 -0700
Message-ID: <200808282148.m7SLmjlX016124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755944AbYH1Vt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     cred: document the credential API's (ab)use of const pointers
has been removed from the -mm tree.  Its filename was
     cred-document-the-credential-apis-abuse-of-const-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cred: document the credential API's (ab)use of const pointers
From: David Howells <dhowells@redhat.com>

Document the credential API's (ab)use of const pointers.  Various pointers
to credentials, such as those in the task_struct, are declared const.  The
purpose of this is to compile-time discouragement of altering credentials
through those pointers.  Once a set of credentials has been made public
through one of these pointers, it may not be modified, except under
special circumstances:

  (1) Its reference count may incremented and decremented.

  (2) The keyrings to which it points may be modified, but not replaced.

The only safe way to modify anything else is to create a replacement and commit
using the functions described in Documentation/credentials.txt.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/credentials.txt |   19 +++++++++++++++++++
 include/linux/cred.h          |   12 +++++++++++-
 kernel/cred.c                 |    2 +-
 3 files changed, 31 insertions(+), 2 deletions(-)

diff -puN Documentation/credentials.txt~cred-document-the-credential-apis-abuse-of-const-pointers Documentation/credentials.txt
--- a/Documentation/credentials.txt~cred-document-the-credential-apis-abuse-of-const-pointers
+++ a/Documentation/credentials.txt
@@ -14,6 +14,7 @@ Contents:
 
  (*) Task credentials.
 
+     - Immutable credentials.
      - Accessing task credentials.
      - Accessing another task's credentials.
      - Altering credentials.
@@ -309,6 +310,24 @@ attachment to process-specific keyrings 
 instantiating process may need to create them.
 
 
+IMMUTABLE CREDENTIALS
+---------------------
+
+Once a set of credentials has been made public (by calling commit_creds() for
+example), it must be considered immutable, barring two exceptions:
+
+ (1) The reference count may be altered.
+
+ (2) Whilst the keyring subscriptions of a set of credentials may not be
+     changed, the keyrings subscribed to may have their contents altered.
+
+To catch accidental credential alteration at compile time, struct task_struct
+has _const_ pointers to its credential sets, as does struct file.  Furthermore,
+certain functions such as get_cred() and put_cred() operate on const pointers,
+thus rendering casts unnecessary, but require to temporarily ditch the const
+qualification to be able to alter the reference count.
+
+
 ACCESSING TASK CREDENTIALS
 --------------------------
 
diff -puN include/linux/cred.h~cred-document-the-credential-apis-abuse-of-const-pointers include/linux/cred.h
--- a/include/linux/cred.h~cred-document-the-credential-apis-abuse-of-const-pointers
+++ a/include/linux/cred.h
@@ -1,4 +1,4 @@
-/* Credentials management
+/* Credentials management - see Documentation/credentials.txt
  *
  * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -175,6 +175,12 @@ static inline struct cred *get_new_cred(
  *
  * Get a reference on the specified set of credentials.  The caller must
  * release the reference.
+ *
+ * This is used to deal with a committed set of credentials.  Although the
+ * pointer is const, this will temporarily discard the const and increment the
+ * usage count.  The purpose of this is to attempt to catch at compile time the
+ * accidental alteration of a set of credentials that should be considered
+ * immutable.
  */
 static inline const struct cred *get_cred(const struct cred *cred)
 {
@@ -187,6 +193,10 @@ static inline const struct cred *get_cre
  *
  * Release a reference to a set of credentials, deleting them when the last ref
  * is released.
+ *
+ * This takes a const pointer to a set of credentials because the credentials
+ * on task_struct are attached by const pointers to prevent accidental
+ * alteration of otherwise immutable credential sets.
  */
 static inline void put_cred(const struct cred *_cred)
 {
diff -puN kernel/cred.c~cred-document-the-credential-apis-abuse-of-const-pointers kernel/cred.c
--- a/kernel/cred.c~cred-document-the-credential-apis-abuse-of-const-pointers
+++ a/kernel/cred.c
@@ -1,4 +1,4 @@
-/* Task credentials management
+/* Task credentials management - see Documentation/credentials.txt
  *
  * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
cifs-fix-range-check.patch
uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch

