From: akpm@linux-foundation.org
Subject: + kernel-relay-limit-kmalloc-size-to-kmalloc_max_size.patch added to -mm tree
Date: Tue, 06 Feb 2018 12:24:24 -0800
Message-ID: <5a7a0ef8.iSczV1iD9tYhhZ2M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbeBFUYZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 15:24:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, akpm@linux-foundation.org, axboe@kernel.dk, dan.carpenter@oracle.com, dave.jiang@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: limit kmalloc size to KMALLOC_MAX_SIZE
has been added to the -mm tree.  Its filename is
     kernel-relay-limit-kmalloc-size-to-kmalloc_max_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-relay-limit-kmalloc-size-to-kmalloc_max_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-relay-limit-kmalloc-size-to-kmalloc_max_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: kernel/relay.c: limit kmalloc size to KMALLOC_MAX_SIZE

chan->n_subbufs is set by the user and relay_create_buf() does a kmalloc()
of chan->n_subbufs * sizeof(size_t *).

kmalloc_slab() will generate a warning when this fails if
chan->subbufs * sizeof(size_t *) > KMALLOC_MAX_SIZE.

Limit chan->n_subbufs to the maximum allowed kmalloc() size.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1802061216100.122576@chino.kir.corp.google.com
Fixes: f6302f1bcd75 ("relay: prevent integer overflow in relay_open()")
Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/relay.c~kernel-relay-limit-kmalloc-size-to-kmalloc_max_size kernel/relay.c
--- a/kernel/relay.c~kernel-relay-limit-kmalloc-size-to-kmalloc_max_size
+++ a/kernel/relay.c
@@ -163,7 +163,7 @@ static struct rchan_buf *relay_create_bu
 {
 	struct rchan_buf *buf;
 
-	if (chan->n_subbufs > UINT_MAX / sizeof(size_t *))
+	if (chan->n_subbufs > KMALLOC_MAX_SIZE / sizeof(size_t *))
 		return NULL;
 
 	buf = kzalloc(sizeof(struct rchan_buf), GFP_KERNEL);
_

Patches currently in -mm which might be from rientjes@google.com are

kernel-relay-limit-kmalloc-size-to-kmalloc_max_size.patch

