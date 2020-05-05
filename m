From: akpm@linux-foundation.org
Subject: +
 mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects.patch added to
 -mm tree
Date: Tue, 05 May 2020 13:36:47 -0700
Message-ID: <20200505203647.n_G5FPWzQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728584AbgEEUgt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 16:36:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, ebiggers@google.com, jarkko.sakkinen@linux.intel.com, jmorris@namei.org, joe@perches.com, longman@redhat.com, mm-commits@vger.kernel.org, rientjes@google.com, serge@hallyn.com, torvalds@linux-foundation.org, urezki@gmail.com, willy@infradead.org


The patch titled
     Subject: mm: add kvfree_sensitive() for freeing sensitive data objects
has been added to the -mm tree.  Its filename is
     mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm: add kvfree_sensitive() for freeing sensitive data objects

For kvmalloc'ed data object that contains sensitive information like
cryptographic keys, we need to make sure that the buffer is always cleared
before freeing it.  Using memset() alone for buffer clearing may not
provide certainty as the compiler may compile it away.  To be sure, the
special memzero_explicit() has to be used.

This patch introduces a new kvfree_sensitive() for freeing those sensitive
data objects allocated by kvmalloc().  The relevant places where
kvfree_sensitive() can be used are modified to use it.

Link: http://lkml.kernel.org/r/20200407200318.11711-1-longman@redhat.com
Fixes: 4f0882491a14 ("KEYS: Avoid false positive ENOMEM error on key read")
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    1 +
 mm/util.c                |   18 ++++++++++++++++++
 security/keys/internal.h |   11 -----------
 security/keys/keyctl.c   |   16 +++++-----------
 4 files changed, 24 insertions(+), 22 deletions(-)

--- a/include/linux/mm.h~mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects
+++ a/include/linux/mm.h
@@ -781,6 +781,7 @@ static inline void *kvcalloc(size_t n, s
 }
 
 extern void kvfree(const void *addr);
+extern void kvfree_sensitive(const void *addr, size_t len);
 
 static inline int compound_mapcount(struct page *page)
 {
--- a/mm/util.c~mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects
+++ a/mm/util.c
@@ -604,6 +604,24 @@ void kvfree(const void *addr)
 }
 EXPORT_SYMBOL(kvfree);
 
+/**
+ * kvfree_sensitive - Free a data object containing sensitive information.
+ * @addr: address of the data object to be freed.
+ * @len: length of the data object.
+ *
+ * Use the special memzero_explicit() function to clear the content of a
+ * kvmalloc'ed object containing sensitive data to make sure that the
+ * compiler won't optimize out the data clearing.
+ */
+void kvfree_sensitive(const void *addr, size_t len)
+{
+	if (likely(!ZERO_OR_NULL_PTR(addr))) {
+		memzero_explicit((void *)addr, len);
+		kvfree(addr);
+	}
+}
+EXPORT_SYMBOL(kvfree_sensitive);
+
 static inline void *__page_rmapping(struct page *page)
 {
 	unsigned long mapping;
--- a/security/keys/internal.h~mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects
+++ a/security/keys/internal.h
@@ -350,15 +350,4 @@ static inline void key_check(const struc
 #define key_check(key) do {} while(0)
 
 #endif
-
-/*
- * Helper function to clear and free a kvmalloc'ed memory object.
- */
-static inline void __kvzfree(const void *addr, size_t len)
-{
-	if (addr) {
-		memset((void *)addr, 0, len);
-		kvfree(addr);
-	}
-}
 #endif /* _INTERNAL_H */
--- a/security/keys/keyctl.c~mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects
+++ a/security/keys/keyctl.c
@@ -142,10 +142,7 @@ SYSCALL_DEFINE5(add_key, const char __us
 
 	key_ref_put(keyring_ref);
  error3:
-	if (payload) {
-		memzero_explicit(payload, plen);
-		kvfree(payload);
-	}
+	kvfree_sensitive(payload, plen);
  error2:
 	kfree(description);
  error:
@@ -360,7 +357,7 @@ long keyctl_update_key(key_serial_t id,
 
 	key_ref_put(key_ref);
 error2:
-	__kvzfree(payload, plen);
+	kvfree_sensitive(payload, plen);
 error:
 	return ret;
 }
@@ -914,7 +911,7 @@ can_read_key:
 		 */
 		if (ret > key_data_len) {
 			if (unlikely(key_data))
-				__kvzfree(key_data, key_data_len);
+				kvfree_sensitive(key_data, key_data_len);
 			key_data_len = ret;
 			continue;	/* Allocate buffer */
 		}
@@ -923,7 +920,7 @@ can_read_key:
 			ret = -EFAULT;
 		break;
 	}
-	__kvzfree(key_data, key_data_len);
+	kvfree_sensitive(key_data, key_data_len);
 
 key_put_out:
 	key_put(key);
@@ -1225,10 +1222,7 @@ long keyctl_instantiate_key_common(key_s
 		keyctl_change_reqkey_auth(NULL);
 
 error2:
-	if (payload) {
-		memzero_explicit(payload, plen);
-		kvfree(payload);
-	}
+	kvfree_sensitive(payload, plen);
 error:
 	return ret;
 }
_

Patches currently in -mm which might be from longman@redhat.com are

mm-slub-fix-incorrect-interpretation-of-s-offset.patch
mm-add-kvfree_sensitive-for-freeing-sensitive-data-objects.patch
