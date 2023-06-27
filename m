Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F16EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jun 2023 19:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjF0T2g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF0T2d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2023 15:28:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFCF19A9
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 12:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 621D161187
        for <mm-commits@vger.kernel.org>; Tue, 27 Jun 2023 19:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A14C433C0;
        Tue, 27 Jun 2023 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687894111;
        bh=rk+eYfQ73QBoIM3jZtF9dT7LjC/1oD0DK35O3vtMC0Q=;
        h=Date:To:From:Subject:From;
        b=kXRV2DQNsGUJ04zmXKspzOH661psXWOHxFWb6g40myAXRWeE8Vj+TaWuFvKjkvNre
         cZFonhutnoB19gjaag+Qy1oe2mJRRnzMKmzAjpzqhL/VsGwOcaMxir8H9Ut8Ii5vib
         JEUuWznQMqNy709KwxuhiIG6+m4Ont2P5n2NAEtE=
Date:   Tue, 27 Jun 2023 12:28:30 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-stop-add-to-avail-list-is-swap-is-full.patch added to mm-unstable branch
Message-Id: <20230627192831.B3A14C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: stop add to avail list is swap is full
has been added to the -mm mm-unstable branch.  Its filename is
     swap-stop-add-to-avail-list-is-swap-is-full.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/swap-stop-add-to-avail-list-is-swap-is-full.patch

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
Subject: swap: stop add to avail list is swap is full
Date: Tue, 27 Jun 2023 20:08:33 +0800

Our test finds a WARN_ON in add_to_avail_list.  During add_to_avail_list,
avail_lists is already in swap_avail_heads, while lead to this WARN_ON.

Here is the simplified calltrace:

------------[ cut here ]------------
Call trace:
 add_to_avail_list+0xb8/0xc0
 swap_range_free+0x110/0x138
 swapcache_free_entries+0x100/0x1c0
 free_swap_slot+0xbc/0xe0
 put_swap_folio+0x1f0/0x2ec
 delete_from_swap_cache+0x6c/0xd0
 folio_free_swap+0xa4/0xe4
 __try_to_reclaim_swap+0x9c/0x190
 free_swap_and_cache+0x84/0x88
 unmap_page_range+0x31c/0x934
 unmap_single_vma.isra.0+0x48/0x84
 unmap_vmas+0x98/0x10c
 exit_mmap+0xa4/0x210
 mmput+0x88/0x158
 do_exit+0x284/0x970
 do_group_exit+0x34/0x90
 post_copy_siginfo_from_user32+0x0/0x1cc
 do_notify_resume+0x15c/0x470
 el0_svc+0x74/0x84
 el0t_64_sync_handler+0xb8/0xbc
 el0t_64_sync+0x190/0x194

During swapoff, try_to_unuse fail to alloc memory due to memory limit and
this leads to the failure of swapoff and causes re-insert swap space back
into swap_list.  During _enable_swap_info, this swap device is added to
avail list even this swap device if full.  At the same time, one entry in
this full swap device in released and try to add this device into avail
list and found it is already in the avail list.  This cause this WARN_ON.

To fix this. Stop add to avail list is swap is full.

Link: https://lkml.kernel.org/r/20230627120833.2230766-3-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~swap-stop-add-to-avail-list-is-swap-is-full
+++ a/mm/swapfile.c
@@ -2328,7 +2328,10 @@ static void _enable_swap_info(struct swa
 	 * swap_info_struct.
 	 */
 	plist_add(&p->list, &swap_active_head);
-	add_to_avail_list(p);
+
+	/* add to avaliable list iff swap device is not full */
+	if (p->highest_bit)
+		add_to_avail_list(p);
 }
 
 static void enable_swap_info(struct swap_info_struct *p, int prio,
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch
swap-stop-add-to-avail-list-is-swap-is-full.patch

