Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60EA0EB64D9
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jun 2023 19:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjF0T2c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF0T2b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2023 15:28:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F273619A9
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 12:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731FC611FB
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 19:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD95CC433C0;
        Tue, 27 Jun 2023 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687894108;
        bh=N4jVh9IgKSK+LbPwLzHlx0aNI1dparGVrS5JgvOe15c=;
        h=Date:To:From:Subject:From;
        b=J4/3YR2ph0oQDbqPGG7iXxeS3lHEifyCVyXUlgGUSn2Z8SMBiBlq0C2ghBzfHR5xv
         ksx7iVcHozeaeYbSsg/xoC3Frp9z3S6rGVwxOD7NOarIjb9ygPfiTVraVfvfF7mRjg
         Z2wMcK0uapghWaY9x3hSC7Nx34wD5rL2y5eb9gyc=
Date:   Tue, 27 Jun 2023 12:28:27 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch added to mm-unstable branch
Message-Id: <20230627192828.BD95CC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: cleanup duplicated WARN_ON in add_to_avail_list
has been added to the -mm mm-unstable branch.  Its filename is
     swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: swap: cleanup duplicated WARN_ON in add_to_avail_list
Date: Tue, 27 Jun 2023 20:08:32 +0800

Patch series "fix WARN_ON in add_to_avail_list".


Empty check for plist_node is checked in add_to_avail_list and plist_add. 
Drop the duplicate one in add_to_avail_list.

Link: https://lkml.kernel.org/r/20230627120833.2230766-1-mawupeng1@huawei.com
Link: https://lkml.kernel.org/r/20230627120833.2230766-2-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c~swap-cleanup-duplicated-warn_on-in-add_to_avail_list
+++ a/mm/swapfile.c
@@ -714,10 +714,8 @@ static void add_to_avail_list(struct swa
 	int nid;
 
 	spin_lock(&swap_avail_lock);
-	for_each_node(nid) {
-		WARN_ON(!plist_node_empty(&p->avail_lists[nid]));
+	for_each_node(nid)
 		plist_add(&p->avail_lists[nid], &swap_avail_heads[nid]);
-	}
 	spin_unlock(&swap_avail_lock);
 }
 
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch
swap-stop-add-to-avail-list-is-swap-is-full.patch

