From: akpm@linux-foundation.org
Subject: - afs-export-a-couple-of-core-functions-for-afs-write.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:33 -0700
Message-ID: <200705092150.l49LoXD4002817@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504AbXEIVuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFS: export a couple of core functions for AFS write support
has been removed from the -mm tree.  Its filename was
     afs-export-a-couple-of-core-functions-for-afs-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AFS: export a couple of core functions for AFS write support
From: David Howells <dhowells@redhat.com>

Export a couple of core functions for AFS write support to use:

	find_get_pages_contig()
	find_get_pages_tag()

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/filemap.c~afs-export-a-couple-of-core-functions-for-afs-write mm/filemap.c
--- a/mm/filemap.c~afs-export-a-couple-of-core-functions-for-afs-write
+++ a/mm/filemap.c
@@ -750,6 +750,7 @@ unsigned find_get_pages_contig(struct ad
 	read_unlock_irq(&mapping->tree_lock);
 	return i;
 }
+EXPORT_SYMBOL(find_get_pages_contig);
 
 /**
  * find_get_pages_tag - find and return pages that match @tag
@@ -778,6 +779,7 @@ unsigned find_get_pages_tag(struct addre
 	read_unlock_irq(&mapping->tree_lock);
 	return ret;
 }
+EXPORT_SYMBOL(find_get_pages_tag);
 
 /**
  * grab_cache_page_nowait - returns locked page at given index in given cache
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
introduce-freezer-flags-rev-2.patch
afs-write-support-fixes.patch
afs-further-write-support-fixes.patch
af_rxrpc-reduce-debugging-noise.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
git-net.patch
frv-gdb-use-__maybe_unused.patch
mutex-subsystem-synchro-test-module.patch
