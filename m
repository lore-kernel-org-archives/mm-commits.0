Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA20C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69A99208FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168834;
	bh=SeSBznVYtPLP5AETRB/Fw6Jx0XecNmrgDuVoCQRZkiY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sC4h1XAeomp+Oh8NJuQbUgMOJibWGizVo5CYzIVnIAZaaWUkifbag9XNcAvCQnvfb
	 lyhAEmXdY3r+TGd5WPVP4Xk85UaJU7DHgORHs1XJvy+8ZKcUaWODUNNCaAZcijuVhm
	 ZcaefVExjqOOtuE/uvVYED3fafoMHfcjh4sGN0Yk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgICVdy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgICVdx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:33:53 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA56C206D4;
        Thu,  3 Sep 2020 21:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168832;
        bh=SeSBznVYtPLP5AETRB/Fw6Jx0XecNmrgDuVoCQRZkiY=;
        h=Date:From:To:Subject:From;
        b=E6erqPKuTcOuITMUPbOqJ4h4fIIuHtCjaG+/eHxVW0Ce2tQcWGu2/F0fK8EkXwON0
         oPasxEGAUbLoSsXA8uYPXWY1osPWdLEBG+8K3WgOzsbyrx13vypMgZWk60A/PyB0HN
         ioY1YAWZLwjIFQTMVtM2mm8mjbdrzdG1dOurHsxE=
Date:   Thu, 03 Sep 2020 14:33:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        naoya.horiguchi@nec.com, mhocko@kernel.org, osalvador@suse.de
Subject:  + mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
 added to -mm tree
Message-ID: <20200903213351.yU7w_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: take free pages off the buddy freelists
has been added to the -mm tree.  Its filename is
     mmhwpoison-take-free-pages-off-the-buddy-freelists.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-take-free-pages-off-the-buddy-freelists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: take free pages off the buddy freelists

Patch series "HWpoison: further fixes and cleanups".

The important bit of this patchset is patch#1, which is a fix to take off
HWPoison pages off a buddy freelist since it can lead to us having HWPoison
pages back in the game and no one noticing it is handling a HWPoison page.
So fix it (we did that already for soft_offline_page [1]).

The other patches are clean-ups and not that important.


This patch (of 4):

The crux of the matter is that historically we left poisoned pages in the
buddy system because we have some checks in place when allocating a page
that a gatekeeper for poisoned pages.  Unfortunately, we do have other
users (e.g: compaction [1]) that scan buddy freelists and try to get a
page from there without checking whether the page is HWPoison.

As I stated already, I think it is fundamentally wrong to keep HWPoison
pages within the buddy systems, checks in place or not.

Let us fix this we same way we did for soft_offline [2], and take the page
off the buddy freelist, so it is completely unreachable.

Note that this is fairly simple to trigger, as we only need to poison free
buddy pages (madvise MADV_HWPOISON) and then we need to run some sort of
memory stress system.

Just for a matter of reference, I put a dump_page in compaction_alloc to
trigger for HWPoison patches:

kernel: page:0000000012b2982b refcount:1 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1d5db
kernel: flags: 0xfffffc0800000(hwpoison)
kernel: raw: 000fffffc0800000 ffffea00007573c8 ffffc90000857de0 0000000000000000
kernel: raw: 0000000000000001 0000000000000000 00000001ffffffff 0000000000000000
kernel: page dumped because: compaction_alloc

kernel: CPU: 4 PID: 123 Comm: kcompactd0 Tainted: G            E     5.9.0-rc2-mm1-1-default+ #5
kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
kernel: Call Trace:
kernel:  dump_stack+0x6d/0x8b
kernel:  compaction_alloc+0xb2/0xc0
kernel:  migrate_pages+0x2a6/0x12a0
kernel:  ? isolate_freepages+0xc80/0xc80
kernel:  ? __ClearPageMovable+0xb0/0xb0
kernel:  compact_zone+0x5eb/0x11c0
kernel:  ? finish_task_switch+0x74/0x300
kernel:  ? lock_timer_base+0xa8/0x170
kernel:  proactive_compact_node+0x89/0xf0
kernel:  ? kcompactd+0x2d0/0x3a0
kernel:  kcompactd+0x2d0/0x3a0
kernel:  ? finish_wait+0x80/0x80
kernel:  ? kcompactd_do_work+0x350/0x350
kernel:  kthread+0x118/0x130
kernel:  ? kthread_associate_blkcg+0xa0/0xa0
kernel:  ret_from_fork+0x22/0x30

After that, if e.g: someone faults in the page, that someone will get killed
unexpectedly.

[1] https://lore.kernel.org/linux-mm/20190826104144.GA7849@linux/T/#u
[2] https://patchwork.kernel.org/patch/11694847/

Link: https://lkml.kernel.org/r/20200902094510.10727-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20200902094510.10727-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-take-free-pages-off-the-buddy-freelists
+++ a/mm/memory-failure.c
@@ -1325,6 +1325,7 @@ int memory_failure(unsigned long pfn, in
 	struct dev_pagemap *pgmap;
 	int res;
 	unsigned long page_flags;
+	bool retry = true;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1364,10 +1365,20 @@ int memory_failure(unsigned long pfn, in
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
+try_again:
 	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
 		if (is_free_buddy_page(p)) {
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-			return 0;
+			if (take_page_off_buddy(p)) {
+				action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
+				return 0;
+			} else {
+				/* We lost the race, try again */
+				if (retry) {
+					retry = false;
+					goto try_again;
+				}
+				return -EBUSY;
+			}
 		} else {
 			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 			return -EBUSY;
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch

