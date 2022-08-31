Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E43ECAAD4
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 23:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiHaXOb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 19:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiHaXO3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 19:14:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93ABF8FEA
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 16:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55CA161C81
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 23:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7450C433D6;
        Wed, 31 Aug 2022 23:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661987667;
        bh=wM+2JzMSJPwUrZ0AYDLVErpEWlXksL6ET0eP6ezbQqo=;
        h=Date:To:From:Subject:From;
        b=frOIOc+UnUm9zIsULHJogzyWvU0mIpvTtLFF7B9DibTgs/PkOurqhcIPpio7k31bw
         oZfJU0RAzrLoqFsaZNNVJsxjKNCZ/fpNUHp07WVhPZ6Ofv170MXLTM5KHo/xYkGsqe
         lRKN/ckny1zWGxcXyySpseIlqng87TGgp8NiyucY=
Date:   Wed, 31 Aug 2022 16:14:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, minchan@kernel.org,
        hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-remove-redundant-declarations-in-ksmh.patch added to mm-unstable branch
Message-Id: <20220831231427.A7450C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: remove redundant declarations in ksm.h
has been added to the -mm mm-unstable branch.  Its filename is
     ksm-remove-redundant-declarations-in-ksmh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-remove-redundant-declarations-in-ksmh.patch

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

mm-thp-remove-redundant-pgtable-check-in-set_huge_zero_page.patch
mm-introduce-common-struct-mm_slot.patch
mm-thp-convert-to-use-common-struct-mm_slot.patch
ksm-remove-redundant-declarations-in-ksmh.patch
ksm-add-the-ksm-prefix-to-the-names-of-the-ksm-private-structures.patch
ksm-convert-ksm_mm_slotmm_list-to-ksm_mm_slotmm_node.patch
ksm-convert-ksm_mm_slotlink-to-ksm_mm_slothash.patch
ksm-convert-to-use-common-struct-mm_slot.patch

