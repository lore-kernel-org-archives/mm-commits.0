From: akpm@linux-foundation.org
Subject: + writeback-use-rb_entry.patch added to -mm tree
Date: Fri, 13 Jan 2017 15:01:41 -0800
Message-ID: <58795c55.mGrV0l5xjNLgRJxp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48938 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdAMXBm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 18:01:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, axboe@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/backing-dev.c: use rb_entry()
has been added to the -mm tree.  Its filename is
     writeback-use-rb_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-use-rb_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-use-rb_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: mm/backing-dev.c: use rb_entry()

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Link: http://lkml.kernel.org/r/671275de093d93ddc7c6f77ddc0d357149691a39.1484306840.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/backing-dev.c~writeback-use-rb_entry mm/backing-dev.c
--- a/mm/backing-dev.c~writeback-use-rb_entry
+++ a/mm/backing-dev.c
@@ -410,8 +410,8 @@ retry:
 
 	while (*node != NULL) {
 		parent = *node;
-		congested = container_of(parent, struct bdi_writeback_congested,
-					 rb_node);
+		congested = rb_entry(parent, struct bdi_writeback_congested,
+				     rb_node);
 		if (congested->blkcg_id < blkcg_id)
 			node = &parent->rb_left;
 		else if (congested->blkcg_id > blkcg_id)
_

Patches currently in -mm which might be from geliangtang@gmail.com are

mm-vmallocc-use-rb_entry_safe.patch
writeback-use-rb_entry.patch
proc-use-rb_entry.patch
timerqueue-use-rb_entry_safe.patch

