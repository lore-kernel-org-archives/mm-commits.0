From: akpm@linux-foundation.org
Subject: + romfs-advance-destination-buffer-pointer-when-reading-from-a-blockdev.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:53:39 -0700
Message-ID: <200904232353.n3NNrd1A000478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126AbZDWX4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, dwmw2@infradead.org, monstr@monstr.eu


The patch titled
     romfs: advance destination buffer pointer when reading from a blockdev
has been added to the -mm tree.  Its filename is
     romfs-advance-destination-buffer-pointer-when-reading-from-a-blockdev.patch

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

slow-work-delete-timers-properly.patch
mn10300-update-the-asb2303-defconfig.patch
cachefiles-fix-the-documentation-to-use-the-correct-credential-pointer-names.patch
romfs-romfs_lookup-shouldnt-be-doing-a-partial-name-comparison.patch
romfs-advance-destination-buffer-pointer-when-reading-from-a-blockdev.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
mutex-subsystem-synchro-test-module.patch

