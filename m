From: akpm@linux-foundation.org
Subject: + fix-a-bad-bug-in-read_cache_page_async.patch added to -mm tree
Date: Wed, 09 May 2007 10:05:52 -0700
Message-ID: <200705091705.l49H5q35028554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbXEIRGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 13:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, nickpiggin@yahoo.com.au


The patch titled
     Fix a bad bug in read_cache_page_async() [try #2]
has been added to the -mm tree.  Its filename is
     fix-a-bad-bug-in-read_cache_page_async.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix a bad bug in read_cache_page_async() [try #2]
From: David Howells <dhowells@redhat.com>

Fix a bad bug in read_cache_page_async() introduced in commit:

	6fe6900e1e5b6fa9e5c59aa5061f244fe3f467e2

This adds:

	mark_page_accessed(page)

into the error handling path in read_cache_page_async().  In such a case,
'page' holds the error code.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/filemap.c~fix-a-bad-bug-in-read_cache_page_async mm/filemap.c
--- a/mm/filemap.c~fix-a-bad-bug-in-read_cache_page_async
+++ a/mm/filemap.c
@@ -1599,7 +1599,7 @@ struct page *read_cache_page_async(struc
 retry:
 	page = __read_cache_page(mapping, index, filler, data);
 	if (IS_ERR(page))
-		goto out;
+		return page;
 	mark_page_accessed(page);
 	if (PageUptodate(page))
 		goto out;
@@ -1617,9 +1617,9 @@ retry:
 	err = filler(data, page);
 	if (err < 0) {
 		page_cache_release(page);
-		page = ERR_PTR(err);
+		return ERR_PTR(err);
 	}
- out:
+out:
 	mark_page_accessed(page);
 	return page;
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
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
frv-gdb-use-__maybe_unused.patch
mutex-subsystem-synchro-test-module.patch
