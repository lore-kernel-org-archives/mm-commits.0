From: akpm@linux-foundation.org
Subject: - revoke-core-code-revoke-no-revoke-for-nommu.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:46 -0700
Message-ID: <200705090955.l499tkNt020524@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757257AbXEIJ4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:56:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, alan@lxorguk.ukuu.org.uk, bryan.wu@analog.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     revoke: no revoke for nommu
has been removed from the -mm tree.  Its filename was
     revoke-core-code-revoke-no-revoke-for-nommu.patch

This patch was dropped because it was folded into revoke-core-code.patch

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
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/Makefile~revoke-core-code-revoke-no-revoke-for-nommu fs/Makefile
--- a/fs/Makefile~revoke-core-code-revoke-no-revoke-for-nommu
+++ a/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o revoke.o revoked_inode.o
+		stack.o
 
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

origin.patch
krealloc-fix-kerneldoc-comments.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
unionfs-fix-slab-abuses-with-krealloc.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
revoke-core-code-break-cow-for-private-mappings.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
revoke-core-code-break-cow-fixes.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
