From: akpm@linux-foundation.org
Subject: - afs-fix-afs_prepare_write.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:53 -0700
Message-ID: <200705180705.l4I75qDj010130@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760952AbXERHIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AFS: Fix afs_prepare_write()
has been removed from the -mm tree.  Its filename was
     afs-fix-afs_prepare_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AFS: Fix afs_prepare_write()
From: David Howells <dhowells@redhat.com>

afs_prepare_write() should not mark a page up to date if it only partially
fills it in, in expectation of the caller filling in the rest prior to calling
commit_write().  commit_write(), however, should mark the page up to date.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/afs/write.c~afs-fix-afs_prepare_write fs/afs/write.c
--- a/fs/afs/write.c~afs-fix-afs_prepare_write
+++ a/fs/afs/write.c
@@ -206,7 +206,6 @@ int afs_prepare_write(struct file *file,
 			_leave(" = %d [prep]", ret);
 			return ret;
 		}
-		SetPageUptodate(page);
 	}
 
 try_again:
@@ -311,8 +310,8 @@ int afs_commit_write(struct file *file, 
 		spin_unlock(&vnode->writeback_lock);
 	}
 
+	SetPageUptodate(page);
 	set_page_dirty(page);
-
 	if (PageDirty(page))
 		_debug("dirtied");
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
af_rxrpc-af_rxrpc-depends-on-ipv4.patch
af_rxrpc-make-call-state-names-available-if-config_proc_fs=n.patch
split-usermodehelper-setup-from-execution.patch
mutex-subsystem-synchro-test-module.patch
