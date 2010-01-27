From: akpm@linux-foundation.org
Subject: + vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:50:58 -0800
Message-ID: <201001270050.o0R0owLG000978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322Ab0A0AwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com, hch@infradead.org, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     vfs: take f_lock on modifying f_mode after open time
has been added to the -mm tree.  Its filename is
     vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch

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
Subject: vfs: take f_lock on modifying f_mode after open time
From: Wu Fengguang <fengguang.wu@intel.com>

We'll introduce FMODE_RANDOM which will be runtime modified.  So protect
all runtime modification to f_mode with f_lock to avoid races.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@kernel.org>			[2.6.33.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c     |    2 ++
 fs/nfsd/nfs4state.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN fs/file_table.c~vfs-take-f_lock-on-modifying-f_mode-after-open-time fs/file_table.c
--- a/fs/file_table.c~vfs-take-f_lock-on-modifying-f_mode-after-open-time
+++ a/fs/file_table.c
@@ -401,7 +401,9 @@ retry:
 			continue;
 		if (!(f->f_mode & FMODE_WRITE))
 			continue;
+		spin_lock(&f->f_lock);
 		f->f_mode &= ~FMODE_WRITE;
+		spin_unlock(&f->f_lock);
 		if (file_check_writeable(f) != 0)
 			continue;
 		file_release_write(f);
diff -puN fs/nfsd/nfs4state.c~vfs-take-f_lock-on-modifying-f_mode-after-open-time fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~vfs-take-f_lock-on-modifying-f_mode-after-open-time
+++ a/fs/nfsd/nfs4state.c
@@ -1998,7 +1998,9 @@ nfs4_file_downgrade(struct file *filp, u
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
 		drop_file_write_access(filp);
+		spin_lock(&filp->f_lock);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
+		spin_unlock(&filp->f_lock);
 	}
 }
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
devmem-check-vmalloc-address-on-kmem-read-write.patch
devmem-fix-kmem-write-bug-on-memory-holes.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch
readahead-introduce-fmode_random-for-posix_fadv_random.patch
resources-introduce-generic-page_is_ram.patch
resources-introduce-generic-page_is_ram-fix.patch
x86-remove-bios-data-range-from-e820.patch
x86-use-the-generic-page_is_ram.patch

