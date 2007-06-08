From: akpm@linux-foundation.org
Subject: + make-sure-readv-stops-reading-when-it-hits-end-of-file.patch added to -mm tree
Date: Thu, 07 Jun 2007 18:19:23 -0700
Message-ID: <200706080119.l581JNf2014691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965596AbXFHBUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 21:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     NeilBrown <neilb@suse.de>
has been added to the -mm tree.  Its filename is
     make-sure-readv-stops-reading-when-it-hits-end-of-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NeilBrown <neilb@suse.de>


The do_loop_readv_writev implementation of readv breaks out of the loop as
soon as a single read request didn't fill it's buffer:

		if (nr != len)
			break;

The generic_file_aio_read version doesn't.  So if it hits EOF before the end
of the list of buffers, it will try again on the next buffer.  If the file was
extended in the mean time, this will produce a bad result.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN mm/filemap.c~make-sure-readv-stops-reading-when-it-hits-end-of-file mm/filemap.c
--- a/mm/filemap.c~make-sure-readv-stops-reading-when-it-hits-end-of-file
+++ a/mm/filemap.c
@@ -1191,6 +1191,8 @@ generic_file_aio_read(struct kiocb *iocb
 				retval = retval ?: desc.error;
 				break;
 			}
+			if (desc.count > 0)
+				break;
 		}
 	}
 out:
_

Patches currently in -mm which might be from neilb@suse.de are

git-md-accel.patch
block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
fix-read-truncate-race.patch
make-sure-readv-stops-reading-when-it-hits-end-of-file.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
nfsd-warning-fix.patch
use-menuconfig-objects-ii-md.patch
md-improve-message-about-invalid-superblock-during-autodetect.patch
md-improve-the-is_mddev_idle-test-fix.patch
md-check-that-internal-bitmap-does-not-overlap-other-data.patch
md-change-bitmap_unplug-and-others-to-void-functions.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
