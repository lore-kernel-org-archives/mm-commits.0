Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CC4C2D0E2
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A5C23787
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600803800;
	bh=vv70d/H2ax2hzTJNaoIfIB75ZF4fCgZ3goNsvVRwxxI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=k5EHLG5uwG7HjVoMhGusi6BgZB46nc8fCzKtpahvYROfOhOySHS4WwURRoikMYYnn
	 Yp5z/pI+uYHpM6ciSV/5y5lVtM5y/UqheMyw7ya+3KCCbJH85Me6dGC/GuDWjFoKe/
	 Ef0vGg/4xTKiIoUI8Lkt+RAXtE5mzfHJ3WDwIfvI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIVTnU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 15:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVTnU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 15:43:20 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9409E2158C;
        Tue, 22 Sep 2020 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600803798;
        bh=vv70d/H2ax2hzTJNaoIfIB75ZF4fCgZ3goNsvVRwxxI=;
        h=Date:From:To:Subject:From;
        b=cPdSPY3UvJFwSnKKU9t/XUSRzI1xt0lGKqpsxI/DE1JsP5Kpm0HY9CQKLikfJpxhN
         sIM6mnO4Hj+/76kZCtsD3Ek+OlJuSoJgOpu+B5Xl7bpWSFBLaI+jmBE2qjEIIHyfP4
         ZnHMPtBjkahEjBKos/FVSo21ycvxkCPIXXs5Hikg=
Date:   Tue, 22 Sep 2020 12:43:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        osalvador@suse.com, naoya.horiguchi@nec.com, mhocko@kernel.org,
        cai@lca.pw, osalvador@suse.de
Subject:  [to-be-updated]
 mmhwpoison-take-free-pages-off-the-buddy-freelists.patch removed from -mm
 tree
Message-ID: <20200922194317.vFFlG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: take free pages off the buddy freelists
has been removed from the -mm tree.  Its filename was
     mmhwpoison-take-free-pages-off-the-buddy-freelists.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: take free pages off the buddy freelists

Patch series "HWpoison: further fixes and cleanups", v2.

The important bit of this patchset is patch#1, which is a fix to take off
HWPoison pages off a buddy freelist since it can lead us to having
HWPoison pages back in the game without no one noticing it.  So fix it (we
did that already for soft_offline_page [1]).

The other patches are clean-ups and not that important.


This patch (of 5):

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

After that, if e.g: someone faults in the page, that someone will get
killed unexpectedly.

While we are at it, I also changed the action result for such cases.  I
think that MF_DELAYED is a bit misleading, because in case we could
contain the page and take it off the buddy, such a page is not to be used
again unless it is unpoison, so we "fixed" the situation.

So unless I am missing something, I strongly think that we should report
MF_RECOVERED.

[1] https://lore.kernel.org/linux-mm/20190826104144.GA7849@linux/T/#u
[2] https://patchwork.kernel.org/patch/11694847/

Link: https://lkml.kernel.org/r/20200908075626.11976-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20200908075626.11976-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-take-free-pages-off-the-buddy-freelists
+++ a/mm/memory-failure.c
@@ -1321,8 +1321,9 @@ int memory_failure(unsigned long pfn, in
 	struct page *hpage;
 	struct page *orig_head;
 	struct dev_pagemap *pgmap;
-	int res;
 	unsigned long page_flags;
+	int res = 0;
+	bool retry = true;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1362,10 +1363,21 @@ int memory_failure(unsigned long pfn, in
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
+try_again:
 	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
 		if (is_free_buddy_page(p)) {
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-			return 0;
+			if (take_page_off_buddy(p)) {
+				action_result(pfn, MF_MSG_BUDDY, MF_RECOVERED);
+				return 0;
+			} else {
+				/* We lost the race, try again */
+				if (retry) {
+					retry = false;
+					goto try_again;
+				}
+				action_result(pfn, MF_MSG_BUDDY, MF_IGNORED);
+				return -EBUSY;
+			}
 		} else {
 			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 			return -EBUSY;
@@ -1391,11 +1403,15 @@ int memory_failure(unsigned long pfn, in
 	shake_page(p, 0);
 	/* shake_page could have turned it free. */
 	if (!PageLRU(p) && is_free_buddy_page(p)) {
+		if (!take_page_off_buddy(p))
+			res = -EBUSY;
+
 		if (flags & MF_COUNT_INCREASED)
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
+			action_result(pfn, MF_MSG_BUDDY, res ? MF_IGNORED : MF_RECOVERED);
 		else
-			action_result(pfn, MF_MSG_BUDDY_2ND, MF_DELAYED);
-		return 0;
+			action_result(pfn, MF_MSG_BUDDY_2ND, res ? MF_IGNORED : MF_RECOVERED);
+
+		return res;
 	}
 
 	lock_page(p);
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

