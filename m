From: akpm@linux-foundation.org
Subject: + fs-seqfile-always-allow-oom-killer.patch added to -mm tree
Date: Mon, 28 Sep 2015 15:33:15 -0700
Message-ID: <5609c02b.ixOUC4CuHyOvNv1x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbbI1WdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 18:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, edumazet@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, seqfile: always allow oom killer
has been added to the -mm tree.  Its filename is
     fs-seqfile-always-allow-oom-killer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-seqfile-always-allow-oom-killer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-seqfile-always-allow-oom-killer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: fs, seqfile: always allow oom killer

Since 5cec38ac866b ("fs, seq_file: fallback to vmalloc instead of oom kill
processes") seq_buf_alloc() avoids calling the oom killer for PAGE_SIZE or
smaller allocations; but larger allocations can use the oom killer via
vmalloc().  Thus reads of small files can return ENOMEM, but larger files
use the oom killer to avoid ENOMEM.

Memory overcommit requires use of the oom killer to select a victim
regardless of file size.

Enable oom killer for small seq_buf_alloc() allocations.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
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

memcg-fix-dirty-page-migration.patch
memcg-make-mem_cgroup_read_stat-unsigned.patch
memcg-remove-pcp_counter_lock.patch
fs-seqfile-always-allow-oom-killer.patch

