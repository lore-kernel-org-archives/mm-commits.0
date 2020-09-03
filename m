Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4EEC43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 027F4206CA
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599169226;
	bh=ggIivVj+uCGGceqSRo+/1sMdBa1ebmxp1xC81THXDR8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ri+eqox5oKC3VNqvhokGE3hFax4uXePZLCjQlIlMo39cOS/XF9AgNy952GVTQrcfL
	 slsN8qeJG3Wv806Q7SviO3FnryGE4fp5CmAYrt7xkUJuUUkqyXBAC+UroPiwH7F1vU
	 xk4OtCKvHgxe8f5DZa81jWousFO8jzz/m7LoB8YE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgICVkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgICVkZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:40:25 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D7D920665;
        Thu,  3 Sep 2020 21:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599169224;
        bh=ggIivVj+uCGGceqSRo+/1sMdBa1ebmxp1xC81THXDR8=;
        h=Date:From:To:Subject:From;
        b=RSt5xov5tUa3MzHgNqjcg7A5UEw2CxJyKCQ3NETl3KlW5xHAteZlhVZN0zxAFVg+H
         Bv1h72kGIdBT6oKL/BPw8fy4VKLzCimH7VUB5M0iobHwpah2vpoBmTK7rjalwuuh1O
         g1xYus54QUjFa83cbbyrWuqoky46kcMxxzLr5dmU=
Date:   Thu, 03 Sep 2020 14:40:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, hughd@google.com, chris@chrisdown.name,
        gandalf@winds.org
Subject:  + tmpfs-restore-functionality-of-nr_inodes=0.patch added to
 -mm tree
Message-ID: <20200903214024.GzypC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: restore functionality of nr_inodes=0
has been added to the -mm tree.  Its filename is
     tmpfs-restore-functionality-of-nr_inodes=0.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tmpfs-restore-functionality-of-nr_inodes%3D0.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-restore-functionality-of-nr_inodes%3D0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tmpfs-restore-functionality-of-nr_inodes=0.patch

