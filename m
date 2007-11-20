From: akpm@linux-foundation.org
Subject: - nr_open-should-be-raised-a-litle-bit.patch removed from -mm tree
Date: Mon, 19 Nov 2007 17:08:34 -0800
Message-ID: <200711200108.lAK18ZCV005884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbXKTBJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 20:09:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Increase NR_OPEN
has been removed from the -mm tree.  Its filename was
     nr_open-should-be-raised-a-litle-bit.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Increase NR_OPEN
From: Eric Dumazet <dada1@cosmosbay.com>

Time has come to change NR_OPEN value, some production servers hit the not
so 'ridiculously high value' of 1024*1024 file descriptors per process.

This is safe to raise this value, because alloc_fd_array() uses vmalloc()
for large arrays and vmalloc() returns NULL if a too large allocation is
attempted (or in case of memory shortage)

Moore law implies this limit should be changed every 1-2 years, and it
seems we forgot doing this for ages.

Even on my old notebook, a process can open 1000000 descriptors without any
problem.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~nr_open-should-be-raised-a-litle-bit include/linux/fs.h
--- a/include/linux/fs.h~nr_open-should-be-raised-a-litle-bit
+++ a/include/linux/fs.h
@@ -21,7 +21,7 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-#define NR_OPEN (1024*1024)	/* Absolute upper limit on fd num */
+#define NR_OPEN (16*1024*1024)	/* Absolute upper limit on fd num */
 #define INR_OPEN 1024		/* Initial setting for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

git-net.patch
nr_open-should-be-raised-a-litle-bit.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
