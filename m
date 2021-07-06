Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E31BC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A5CA6023F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhGFTMb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhGFTM3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97EB361057;
        Tue,  6 Jul 2021 19:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598590;
        bh=bRLP47zafO49rR+QJ+KL2vqUPlI7pRz4X1LtgYoyTWg=;
        h=Date:From:To:Subject:From;
        b=r3FtxUOTCx3F5VXAkHYRcfNUpwvhql6Cg2ellVEPYMV7XObFXEgF5LJuYDpBIzey/
         aPUib4wr5X0QFPEg68S9JE8wZknpb36p9fnI+O0y+KmRFxFwkMu1kSqi8qHUazf+hM
         BBlwMMEi85660s8d3DTnVVR6WkpkulGwi2YbKv6o=
Date:   Tue, 06 Jul 2021 12:09:50 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dchinner@redhat.com, dennis@kernel.org,
        guro@fb.com, jack@suse.com, jack@suse.cz,
        mm-commits@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch removed from
 -mm tree
Message-ID: <20210706190950.3Mp0Lo8cd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: add smp_mb() to cgroup_writeback_umount()
has been removed from the -mm tree.  Its filename was
     writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: writeback, cgroup: add smp_mb() to cgroup_writeback_umount()

A full memory barrier is required between clearing SB_ACTIVE flag in
generic_shutdown_super() and checking isw_nr_in_flight in
cgroup_writeback_umount(), otherwise a new switch operation might be
scheduled after atomic_read(&isw_nr_in_flight) returned 0.  This would
result in a non-flushed isw_wq, and a potential crash.

The problem hasn't yet been seen in the real life and was discovered by
Jan Kara by looking into the code.

Link: https://lkml.kernel.org/r/20210608230225.2078447-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jan Kara <jack@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/fs-writeback.c~writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount
+++ a/fs/fs-writeback.c
@@ -1000,6 +1000,12 @@ out_bdi_put:
  */
 void cgroup_writeback_umount(void)
 {
+	/*
+	 * SB_ACTIVE should be reliably cleared before checking
+	 * isw_nr_in_flight, see generic_shutdown_super().
+	 */
+	smp_mb();
+
 	if (atomic_read(&isw_nr_in_flight)) {
 		/*
 		 * Use rcu_barrier() to wait for all pending callbacks to
_

Patches currently in -mm which might be from guro@fb.com are


