From: akpm@linux-foundation.org
Subject: [to-be-updated] fcntlf_setfl-allow-setting-of-o_sync.patch removed from -mm tree
Date: Sat, 29 Oct 2011 04:11:12 -0700
Message-ID: <201110291107.p9TB7aPY012059@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:14936 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab1J2LHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 29 Oct 2011 07:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sar@nec-labs.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fcntl(F_SETFL): allow setting of O_SYNC
has been removed from the -mm tree.  Its filename was
     fcntlf_setfl-allow-setting-of-o_sync.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Steve Rago <sar@nec-labs.com>
Subject: fcntl(F_SETFL): allow setting of O_SYNC

This has probably been a problem since day 1 (I ran into this running the
2.4 kernel years ago; finally got around to fixing it).  The problem is
that fcntl(fd, F_SETFL, flags|O_SYNC) appears to work, but silently
ignores the O_SYNC flag.  Opening the file with O_SYNC works okay, but
setting it later on via fcntl doesn't work.

akpm: will cause surprise slowdowns of applications such as
http://koders.com/c/fidA34D8D5EE9AA5D0AB0F3C604678E2E935E5B0246.aspx?s=dupa

akpm: maybe we should sync the file when someone sets O_SYNC.

Signed-off-by: Steve Rago <sar@nec-labs.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fcntl.c~fcntlf_setfl-allow-setting-of-o_sync fs/fcntl.c
--- a/fs/fcntl.c~fcntlf_setfl-allow-setting-of-o_sync
+++ a/fs/fcntl.c
@@ -143,7 +143,7 @@ SYSCALL_DEFINE1(dup, unsigned int, filde
 	return ret;
 }
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME | O_SYNC)
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
_

Patches currently in -mm which might be from sar@nec-labs.com are


