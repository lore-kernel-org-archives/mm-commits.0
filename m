From: akpm@linux-foundation.org
Subject: + afs-further-write-support-fixes.patch added to -mm tree
Date: Wed, 09 May 2007 10:15:54 -0700
Message-ID: <200705091715.l49HFsmW028837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755422AbXEIRQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 13:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     AFS: further write support fixes
has been added to the -mm tree.  Its filename is
     afs-further-write-support-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
frv-replace-pgd-management-via-slabs-through-quicklists.patch
afs-export-a-couple-of-core-functions-for-afs-write.patch
afs-afs-fixups.patch
afs-implement-basic-file-write-support.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
introduce-freezer-flags-rev-2.patch
make-cancel_rearming_delayed_work-reliable.patch
rename-thread_info-to-stack.patch
fix-a-bad-bug-in-read_cache_page_async.patch
afs-write-support-fixes.patch
afs-further-write-support-fixes.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
frv-gdb-use-__maybe_unused.patch
mutex-subsystem-synchro-test-module.patch
