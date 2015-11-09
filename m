From: akpm@linux-foundation.org
Subject: [merged] fs-seqfile-always-allow-oom-killer.patch removed from
 -mm tree
Date: Mon, 09 Nov 2015 12:13:40 -0800
Message-ID: <5640fe74.pg+MSanEshbR1P3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbbKIUNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, edumazet@google.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, seqfile: always allow oom killer
has been removed from the -mm tree.  Its filename was
     fs-seqfile-always-allow-oom-killer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: fs, seqfile: always allow oom killer

Since 5cec38ac866b ("fs, seq_file: fallback to vmalloc instead of oom kill
processes") seq_buf_alloc() avoids calling the oom killer for PAGE_SIZE or
smaller allocations; but larger allocations can use the oom killer via
vmalloc().  Thus reads of small files can return ENOMEM, but larger files
use the oom killer to avoid ENOMEM.

The effect of this bug is that reads from /proc and other virtual
filesystems can return ENOMEM instead of the preferred behavior - oom
killing something (possibly the calling process).  I don't know of anyone
except Google who has noticed the issue.

I suspect the fix is more needed in smaller systems where there isn't any
reclaimable memory.  But these seem like the kinds of systems which
probably don't use the oom killer for production situations.

Memory overcommit requires use of the oom killer to select a victim
regardless of file size.

Enable oom killer for small seq_buf_alloc() allocations.

Fixes: 5cec38ac866b ("fs, seq_file: fallback to vmalloc instead of oom kill processes")
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/seq_file.c~fs-seqfile-always-allow-oom-killer fs/seq_file.c
--- a/fs/seq_file.c~fs-seqfile-always-allow-oom-killer
+++ a/fs/seq_file.c
@@ -26,12 +26,17 @@ static void seq_set_overflow(struct seq_
 static void *seq_buf_alloc(unsigned long size)
 {
 	void *buf;
+	gfp_t gfp = GFP_KERNEL;
 
 	/*
-	 * __GFP_NORETRY to avoid oom-killings with high-order allocations -
-	 * it's better to fall back to vmalloc() than to kill things.
+	 * For high order allocations, use __GFP_NORETRY to avoid oom-killing -
+	 * it's better to fall back to vmalloc() than to kill things.  For small
+	 * allocations, just use GFP_KERNEL which will oom kill, thus no need
+	 * for vmalloc fallback.
 	 */
-	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
+	if (size > PAGE_SIZE)
+		gfp |= __GFP_NORETRY | __GFP_NOWARN;
+	buf = kmalloc(size, gfp);
 	if (!buf && size > PAGE_SIZE)
 		buf = vmalloc(size);
 	return buf;
_

Patches currently in -mm which might be from gthelen@google.com are


