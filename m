Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9460BC4338F
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 04:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CE3E60F22
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 04:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhHKEdF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Aug 2021 00:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233565AbhHKEdE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Aug 2021 00:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A686D60E78;
        Wed, 11 Aug 2021 04:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628656361;
        bh=cc1jZmFuMwTXovREVl/f5DLmIIdTBHupGwNtRjDkT4k=;
        h=Date:From:To:Subject:From;
        b=EaBUILGdqVCOQOGrmOO/aac+PZmPpiLDml7ed8Ou9/eYzqloG2lKSwUm6r0MFeeci
         esWUFCql3qEUz1HH4iXuixvs4tRQoQDNIBhqZjZAds5kbtkv7DfZj6XAGfGGKOXqC3
         5OYxy5xCkQ+skaYRQ4dGrUEXacL8iS6MjfWL4M4c=
Date:   Tue, 10 Aug 2021 21:32:41 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, manfred@colorfullife.com,
        llong@redhat.com, dbueso@suse.de, aquini@redhat.com
Subject:  +
 ipc-replace-costly-bailout-check-in-sysvipc_find_ipc.patch added to -mm tree
Message-ID: <20210811043241.SD44R%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: replace costly bailout check in sysvipc_find_ipc()
has been added to the -mm tree.  Its filename is
     ipc-replace-costly-bailout-check-in-sysvipc_find_ipc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-replace-costly-bailout-check-in-sysvipc_find_ipc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-replace-costly-bailout-check-in-sysvipc_find_ipc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: ipc: replace costly bailout check in sysvipc_find_ipc()

sysvipc_find_ipc() was left with a costly way to check if the offset
position fed to it is bigger than the total number of IPC IDs in use.  So
much so that the time it takes to iterate over /proc/sysvipc/* files grows
exponentially for a custom benchmark that creates "N" SYSV shm segments
and then times the read of /proc/sysvipc/shm (milliseconds):

    12 msecs to read   1024 segs from /proc/sysvipc/shm
    18 msecs to read   2048 segs from /proc/sysvipc/shm
    65 msecs to read   4096 segs from /proc/sysvipc/shm
   325 msecs to read   8192 segs from /proc/sysvipc/shm
  1303 msecs to read  16384 segs from /proc/sysvipc/shm
  5182 msecs to read  32768 segs from /proc/sysvipc/shm

The root problem lies with the loop that computes the total amount of ids
in use to check if the "pos" feeded to sysvipc_find_ipc() grew bigger than
"ids->in_use".  That is a quite inneficient way to get to the maximum
index in the id lookup table, specially when that value is already
provided by struct ipc_ids.max_idx.

This patch follows up on the optimization introduced via commit
15df03c879836 ("sysvipc: make get_maxid O(1) again") and gets rid of the
aforementioned costly loop replacing it by a simpler checkpoint based on
ipc_get_maxidx() returned value, which allows for a smooth linear increase
in time complexity for the same custom benchmark:

     2 msecs to read   1024 segs from /proc/sysvipc/shm
     2 msecs to read   2048 segs from /proc/sysvipc/shm
     4 msecs to read   4096 segs from /proc/sysvipc/shm
     9 msecs to read   8192 segs from /proc/sysvipc/shm
    19 msecs to read  16384 segs from /proc/sysvipc/shm
    39 msecs to read  32768 segs from /proc/sysvipc/shm

Link: https://lkml.kernel.org/r/20210809203554.1562989-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Waiman Long <llong@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/ipc/util.c~ipc-replace-costly-bailout-check-in-sysvipc_find_ipc
+++ a/ipc/util.c
@@ -788,21 +788,13 @@ struct pid_namespace *ipc_seq_pid_ns(str
 static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
 					      loff_t *new_pos)
 {
-	struct kern_ipc_perm *ipc;
-	int total, id;
+	struct kern_ipc_perm *ipc = NULL;
+	int max_idx = ipc_get_maxidx(ids);
 
-	total = 0;
-	for (id = 0; id < pos && total < ids->in_use; id++) {
-		ipc = idr_find(&ids->ipcs_idr, id);
-		if (ipc != NULL)
-			total++;
-	}
-
-	ipc = NULL;
-	if (total >= ids->in_use)
+	if (max_idx == -1 || pos > max_idx)
 		goto out;
 
-	for (; pos < ipc_mni; pos++) {
+	for (; pos <= max_idx; pos++) {
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			rcu_read_lock();
_

Patches currently in -mm which might be from aquini@redhat.com are

ipc-replace-costly-bailout-check-in-sysvipc_find_ipc.patch

