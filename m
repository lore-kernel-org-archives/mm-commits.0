Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C8DC4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB7FF20936
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085486;
	bh=0vAaC6daGFXVyykJySwypyMT0S6G/u6MkRNpMWpoozA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iHu5pr/H7txpHKpU1i127NweLrn2w5lCVzJ6TH7PLOAAec8JoQAvd/2n0vo2lB5d0
	 IcA0R+0u2eMgd7Xv9CXWA0mUXeHulGFIuTlHhOgRvnufEQmsd1JA+oZKtCMoJ9XnX1
	 /+vIkD+kZPc801U/gltV6ln2cBp6nr4x+2hRoPns=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgIZB6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95814207EA;
        Sat, 26 Sep 2020 01:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085485;
        bh=0vAaC6daGFXVyykJySwypyMT0S6G/u6MkRNpMWpoozA=;
        h=Date:From:To:Subject:From;
        b=ErUpjchjNrDJOmfQx63zZeb5UUZozlBbQlqmM4qaA4e2M6IfZyv6d5cq82FUj4xAh
         ylmpJg3Xuwaizz2r5FqZas4HeExHjRVo9Znml9azeQgbm/UOCEFyYKFyNHIa5Tlsya
         VorxDaAvOJsi3+rti8R20RNBkvUhDtNdhanV0Dyo=
Date:   Fri, 25 Sep 2020 18:58:05 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, gandalf@winds.org, hughd@google.com,
        mm-commits@vger.kernel.org
Subject:  [merged] tmpfs-restore-functionality-of-nr_inodes=0.patch
 removed from -mm tree
Message-ID: <20200926015805.zRx0dUaOe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: restore functionality of nr_inodes=0
has been removed from the -mm tree.  Its filename was
     tmpfs-restore-functionality-of-nr_inodes=0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Byron Stanoszek <gandalf@winds.org>
Subject: tmpfs: restore functionality of nr_inodes=0

Commit e809d5f0b5c9 ("tmpfs: per-superblock i_ino support") made changes
to shmem_reserve_inode() in mm/shmem.c, however the original test for
(sbinfo->max_inodes) got dropped.  This causes mounting tmpfs with option
nr_inodes=0 to fail:

  # mount -ttmpfs -onr_inodes=0 none /ext0
  mount: /ext0: mount(2) system call failed: Cannot allocate memory.

This patch restores the nr_inodes=0 functionality.

Link: https://lkml.kernel.org/r/20200902035715.16414-1-gandalf@winds.org
Fixes: e809d5f0b5c9 ("tmpfs: per-superblock i_ino support")
Signed-off-by: Byron Stanoszek <gandalf@winds.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Chris Down <chris@chrisdown.name>	
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~tmpfs-restore-functionality-of-nr_inodes=0
+++ a/mm/shmem.c
@@ -279,11 +279,13 @@ static int shmem_reserve_inode(struct su
 
 	if (!(sb->s_flags & SB_KERNMOUNT)) {
 		spin_lock(&sbinfo->stat_lock);
-		if (!sbinfo->free_inodes) {
-			spin_unlock(&sbinfo->stat_lock);
-			return -ENOSPC;
+		if (sbinfo->max_inodes) {
+			if (!sbinfo->free_inodes) {
+				spin_unlock(&sbinfo->stat_lock);
+				return -ENOSPC;
+			}
+			sbinfo->free_inodes--;
 		}
-		sbinfo->free_inodes--;
 		if (inop) {
 			ino = sbinfo->next_ino++;
 			if (unlikely(is_zero_ino(ino)))
_

Patches currently in -mm which might be from gandalf@winds.org are


