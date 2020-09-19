Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E32C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00922221EC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600489220;
	bh=Ied6UXpKS0iFDC4luEi/Lv6jAp7WaTwNcN566z1NQHw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OVWF5/XVkBiP92u8XA2BbFVna+Vx3xZTFB2yMh8akxf84vvt5DuAflyzmXkC04Nmu
	 dceu2RNQpoyH9iXBdV+0p+QTrybiDDi8IlVmaWr+TIVHTbq8sMCdNz2Te8wq9vAKyv
	 5iCY56JEV9D0TzM7TkjGU2OwOzqQNw5RjeQq5IWk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgISEUT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Sep 2020 00:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEUT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07C4521D43;
        Sat, 19 Sep 2020 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489219;
        bh=Ied6UXpKS0iFDC4luEi/Lv6jAp7WaTwNcN566z1NQHw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=S6ST7Kl1fgDGwPJTq/AZ0PeWkgJmDPi8LlD0HgfO6j43eCCi82affDAcUdb6N8aiJ
         MekGOKRLTlpEH6GvKiVcNcahtWTOZhTa3Exq3lsj7cXb5reVZK5kkAiJ+QcPsRppPY
         qBIXnnnmpFtvZVS79rqAr3KmeGs2U75aN3+ANuMU=
Date:   Fri, 18 Sep 2020 21:20:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, gandalf@winds.org,
        hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 07/15] tmpfs: restore functionality of nr_inodes=0
Message-ID: <20200919042018.EijFHCeuD%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
