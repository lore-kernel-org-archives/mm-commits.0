Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB30CC4743F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9774761375
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhFIAPK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhFIAPJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:15:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C996A61352;
        Wed,  9 Jun 2021 00:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623197584;
        bh=nRgZSQt9UphPpVZgdFKHHAgjaS+uP1ORWfyrycIvrzw=;
        h=Date:From:To:Subject:From;
        b=iCJZFn6DCoxqEBkFvxBoFEJJWAYIkLCfEoxo9Pg/f2mDmB7RFjawXW42oWWJmYdXU
         magUu7lwiAb7bR4cEHHeIWhRNb8CriVLErD3tcz7vr43FRsaFcuL3q913C64yUYcdm
         vZQo+MSKOYiqWhHblnPqlrWzFLJUyUeV4l9TYLk4=
Date:   Tue, 08 Jun 2021 17:13:03 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dchinner@redhat.com, dennis@kernel.org,
        guro@fb.com, jack@suse.com, jack@suse.cz,
        mm-commits@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk
Subject:  +
 writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch added to -mm
 tree
Message-ID: <20210609001303.pXVktEZhn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: add smp_mb() to cgroup_writeback_umount()
has been added to the -mm tree.  Its filename is
     writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

writeback-cgroup-do-not-switch-inodes-with-i_will_free-flag.patch
writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch
writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode.patch
writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch
writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback.patch
writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn.patch
writeback-cgroup-support-switching-multiple-inodes-at-once.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes.patch

