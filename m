From: akpm@linux-foundation.org
Subject: [merged] romfs-advance-destination-buffer-pointer-when-reading-from-a-blockdev.patch removed from -mm tree
Date: Mon, 27 Apr 2009 11:17:38 -0700
Message-ID: <200904271817.n3RIHcID009893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756377AbZD0SUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Apr 2009 14:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dwmw2@infradead.org, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     romfs: advance destination buffer pointer when reading from a blockdev
has been removed from the -mm tree.  Its filename was
     romfs-advance-destination-buffer-pointer-when-reading-from-a-blockdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: romfs: advance destination buffer pointer when reading from a blockdev
From: David Howells <dhowells@redhat.com>

RomFS should advance the destination buffer pointer when reading data from
a blockdev source (the data may be split over multiple blocks, each
requiring its own sb_read() call).  Without this, all the data is copied
to the beginning of the output buffer.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Michal Simek <monstr@monstr.eu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/storage.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/romfs/storage.c~romfs-advance-destination-buffer-pointer-when-reading-from-a-blockdev fs/romfs/storage.c
--- a/fs/romfs/storage.c~romfs-advance-destination-buffer-pointer-when-reading-from-a-blockdev
+++ a/fs/romfs/storage.c
@@ -120,6 +120,7 @@ static int romfs_blk_read(struct super_b
 			return -EIO;
 		memcpy(buf, bh->b_data + offset, segment);
 		brelse(bh);
+		buf += segment;
 		buflen -= segment;
 		pos += segment;
 	}
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
mutex-subsystem-synchro-test-module.patch

