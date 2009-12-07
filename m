From: akpm@linux-foundation.org
Subject: + fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch added to -mm tree
Date: Mon, 07 Dec 2009 13:47:30 -0800
Message-ID: <200912072147.nB7LlU2Z007035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965102AbZLGVrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 16:47:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, akpm@linux-foundation.org


The patch titled
     FS-Cache: Avoid maybe-used-uninitialised warning on variable
has been added to the -mm tree.  Its filename is
     fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
bsdacct-fix-uid-gid-misreporting.patch
linux-next.patch
mm-make-totalhigh_pages-unsigned-long.patch
security-do-not-check-mmap_min_addr-on-nommu-systems-2.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-fix-malloc-performance-by-adding-uninitialized-flag.patch
procfs-use-proper-units-for-nommu-statm.patch
procfs-use-proper-units-for-nommu-statm-fix.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
tree-wide-convert-open-calls-to-remove-spaces-to-skip_spaces-lib-function.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

