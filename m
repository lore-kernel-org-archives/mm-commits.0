Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB0BAC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiJCVEm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJCVEh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:04:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855384BD35
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DA89B815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73F8C433D6;
        Mon,  3 Oct 2022 21:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831070;
        bh=GVej7ljmKJIYtgE0FHkz5kdbZfG6bU8ZFSFQmrYiW4k=;
        h=Date:To:From:Subject:From;
        b=C1/Ji5eam4AnXuwBo/vSV3QgodIRb9vNZC8X3mj6iSgI6Jtn5aUkNhSc4NXCQ/K+X
         ZBPFyLRGBjSv7kxEDqGmDOhxrjUVZewj3MMPfi6UwSsiGbE9qjrzkvZiE0sGu1QT78
         Yy+ImHoUsvWPnKaQvbL4c9rZg0HDnLmaoER76LY8=
Date:   Mon, 03 Oct 2022 14:04:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, minchan@kernel.org,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-remove-redundant-declarations-in-ksmh.patch removed from -mm tree
Message-Id: <20221003210430.C73F8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ksm: remove redundant declarations in ksm.h
has been removed from the -mm tree.  Its filename was
     ksm-remove-redundant-declarations-in-ksmh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: ksm: remove redundant declarations in ksm.h
Date: Wed, 31 Aug 2022 11:19:47 +0800

Currently, for struct stable_node, no one uses it in both the
include/linux/ksm.h file and the file that contains it.  For struct
mem_cgroup, it's also not used in ksm.h.  So they're all redundant, just
remove them.

Link: https://lkml.kernel.org/r/20220831031951.43152-4-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/ksm.h~ksm-remove-redundant-declarations-in-ksmh
+++ a/include/linux/ksm.h
@@ -15,9 +15,6 @@
 #include <linux/sched.h>
 #include <linux/sched/coredump.h>
 
-struct stable_node;
-struct mem_cgroup;
-
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-use-update_mmu_tlb-on-the-second-thread.patch
loongarch-update-local-tlb-if-pte-entry-exists.patch

