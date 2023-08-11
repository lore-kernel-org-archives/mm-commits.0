Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E449C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbjHKW6f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjHKW6b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC4E2684
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5AE665BD7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F11C433C7;
        Fri, 11 Aug 2023 22:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794710;
        bh=gtt/2olVeU/mkalPVMqVXfWcRclEXb7D5qbuXfdR9CE=;
        h=Date:To:From:Subject:From;
        b=sICgVlsswSzUdORs68ehZaZ6VgJnhgXfzc5iB8vNa2w2rKNoF0rgC6YSd64eC98Ip
         jh2xMVf423uST13XevVFbm0jwhN1FiuhjbXv499PP/mXvmNbt/twc4X5OuTpy3EgOS
         URjm59as7Ryr0om86TOKWTPt2HlgtxZel6kOpY1M=
Date:   Fri, 11 Aug 2023 15:58:29 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-stop-add-to-avail-list-is-swap-is-full.patch removed from -mm tree
Message-Id: <20230811225830.46F11C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: stop add to avail list if swap is full
has been removed from the -mm tree.  Its filename was
     swap-stop-add-to-avail-list-is-swap-is-full.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: swap: stop add to avail list if swap is full
Date: Tue, 27 Jun 2023 20:08:33 +0800

Our test finds a WARN_ON in add_to_avail_list.  During add_to_avail_list,
avail_lists is already in swap_avail_heads, while leads to this WARN_ON.

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

During swapoff, try_to_unuse fails to alloc memory due to memory limit and
this leads to the failure of swapoff and causes re-insertion of swap space
back into swap_list.  During _enable_swap_info, this swap device is added
to avail list even this swap device if full.  At the same time, one entry
in this full swap device in released and we try to add this device into
avail list and find it is already in the avail list.  This causes this
WARN_ON.

To fix this.  Don't add to avail list is swap is full.

[akpm@linux-foundation.org: coding-style cleanups]
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
+	/* add to available list iff swap device is not full */
+	if (p->highest_bit)
+		add_to_avail_list(p);
 }
 
 static void enable_swap_info(struct swap_info_struct *p, int prio,
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-disable-kernelcore=mirror-when-no-mirror-memory.patch

