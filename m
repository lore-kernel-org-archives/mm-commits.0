From: akpm@linux-foundation.org
Subject: [patch 23/51] mm: have filemap_check_and_advance_wb_err clear
 AS_EIO/AS_ENOSPC
Date: Tue, 03 Oct 2017 16:15:25 -0700
Message-ID: <59d41a0d.9MR8pre4bAnBFESa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXP1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jlayton@redhat.com, eguan@redhat.com, jack@suse.cz

From: Jeff Layton <jlayton@redhat.com>
Subject: mm: have filemap_check_and_advance_wb_err clear AS_EIO/AS_ENOSPC

Eryu noticed that he could sometimes get a leftover error reported when it
shouldn't be on fsync with ext2 and non-journalled ext4.  The problem is
that writeback_single_inode still uses filemap_fdatawait.  That picks up a
previously set AS_EIO flag, which would ordinarily have been cleared
before.

Since we're mostly using this function as a replacement for
filemap_check_errors, have filemap_check_and_advance_wb_err clear AS_EIO
and AS_ENOSPC when reporting an error.  That should allow the new function
to better emulate the behavior of the old with respect to these flags.

Link: http://lkml.kernel.org/r/20170922133331.28812-1-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reported-by: Eryu Guan <eguan@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/filemap.c~mm-have-filemap_check_and_advance_wb_err-clear-as_eio-as_enospc mm/filemap.c
--- a/mm/filemap.c~mm-have-filemap_check_and_advance_wb_err-clear-as_eio-as_enospc
+++ a/mm/filemap.c
@@ -620,6 +620,14 @@ int file_check_and_advance_wb_err(struct
 		trace_file_check_and_advance_wb_err(file, old);
 		spin_unlock(&file->f_lock);
 	}
+
+	/*
+	 * We're mostly using this function as a drop in replacement for
+	 * filemap_check_errors. Clear AS_EIO/AS_ENOSPC to emulate the effect
+	 * that the legacy code would have had on these flags.
+	 */
+	clear_bit(AS_EIO, &mapping->flags);
+	clear_bit(AS_ENOSPC, &mapping->flags);
 	return err;
 }
 EXPORT_SYMBOL(file_check_and_advance_wb_err);
_
