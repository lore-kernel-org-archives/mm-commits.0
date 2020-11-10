Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6583C55ABD
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C87320674
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xnqJmI1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgKJT36 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 14:29:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKJT35 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 14:29:57 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5749F20825;
        Tue, 10 Nov 2020 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605036595;
        bh=69nMA80u1CUitd7fvTw+zR7CeIClHWemMrZac+TwQkI=;
        h=Date:From:To:Subject:From;
        b=xnqJmI1oegpeLHajrnslmEmG3L4l9EmJfPpwOHBUn6Eud2XjQbr5dysCfTkKQiaFT
         4kLFYGTgctGIDysoQ+04TPuMNRWJ9up3nHmIVEwgGwA+ltFhs+JsyrsWWynIXBA0dD
         jmezbRvA86OwzAJcQAzHnnwoPmQ1ald2aRAAceNs=
Date:   Tue, 10 Nov 2020 11:29:54 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  +
 mmhwpoison-take-free-pages-off-the-buddy-freelists.patch added to -mm tree
Message-ID: <20201110192954.VXzhkjn9u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

The crux of the matter is that historically we left poisoned pages in the
buddy system because we have some checks in place when allocating a page
that are gatekeeper for poisoned pages.  Unfortunately, we do have other
users (e.g: compaction [1]) that scan buddy freelists and try to get a
page from there without checking whether the page is HWPoison.

As I stated already, I think it is fundamentally wrong to keep HWPoison
pages within the buddy systems, checks in place or not.

Let us fix this the same way we did for soft_offline [2], taking the page
off the buddy freelist so it is completely unreachable.

Note that this is fairly simple to trigger, as we only need to poison free
buddy pages (madvise MADV_HWPOISON) and then run some sort of memory
stress system.

Just for a matter of reference, I put a dump_page() in compaction_alloc()
to trigger for HWPoison patches:

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

After that, if e.g: a process faults in the page,  it will get killed
unexpectedly.
Fix it by containing the page immediatelly.

Besides that, two more changes can be noticed:

* MF_DELAYED no longer suits as we are fixing the issue by containing
  the page immediately, so it does no longer rely on the allocation-time
  checks to stop HWPoison to be handed over.
  gain unless it is unpoisoned, so we fixed the situation.
  Because of that, let us use MF_RECOVERED from now on.

* The second block that handles PageBuddy pages is no longer needed:
  We call shake_page and then check whether the page is Buddy
  because shake_page calls drain_all_pages, which sends pcp-pages back to
  the buddy freelists, so we could have a chance to handle free pages.
  Currently, get_hwpoison_page already calls drain_all_pages, and we call
  get_hwpoison_page right before coming here, so we should be on the safe
  side.

[1] https://lore.kernel.org/linux-mm/20190826104144.GA7849@linux/T/#u
[2] https://patchwork.kernel.org/cover/11792607/

Link: https://lkml.kernel.org/r/20201013144447.6706-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-take-free-pages-off-the-buddy-freelists
+++ a/mm/memory-failure.c
@@ -1339,6 +1339,7 @@ int memory_failure(unsigned long pfn, in
 	struct dev_pagemap *pgmap;
 	int res;
 	unsigned long page_flags;
+	bool retry = true;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1356,6 +1357,7 @@ int memory_failure(unsigned long pfn, in
 		return -ENXIO;
 	}
 
+try_again:
 	if (PageHuge(p))
 		return memory_failure_hugetlb(pfn, flags);
 	if (TestSetPageHWPoison(p)) {
@@ -1380,8 +1382,21 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
 		if (is_free_buddy_page(p)) {
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-			return 0;
+			if (take_page_off_buddy(p)) {
+				page_ref_inc(p);
+				res = MF_RECOVERED;
+			} else {
+				/* We lost the race, try again */
+				if (retry) {
+					ClearPageHWPoison(p);
+					num_poisoned_pages_dec();
+					retry = false;
+					goto try_again;
+				}
+				res = MF_FAILED;
+			}
+			action_result(pfn, MF_MSG_BUDDY, res);
+			return res == MF_RECOVERED ? 0 : -EBUSY;
 		} else {
 			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 			return -EBUSY;
@@ -1405,14 +1420,6 @@ int memory_failure(unsigned long pfn, in
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
 	shake_page(p, 0);
-	/* shake_page could have turned it free. */
-	if (!PageLRU(p) && is_free_buddy_page(p)) {
-		if (flags & MF_COUNT_INCREASED)
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-		else
-			action_result(pfn, MF_MSG_BUDDY_2ND, MF_DELAYED);
-		return 0;
-	}
 
 	lock_page(p);
 
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch

