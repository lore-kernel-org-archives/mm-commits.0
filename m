From: akpm@linux-foundation.org
Subject: + afs-export-a-couple-of-core-functions-for-afs-write.patch added to -mm tree
Date: Tue, 08 May 2007 17:00:59 -0700
Message-ID: <200705090000.l4900xdb005374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031997AbXEIABJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:01:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     AFS: export a couple of core functions for AFS write support
has been added to the -mm tree.  Its filename is
     afs-export-a-couple-of-core-functions-for-afs-write.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+)

diff -puN mm/filemap.c~afs-export-a-couple-of-core-functions-for-afs-write mm/filemap.c
--- a/mm/filemap.c~afs-export-a-couple-of-core-functions-for-afs-write
+++ a/mm/filemap.c
@@ -751,6 +751,7 @@ unsigned find_get_pages_contig(struct ad
 	read_unlock_irq(&mapping->tree_lock);
 	return i;
 }
+EXPORT_SYMBOL(find_get_pages_contig);
 
 /**
  * find_get_pages_tag - find and return pages that match @tag
@@ -779,6 +780,7 @@ unsigned find_get_pages_tag(struct addre
 	read_unlock_irq(&mapping->tree_lock);
 	return ret;
 }
+EXPORT_SYMBOL(find_get_pages_tag);
 
 /**
  * grab_cache_page_nowait - returns locked page at given index in given cache
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
use-slab_panic-flag-cleanup.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
smaps-only-define-clear_refs-for-config_mmu.patch
frv-miscellaneous-fixes.patch
frv-replace-pgd-management-via-slabs-through-quicklists.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
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
make-cancel_rearming_delayed_work-reliable-spelling.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
frv-gdb-use-__maybe_unused.patch
mutex-subsystem-synchro-test-module.patch
