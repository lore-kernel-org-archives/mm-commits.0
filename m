From: akpm@linux-foundation.org
Subject: - afs-further-write-support-fixes.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:09 -0700
Message-ID: <200705120515.l4C5F9em001731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756274AbXELFPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFS: further write support fixes
has been removed from the -mm tree.  Its filename was
     afs-further-write-support-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AFS: further write support fixes
From: David Howells <dhowells@redhat.com>

Further fixes for AFS write support:

 (1) The afs_send_pages() outer loop must do an extra iteration if it ends
     with 'first == last' because 'last' is inclusive in the page set
     otherwise it fails to send the last page and complete the RxRPC op under
     some circumstances.

 (2) Similarly, the outer loop in afs_pages_written_back() must also do an
     extra iteration if it ends with 'first == last', otherwise it fails to
     clear PG_writeback on the last page under some circumstances.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/rxrpc.c |    2 +-
 fs/afs/write.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/afs/rxrpc.c~afs-further-write-support-fixes fs/afs/rxrpc.c
--- a/fs/afs/rxrpc.c~afs-further-write-support-fixes
+++ a/fs/afs/rxrpc.c
@@ -294,7 +294,7 @@ int afs_send_pages(struct afs_call *call
 			put_page(pages[loop]);
 		if (ret < 0)
 			break;
-	} while (first < last);
+	} while (first <= last);
 
 	_leave(" = %d", ret);
 	return ret;
diff -puN fs/afs/write.c~afs-further-write-support-fixes fs/afs/write.c
--- a/fs/afs/write.c~afs-further-write-support-fixes
+++ a/fs/afs/write.c
@@ -669,7 +669,7 @@ void afs_pages_written_back(struct afs_v
 	pagevec_init(&pv, 0);
 
 	do {
-		_debug("attach %lx-%lx", first, last);
+		_debug("done %lx-%lx", first, last);
 
 		count = last - first + 1;
 		if (count > PAGEVEC_SIZE)
@@ -701,7 +701,7 @@ void afs_pages_written_back(struct afs_v
 		}
 
 		__pagevec_release(&pv);
-	} while (first < last);
+	} while (first <= last);
 
 	_leave("");
 }
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
afs-fix-interminable-loop-in-afs_write_back_from_locked_page.patch
afs-fix-a-couple-of-problems-with-unlinking-afs-files.patch
afs-implement-statfs.patch
frv-gdb-use-__maybe_unused.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
git-net.patch
remove-slab_ctor_constructor.patch
split-usermodehelper-setup-from-execution.patch
mutex-subsystem-synchro-test-module.patch
