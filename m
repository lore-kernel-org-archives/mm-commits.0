From: akpm@linux-foundation.org
Subject: [merged] fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:31 -0800
Message-ID: <200912162039.nBGKdVat013541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964994AbZLPUjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     FS-Cache: Avoid maybe-used-uninitialised warning on variable
has been removed from the -mm tree.  Its filename was
     fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FS-Cache: Avoid maybe-used-uninitialised warning on variable
From: David Howells <dhowells@redhat.com>

Andrew Morton's compiler sees the following warning in FS-Cache:

fs/fscache/object-list.c: In function 'fscache_objlist_lookup':
fs/fscache/object-list.c:94: warning: 'obj' may be used uninitialized in this function

which my compiler doesn't.  This is a false positive as obj can only be
used in the comparison against minobj if minobj has been set to something
other than NULL, but for that to happen, obj has to be first set to
something.

Deal with this by preclearing obj too.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/object-list.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fscache/object-list.c~fs-cache-avoid-maybe-used-uninitialised-warning-on-variable fs/fscache/object-list.c
--- a/fs/fscache/object-list.c~fs-cache-avoid-maybe-used-uninitialised-warning-on-variable
+++ a/fs/fscache/object-list.c
@@ -91,7 +91,7 @@ EXPORT_SYMBOL(fscache_object_destroy);
  */
 static struct fscache_object *fscache_objlist_lookup(loff_t *_pos)
 {
-	struct fscache_object *pobj, *obj, *minobj = NULL;
+	struct fscache_object *pobj, *obj = NULL, *minobj = NULL;
 	struct rb_node *p;
 	unsigned long pos;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
mm-make-totalhigh_pages-unsigned-long.patch
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

