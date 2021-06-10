Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB92C48BDF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1BC6613F5
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhFJWya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhFJWy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 18:54:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FD8613E7;
        Thu, 10 Jun 2021 22:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623365552;
        bh=jzgZOsqHz4Rm3A8TXXp/xs6Xp9gaN/C/b9hieNXM1Gg=;
        h=Date:From:To:Subject:From;
        b=0rlgYM+NvT1sPyEBYRvv2hOOiY+yTxQV/k4oUgVCwYOMNlZ69izZsd7oOCSeNQlJr
         LrjZ4/v7f6tjnTWzjtoKUpR5lAAzUlj24wQ8nH2WWOVLXnZcJWCLLPSnXMhXb2o6Rc
         XwKtJBrgdNw75qoKBEQHH0V+o4IiOMEjhLPiE+yY=
Date:   Thu, 10 Jun 2021 15:52:32 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, ming.lei@redhat.com, mm-commits@vger.kernel.org
Subject:  +
 writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch
 added to -mm tree
Message-ID: <20210610225232.5tnYob34x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup, writeback: add smp_mb() to inode_prepare_wbs_switch()
has been added to the -mm tree.  Its filename is
     writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch

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
Subject: cgroup, writeback: add smp_mb() to inode_prepare_wbs_switch()

Add a memory barrier between incrementing isw_nr_in_flight and checking
the sb's SB_ACTIVE flag and grabbing an inode in
inode_prepare_wbs_switch().  It's required to prevent grabbing an inode
before incrementing isw_nr_in_flight, otherwise 0 can be obtained as
isw_nr_in_flight in cgroup_writeback_umount() and isw_wq will not be
flushed, potentially leading to a memory corruption.

Added smp_mb() will work in pair with smp_mb() in
cgroup_writeback_umount().

Link: https://lkml.kernel.org/r/YMFa+guFw7OFjf3X@carbon.dhcp.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/fs-writeback.c~writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix
+++ a/fs/fs-writeback.c
@@ -512,6 +512,14 @@ static void inode_switch_wbs_work_fn(str
 static bool inode_prepare_wbs_switch(struct inode *inode,
 				     struct bdi_writeback *new_wb)
 {
+	/*
+	 * Paired with smp_mb() in cgroup_writeback_umount().
+	 * isw_nr_in_flight must be increased before checking SB_ACTIVE and
+	 * grabbing an inode, otherwise isw_nr_in_flight can be observed as 0
+	 * in cgroup_writeback_umount() and the isw_wq will be not flushed.
+	 */
+	smp_mb();
+
 	/* while holding I_WB_SWITCH, no one else can update the association */
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
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
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch

