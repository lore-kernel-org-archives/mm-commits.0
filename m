From: akpm@linux-foundation.org
Subject: - keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:19 -0700
Message-ID: <200804300545.m3U5jJPh029491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760753AbYD3GMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, chrisw@sous-sol.org, jmorris@namei.org, kwc@citi.umich.edu, paul.moore@hp.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     keys: allow the callout data to be passed as a blob rather than a string
has been removed from the -mm tree.  Its filename was
     keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: allow the callout data to be passed as a blob rather than a string
From: David Howells <dhowells@redhat.com>

Allow the callout data to be passed as a blob rather than a string for
internal kernel services that call any request_key_*() interface other than
request_key().  request_key() itself still takes a NUL-terminated string.

The functions that change are:

	request_key_with_auxdata()
	request_key_async()
	request_key_async_with_auxdata()

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Paul Moore <paul.moore@hp.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>
Cc: Kevin Coffman <kwc@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/keys-request-key.txt |   11 +++---
 Documentation/keys.txt             |   14 ++++---
 include/linux/key.h                |    9 +++-
 security/keys/internal.h           |    9 +++-
 security/keys/keyctl.c             |    7 ++-
 security/keys/request_key.c        |   49 ++++++++++++++++-----------
 security/keys/request_key_auth.c   |   12 +++---
 7 files changed, 70 insertions(+), 41 deletions(-)

diff -puN Documentation/keys-request-key.txt~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string Documentation/keys-request-key.txt
--- a/Documentation/keys-request-key.txt~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string
+++ a/Documentation/keys-request-key.txt
@@ -11,26 +11,29 @@ request_key*():
 
 	struct key *request_key(const struct key_type *type,
 				const char *description,
-				const char *callout_string);
+				const char *callout_info);
 
 or:
 
 	struct key *request_key_with_auxdata(const struct key_type *type,
 					     const char *description,
-					     const char *callout_string,
+					     const char *callout_info,
+					     size_t callout_len,
 					     void *aux);
 
 or:
 
 	struct key *request_key_async(const struct key_type *type,
 				      const char *description,
-				      const char *callout_string);
+				      const char *callout_info,
+				      size_t callout_len);
 
 or:
 
 	struct key *request_key_async_with_auxdata(const struct key_type *type,
 						   const char *description,
-						   const char *callout_string,
+						   const char *callout_info,
+					     	   size_t callout_len,
 						   void *aux);
 
 Or by userspace invoking the request_key system call:
diff -puN Documentation/keys.txt~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string Documentation/keys.txt
--- a/Documentation/keys.txt~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string
+++ a/Documentation/keys.txt
@@ -771,7 +771,7 @@ payload contents" for more information.
 
 	struct key *request_key(const struct key_type *type,
 				const char *description,
-				const char *callout_string);
+				const char *callout_info);
 
     This is used to request a key or keyring with a description that matches
     the description specified according to the key type's match function. This
@@ -793,24 +793,28 @@ payload contents" for more information.
 
 	struct key *request_key_with_auxdata(const struct key_type *type,
 					     const char *description,
-					     const char *callout_string,
+					     const void *callout_info,
+					     size_t callout_len,
 					     void *aux);
 
     This is identical to request_key(), except that the auxiliary data is
-    passed to the key_type->request_key() op if it exists.
+    passed to the key_type->request_key() op if it exists, and the callout_info
+    is a blob of length callout_len, if given (the length may be 0).
 
 
 (*) A key can be requested asynchronously by calling one of:
 
 	struct key *request_key_async(const struct key_type *type,
 				      const char *description,
-				      const char *callout_string);
+				      const void *callout_info,
+				      size_t callout_len);
 
     or:
 
 	struct key *request_key_async_with_auxdata(const struct key_type *type,
 						   const char *description,
-						   const char *callout_string,
+						   const char *callout_info,
+					     	   size_t callout_len,
 					     	   void *aux);
 
     which are asynchronous equivalents of request_key() and
diff -puN include/linux/key.h~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string include/linux/key.h
--- a/include/linux/key.h~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string
+++ a/include/linux/key.h
@@ -208,16 +208,19 @@ extern struct key *request_key(struct ke
 
 extern struct key *request_key_with_auxdata(struct key_type *type,
 					    const char *description,
-					    const char *callout_info,
+					    const void *callout_info,
+					    size_t callout_len,
 					    void *aux);
 
 extern struct key *request_key_async(struct key_type *type,
 				     const char *description,
-				     const char *callout_info);
+				     const void *callout_info,
+				     size_t callout_len);
 
 extern struct key *request_key_async_with_auxdata(struct key_type *type,
 						  const char *description,
-						  const char *callout_info,
+						  const void *callout_info,
+						  size_t callout_len,
 						  void *aux);
 
 extern int wait_for_key_construction(struct key *key, bool intr);
diff -puN security/keys/internal.h~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string security/keys/internal.h
--- a/security/keys/internal.h~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string
+++ a/security/keys/internal.h
@@ -109,7 +109,8 @@ extern int install_process_keyring(struc
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
-					const char *callout_info,
+					const void *callout_info,
+					size_t callout_len,
 					void *aux,
 					struct key *dest_keyring,
 					unsigned long flags);
@@ -120,13 +121,15 @@ extern struct key *request_key_and_link(
 struct request_key_auth {
 	struct key		*target_key;
 	struct task_struct	*context;
-	char			*callout_info;
+	void			*callout_info;
+	size_t			callout_len;
 	pid_t			pid;
 };
 
 extern struct key_type key_type_request_key_auth;
 extern struct key *request_key_auth_new(struct key *target,
-					const char *callout_info);
+					const void *callout_info,
+					size_t callout_len);
 
 extern struct key *key_get_instantiation_authkey(key_serial_t target_id);
 
diff -puN security/keys/keyctl.c~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string
+++ a/security/keys/keyctl.c
@@ -152,6 +152,7 @@ asmlinkage long sys_request_key(const ch
 	struct key_type *ktype;
 	struct key *key;
 	key_ref_t dest_ref;
+	size_t callout_len;
 	char type[32], *description, *callout_info;
 	long ret;
 
@@ -169,12 +170,14 @@ asmlinkage long sys_request_key(const ch
 
 	/* pull the callout info into kernel space */
 	callout_info = NULL;
+	callout_len = 0;
 	if (_callout_info) {
 		callout_info = strndup_user(_callout_info, PAGE_SIZE);
 		if (IS_ERR(callout_info)) {
 			ret = PTR_ERR(callout_info);
 			goto error2;
 		}
+		callout_len = strlen(callout_info);
 	}
 
 	/* get the destination keyring if specified */
@@ -195,8 +198,8 @@ asmlinkage long sys_request_key(const ch
 	}
 
 	/* do the search */
-	key = request_key_and_link(ktype, description, callout_info, NULL,
-				   key_ref_to_ptr(dest_ref),
+	key = request_key_and_link(ktype, description, callout_info,
+				   callout_len, NULL, key_ref_to_ptr(dest_ref),
 				   KEY_ALLOC_IN_QUOTA);
 	if (IS_ERR(key)) {
 		ret = PTR_ERR(key);
diff -puN security/keys/request_key.c~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string security/keys/request_key.c
--- a/security/keys/request_key.c~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string
+++ a/security/keys/request_key.c
@@ -161,21 +161,22 @@ error_alloc:
  * call out to userspace for key construction
  * - we ignore program failure and go on key status instead
  */
-static int construct_key(struct key *key, const char *callout_info, void *aux)
+static int construct_key(struct key *key, const void *callout_info,
+			 size_t callout_len, void *aux)
 {
 	struct key_construction *cons;
 	request_key_actor_t actor;
 	struct key *authkey;
 	int ret;
 
-	kenter("%d,%s,%p", key->serial, callout_info, aux);
+	kenter("%d,%p,%zu,%p", key->serial, callout_info, callout_len, aux);
 
 	cons = kmalloc(sizeof(*cons), GFP_KERNEL);
 	if (!cons)
 		return -ENOMEM;
 
 	/* allocate an authorisation key */
-	authkey = request_key_auth_new(key, callout_info);
+	authkey = request_key_auth_new(key, callout_info, callout_len);
 	if (IS_ERR(authkey)) {
 		kfree(cons);
 		ret = PTR_ERR(authkey);
@@ -331,6 +332,7 @@ alloc_failed:
 static struct key *construct_key_and_link(struct key_type *type,
 					  const char *description,
 					  const char *callout_info,
+					  size_t callout_len,
 					  void *aux,
 					  struct key *dest_keyring,
 					  unsigned long flags)
@@ -348,7 +350,7 @@ static struct key *construct_key_and_lin
 	key_user_put(user);
 
 	if (ret == 0) {
-		ret = construct_key(key, callout_info, aux);
+		ret = construct_key(key, callout_info, callout_len, aux);
 		if (ret < 0)
 			goto construction_failed;
 	}
@@ -370,7 +372,8 @@ construction_failed:
  */
 struct key *request_key_and_link(struct key_type *type,
 				 const char *description,
-				 const char *callout_info,
+				 const void *callout_info,
+				 size_t callout_len,
 				 void *aux,
 				 struct key *dest_keyring,
 				 unsigned long flags)
@@ -378,8 +381,8 @@ struct key *request_key_and_link(struct 
 	struct key *key;
 	key_ref_t key_ref;
 
-	kenter("%s,%s,%s,%p,%p,%lx",
-	       type->name, description, callout_info, aux,
+	kenter("%s,%s,%p,%zu,%p,%p,%lx",
+	       type->name, description, callout_info, callout_len, aux,
 	       dest_keyring, flags);
 
 	/* search all the process keyrings for a key */
@@ -398,7 +401,8 @@ struct key *request_key_and_link(struct 
 			goto error;
 
 		key = construct_key_and_link(type, description, callout_info,
-					     aux, dest_keyring, flags);
+					     callout_len, aux, dest_keyring,
+					     flags);
 	}
 
 error:
@@ -434,10 +438,13 @@ struct key *request_key(struct key_type 
 			const char *callout_info)
 {
 	struct key *key;
+	size_t callout_len = 0;
 	int ret;
 
-	key = request_key_and_link(type, description, callout_info, NULL,
-				   NULL, KEY_ALLOC_IN_QUOTA);
+	if (callout_info)
+		callout_len = strlen(callout_info);
+	key = request_key_and_link(type, description, callout_info, callout_len,
+				   NULL, NULL, KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key)) {
 		ret = wait_for_key_construction(key, false);
 		if (ret < 0) {
@@ -458,14 +465,15 @@ EXPORT_SYMBOL(request_key);
  */
 struct key *request_key_with_auxdata(struct key_type *type,
 				     const char *description,
-				     const char *callout_info,
+				     const void *callout_info,
+				     size_t callout_len,
 				     void *aux)
 {
 	struct key *key;
 	int ret;
 
-	key = request_key_and_link(type, description, callout_info, aux,
-				   NULL, KEY_ALLOC_IN_QUOTA);
+	key = request_key_and_link(type, description, callout_info, callout_len,
+				   aux, NULL, KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key)) {
 		ret = wait_for_key_construction(key, false);
 		if (ret < 0) {
@@ -485,10 +493,12 @@ EXPORT_SYMBOL(request_key_with_auxdata);
  */
 struct key *request_key_async(struct key_type *type,
 			      const char *description,
-			      const char *callout_info)
+			      const void *callout_info,
+			      size_t callout_len)
 {
-	return request_key_and_link(type, description, callout_info, NULL,
-				    NULL, KEY_ALLOC_IN_QUOTA);
+	return request_key_and_link(type, description, callout_info,
+				    callout_len, NULL, NULL,
+				    KEY_ALLOC_IN_QUOTA);
 }
 EXPORT_SYMBOL(request_key_async);
 
@@ -500,10 +510,11 @@ EXPORT_SYMBOL(request_key_async);
  */
 struct key *request_key_async_with_auxdata(struct key_type *type,
 					   const char *description,
-					   const char *callout_info,
+					   const void *callout_info,
+					   size_t callout_len,
 					   void *aux)
 {
-	return request_key_and_link(type, description, callout_info, aux,
-				    NULL, KEY_ALLOC_IN_QUOTA);
+	return request_key_and_link(type, description, callout_info,
+				    callout_len, aux, NULL, KEY_ALLOC_IN_QUOTA);
 }
 EXPORT_SYMBOL(request_key_async_with_auxdata);
diff -puN security/keys/request_key_auth.c~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string security/keys/request_key_auth.c
--- a/security/keys/request_key_auth.c~keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string
+++ a/security/keys/request_key_auth.c
@@ -61,7 +61,7 @@ static void request_key_auth_describe(co
 
 	seq_puts(m, "key:");
 	seq_puts(m, key->description);
-	seq_printf(m, " pid:%d ci:%zu", rka->pid, strlen(rka->callout_info));
+	seq_printf(m, " pid:%d ci:%zu", rka->pid, rka->callout_len);
 
 } /* end request_key_auth_describe() */
 
@@ -77,7 +77,7 @@ static long request_key_auth_read(const 
 	size_t datalen;
 	long ret;
 
-	datalen = strlen(rka->callout_info);
+	datalen = rka->callout_len;
 	ret = datalen;
 
 	/* we can return the data as is */
@@ -137,7 +137,8 @@ static void request_key_auth_destroy(str
  * create an authorisation token for /sbin/request-key or whoever to gain
  * access to the caller's security data
  */
-struct key *request_key_auth_new(struct key *target, const char *callout_info)
+struct key *request_key_auth_new(struct key *target, const void *callout_info,
+				 size_t callout_len)
 {
 	struct request_key_auth *rka, *irka;
 	struct key *authkey = NULL;
@@ -152,7 +153,7 @@ struct key *request_key_auth_new(struct 
 		kleave(" = -ENOMEM");
 		return ERR_PTR(-ENOMEM);
 	}
-	rka->callout_info = kmalloc(strlen(callout_info) + 1, GFP_KERNEL);
+	rka->callout_info = kmalloc(callout_len, GFP_KERNEL);
 	if (!rka->callout_info) {
 		kleave(" = -ENOMEM");
 		kfree(rka);
@@ -186,7 +187,8 @@ struct key *request_key_auth_new(struct 
 	}
 
 	rka->target_key = key_get(target);
-	strcpy(rka->callout_info, callout_info);
+	memcpy(rka->callout_info, callout_info, callout_len);
+	rka->callout_len = callout_len;
 
 	/* allocate the auth key */
 	sprintf(desc, "%x", target->serial);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
alloc_uid-cleanup.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

