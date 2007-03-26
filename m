From: akpm@linux-foundation.org
Subject: + revoke-core-code-revoke-no-revoke-for-nommu.patch added to -mm tree
Date: Mon, 26 Mar 2007 14:16:45 -0700
Message-ID: <200703262116.l2QLGjh9030810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52353 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbXCZVRX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 17:17:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, alan@lxorguk.ukuu.org.uk, bryan.wu@analog.com, dhowells@redhat.com


The patch titled
     revoke: no revoke for nommu
has been added to the -mm tree.  Its filename is
     revoke-core-code-revoke-no-revoke-for-nommu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke: no revoke for nommu
From: Pekka Enberg <penberg@cs.helsinki.fi>

There's just no sane way to revoke shared memory mappings for NOMMU so lets
disable the thing completely when CONFIG_MMU=n.

Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/Makefile~revoke-core-code-revoke-no-revoke-for-nommu fs/Makefile
--- a/fs/Makefile~revoke-core-code-revoke-no-revoke-for-nommu
+++ a/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o anon_inodes.o revoke.o revoked_inode.o
+		stack.o anon_inodes.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
@@ -19,6 +19,7 @@ else
 obj-y +=	no-block.o
 endif
 
+obj-$(CONFIG_MMU)		+= revoke.o revoked_inode.o
 obj-$(CONFIG_INOTIFY)		+= inotify.o
 obj-$(CONFIG_INOTIFY_USER)	+= inotify_user.o
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
