From: akpm@linux-foundation.org
Subject: - keys-make-request_key-and-co-fundamentally-asynchronous-update.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:24:39 -0700
Message-ID: <200710162224.l9GMOdHo020862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934737AbXJPWYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:24:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Make request_key() and co fundamentally asynchronous
has been removed from the -mm tree.  Its filename was
     keys-make-request_key-and-co-fundamentally-asynchronous-update.patch

This patch was dropped because it was folded into keys-make-request_key-and-co-fundamentally-asynchronous.patch

------------------------------------------------------
Subject: Make request_key() and co fundamentally asynchronous
From: David Howells <dhowells@redhat.com>

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/key-type.h         |    4 ++--
 net/rxrpc/ar-key.c               |    3 ---
 security/keys/internal.h         |   20 +++++++++++++-------
 security/keys/key.c              |    7 +++++--
 security/keys/request_key.c      |    6 ------
 security/keys/request_key_auth.c |    2 ++
 6 files changed, 22 insertions(+), 20 deletions(-)

diff -puN include/linux/key-type.h~keys-make-request_key-and-co-fundamentally-asynchronous-update include/linux/key-type.h
--- a/include/linux/key-type.h~keys-make-request_key-and-co-fundamentally-asynchronous-update
+++ a/include/linux/key-type.h
@@ -21,8 +21,8 @@
  * - passed to the request_key actor if supplied
  */
 struct key_construction {
-	struct key		*key;	/* key being constructed */
-	struct key		*authkey;/* authorisation key for key being constructed */
+	struct key	*key;	/* key being constructed */
+	struct key	*authkey;/* authorisation for key being constructed */
 };
 
 typedef int (*request_key_actor_t)(struct key_construction *key,
diff -puN net/rxrpc/ar-key.c~keys-make-request_key-and-co-fundamentally-asynchronous-update net/rxrpc/ar-key.c
--- a/net/rxrpc/ar-key.c~keys-make-request_key-and-co-fundamentally-asynchronous-update
+++ a/net/rxrpc/ar-key.c
@@ -40,7 +40,6 @@ struct key_type key_type_rxrpc = {
 	.destroy	= rxrpc_destroy,
 	.describe	= rxrpc_describe,
 };
-
 EXPORT_SYMBOL(key_type_rxrpc);
 
 /*
@@ -330,7 +329,6 @@ error:
 	_leave(" = -ENOMEM [ins %d]", ret);
 	return -ENOMEM;
 }
-
 EXPORT_SYMBOL(rxrpc_get_server_data_key);
 
 /**
@@ -359,5 +357,4 @@ struct key *rxrpc_get_null_key(const cha
 
 	return key;
 }
-
 EXPORT_SYMBOL(rxrpc_get_null_key);
diff -puN security/keys/internal.h~keys-make-request_key-and-co-fundamentally-asynchronous-update security/keys/internal.h
--- a/security/keys/internal.h~keys-make-request_key-and-co-fundamentally-asynchronous-update
+++ a/security/keys/internal.h
@@ -15,19 +15,25 @@
 #include <linux/key-type.h>
 #include <linux/key-ui.h>
 
-static inline __attribute__((format(printf,1,2)))
+static inline __attribute__((format(printf, 1, 2)))
 void no_printk(const char *fmt, ...)
 {
 }
 
 #ifdef __KDEBUG
-#define kenter(FMT, ...) printk("==> %s("FMT")\n",__FUNCTION__ ,##__VA_ARGS__)
-#define kleave(FMT, ...) printk("<== %s()"FMT"\n",__FUNCTION__ ,##__VA_ARGS__)
-#define kdebug(FMT, ...) printk(FMT"\n" ,##__VA_ARGS__)
+#define kenter(FMT, ...) \
+	printk(KERN_DEBUG "==> %s("FMT")\n", __FUNCTION__, ##__VA_ARGS__)
+#define kleave(FMT, ...) \
+	printk(KERN_DEBUG "<== %s()"FMT"\n", __FUNCTION__, ##__VA_ARGS__)
+#define kdebug(FMT, ...) \
+	printk(KERN_DEBUG "xxx" FMT"yyy\n", ##__VA_ARGS__)
 #else
-#define kenter(FMT, ...) no_printk("==> %s("FMT")\n",__FUNCTION__ ,##__VA_ARGS__)
-#define kleave(FMT, ...) no_printk("<== %s()"FMT"\n",__FUNCTION__ ,##__VA_ARGS__)
-#define kdebug(FMT, ...) no_printk(FMT"\n" ,##__VA_ARGS__)
+#define kenter(FMT, ...) \
+	no_printk(KERN_DEBUG "==> %s("FMT")\n", __FUNCTION__, ##__VA_ARGS__)
+#define kleave(FMT, ...) \
+	no_printk(KERN_DEBUG "<== %s()"FMT"\n", __FUNCTION__, ##__VA_ARGS__)
+#define kdebug(FMT, ...) \
+	no_printk(KERN_DEBUG FMT"\n", ##__VA_ARGS__)
 #endif
 
 extern struct key_type key_type_user;
diff -puN security/keys/key.c~keys-make-request_key-and-co-fundamentally-asynchronous-update security/keys/key.c
--- a/security/keys/key.c~keys-make-request_key-and-co-fundamentally-asynchronous-update
+++ a/security/keys/key.c
@@ -899,8 +899,11 @@ void key_revoke(struct key *key)
 {
 	key_check(key);
 
-	/* make sure no one's trying to change or use the key when we mark
-	 * it */
+	/* make sure no one's trying to change or use the key when we mark it
+	 * - we tell lockdep that we might nest because we might be revoking an
+	 *   authorisation key whilst holding the sem on a key we've just
+	 *   instantiated
+	 */
 	down_write_nested(&key->sem, 1);
 	if (!test_and_set_bit(KEY_FLAG_REVOKED, &key->flags) &&
 	    key->type->revoke)
diff -puN security/keys/request_key.c~keys-make-request_key-and-co-fundamentally-asynchronous-update security/keys/request_key.c
--- a/security/keys/request_key.c~keys-make-request_key-and-co-fundamentally-asynchronous-update
+++ a/security/keys/request_key.c
@@ -53,7 +53,6 @@ void complete_request_key(struct key_con
 	key_put(cons->authkey);
 	kfree(cons);
 }
-
 EXPORT_SYMBOL(complete_request_key);
 
 /*
@@ -421,7 +420,6 @@ int wait_for_key_construction(struct key
 		return ret;
 	return key_validate(key);
 }
-
 EXPORT_SYMBOL(wait_for_key_construction);
 
 /*
@@ -449,7 +447,6 @@ struct key *request_key(struct key_type 
 	}
 	return key;
 }
-
 EXPORT_SYMBOL(request_key);
 
 /*
@@ -478,7 +475,6 @@ struct key *request_key_with_auxdata(str
 	}
 	return key;
 }
-
 EXPORT_SYMBOL(request_key_with_auxdata);
 
 /*
@@ -494,7 +490,6 @@ struct key *request_key_async(struct key
 	return request_key_and_link(type, description, callout_info, NULL,
 				    NULL, KEY_ALLOC_IN_QUOTA);
 }
-
 EXPORT_SYMBOL(request_key_async);
 
 /*
@@ -511,5 +506,4 @@ struct key *request_key_async_with_auxda
 	return request_key_and_link(type, description, callout_info, aux,
 				    NULL, KEY_ALLOC_IN_QUOTA);
 }
-
 EXPORT_SYMBOL(request_key_async_with_auxdata);
diff -puN security/keys/request_key_auth.c~keys-make-request_key-and-co-fundamentally-asynchronous-update security/keys/request_key_auth.c
--- a/security/keys/request_key_auth.c~keys-make-request_key-and-co-fundamentally-asynchronous-update
+++ a/security/keys/request_key_auth.c
@@ -210,6 +210,7 @@ struct key *request_key_auth_new(struct 
 
 auth_key_revoked:
 	up_read(&current->request_key_auth->sem);
+	kfree(rka->callout_info);
 	kfree(rka);
 	kleave("= -EKEYREVOKED");
 	return ERR_PTR(-EKEYREVOKED);
@@ -219,6 +220,7 @@ error_inst:
 	key_put(authkey);
 error_alloc:
 	key_put(rka->target_key);
+	kfree(rka->callout_info);
 	kfree(rka);
 	kleave("= %d", ret);
 	return ERR_PTR(ret);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
fs-afs-possible-cleanups.patch
binfmt_flat-warning-fixes.patch
keys-make-request_key-and-co-fundamentally-asynchronous.patch
keys-make-request_key-and-co-fundamentally-asynchronous-update.patch
keys-missing-word-in-documentation.patch
menuconfig-transform-network-filesystems-menu.patch
64-bit-i_version-afs-fixes.patch
bitops-introduce-lock-ops.patch
mutex-subsystem-synchro-test-module.patch
