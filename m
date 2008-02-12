From: akpm@linux-foundation.org
Subject: + keys-increase-the-payload-size-when-instantiating-a-key.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:51:46 -0800
Message-ID: <200802122351.m1CNpk07029540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbYBLXxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:53:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, chrisw@sous-sol.org, jmorris@namei.org, kwc@citi.umich.edu, paul.moore@hp.com, sds@tycho.nsa.gov, sfrench@us.ibm.com


The patch titled
     keys: increase the payload size when instantiating a key
has been added to the -mm tree.  Its filename is
     keys-increase-the-payload-size-when-instantiating-a-key.patch

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
Subject: keys: increase the payload size when instantiating a key
From: David Howells <dhowells@redhat.com>

Increase the size of a payload that can be used to instantiate a key in
add_key() and keyctl_instantiate_key().  This permits huge CIFS SPNEGO blobs
to be passed around.  The limit is raised to 1MB.  If kmalloc() can't allocate
a buffer of sufficient size, vmalloc() will be tried instead.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Paul Moore <paul.moore@hp.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Kevin Coffman <kwc@citi.umich.edu>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/keyctl.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff -puN security/keys/keyctl.c~keys-increase-the-payload-size-when-instantiating-a-key security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-increase-the-payload-size-when-instantiating-a-key
+++ a/security/keys/keyctl.c
@@ -19,6 +19,7 @@
 #include <linux/capability.h>
 #include <linux/string.h>
 #include <linux/err.h>
+#include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -62,9 +63,10 @@ asmlinkage long sys_add_key(const char _
 	char type[32], *description;
 	void *payload;
 	long ret;
+	bool vm;
 
 	ret = -EINVAL;
-	if (plen > 32767)
+	if (plen > 1024 * 1024 - 1)
 		goto error;
 
 	/* draw all the data into kernel space */
@@ -81,11 +83,18 @@ asmlinkage long sys_add_key(const char _
 	/* pull the payload in if one was supplied */
 	payload = NULL;
 
+	vm = false;
 	if (_payload) {
 		ret = -ENOMEM;
 		payload = kmalloc(plen, GFP_KERNEL);
-		if (!payload)
-			goto error2;
+		if (!payload) {
+			if (plen <= PAGE_SIZE)
+				goto error2;
+			vm = true;
+			payload = vmalloc(plen);
+			if (!payload)
+				goto error2;
+		}
 
 		ret = -EFAULT;
 		if (copy_from_user(payload, _payload, plen) != 0)
@@ -113,7 +122,10 @@ asmlinkage long sys_add_key(const char _
 
 	key_ref_put(keyring_ref);
  error3:
-	kfree(payload);
+	if (!vm)
+		kfree(payload);
+	else
+		vfree(payload);
  error2:
 	kfree(description);
  error:
@@ -821,9 +833,10 @@ long keyctl_instantiate_key(key_serial_t
 	key_ref_t keyring_ref;
 	void *payload;
 	long ret;
+	bool vm = false;
 
 	ret = -EINVAL;
-	if (plen > 32767)
+	if (plen > 1024 * 1024 - 1)
 		goto error;
 
 	/* the appropriate instantiation authorisation key must have been
@@ -843,8 +856,14 @@ long keyctl_instantiate_key(key_serial_t
 	if (_payload) {
 		ret = -ENOMEM;
 		payload = kmalloc(plen, GFP_KERNEL);
-		if (!payload)
-			goto error;
+		if (!payload) {
+			if (plen <= PAGE_SIZE)
+				goto error;
+			vm = true;
+			payload = vmalloc(plen);
+			if (!payload)
+				goto error;
+		}
 
 		ret = -EFAULT;
 		if (copy_from_user(payload, _payload, plen) != 0)
@@ -877,7 +896,10 @@ long keyctl_instantiate_key(key_serial_t
 	}
 
 error2:
-	kfree(payload);
+	if (!vm)
+		kfree(payload);
+	else
+		vfree(payload);
 error:
 	return ret;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
fix-frv-cmpxchg_local.patch
final-removal-of-fastcall-fastcall.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
