From: akpm@linux-foundation.org
Subject: + relay-check-array-offset-before-using-it.patch added to -mm
 tree
Date: Wed, 19 Oct 2016 16:28:30 -0700
Message-ID: <5808019e.+wv4w4nvjRL/ZcNT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753630AbcJSX2c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 19:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: relay: check array offset before using it
has been added to the -mm tree.  Its filename is
     relay-check-array-offset-before-using-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/relay-check-array-offset-before-using-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/relay-check-array-offset-before-using-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: relay: check array offset before using it

Smatch complains that we started using the array offset before we
checked that it was valid.

Fixes: 017c59c042d0 ('relay: Use per CPU constructs for the relay channel buffer pointers')
Link: http://lkml.kernel.org/r/20161013084947.GC16198@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/relay.c~relay-check-array-offset-before-using-it kernel/relay.c
--- a/kernel/relay.c~relay-check-array-offset-before-using-it
+++ a/kernel/relay.c
@@ -809,11 +809,11 @@ void relay_subbufs_consumed(struct rchan
 {
 	struct rchan_buf *buf;
 
-	if (!chan)
+	if (!chan || cpu >= NR_CPUS)
 		return;
 
 	buf = *per_cpu_ptr(chan->buf, cpu);
-	if (cpu >= NR_CPUS || !buf || subbufs_consumed > chan->n_subbufs)
+	if (!buf || subbufs_consumed > chan->n_subbufs)
 		return;
 
 	if (subbufs_consumed > buf->subbufs_produced - buf->subbufs_consumed)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

relay-check-array-offset-before-using-it.patch

