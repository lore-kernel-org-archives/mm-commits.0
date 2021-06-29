Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05BEC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D70E61CD8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhF2AU5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhF2AU4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A74161CF1;
        Tue, 29 Jun 2021 00:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624925909;
        bh=hvVMlkILcbGaGHkVDJQv5DrI4v/MnIjU8VnE0w3bKas=;
        h=Date:From:To:Subject:From;
        b=WBVlLwH/f+JDeJAULwxOY43pvpev/LncY7IG3QUARQQ2L1GfPerfCZN1b/sIAphAU
         Mu//fLF/5GXjLD8OqdtcKR9R9nCV7PBN/iJbOp+Nurs5KLtl0VW9wiNwgVPU8SbpHo
         vZO8CO8lrlAZ2lkHCREjN2wLNfwbDLrWZFEv0ZPk=
Date:   Mon, 28 Jun 2021 17:18:29 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, ming.lei@redhat.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch
 removed from -mm tree
Message-ID: <20210629001829.wUaRj_2tX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup, writeback: add smp_mb() to inode_prepare_wbs_switch()
has been removed from the -mm tree.  Its filename was
     writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch

This patch was dropped because it was folded into writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes.patch

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
@@ -513,6 +513,14 @@ static void inode_switch_wbs_work_fn(str
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

