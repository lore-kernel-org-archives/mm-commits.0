Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720CAC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 23:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 556696124F
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 23:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243549AbhIWXTa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 19:19:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243578AbhIWXTa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 19:19:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB18D6124E;
        Thu, 23 Sep 2021 23:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632439078;
        bh=20XipnesQXQSsSDwsiT7CSoFDxg/1DEkEgt45/QWYtA=;
        h=Date:From:To:Subject:From;
        b=ob6jmRYdK0O5vAUXMm2ZK3VMGTUVzyr9ihe/fbiwUuvka11TAcY/1EVNjGa1tuhRE
         etY6Ooc9YC9CTTJRGz1xGieAtiaWnORc/wick6DFSOwJO9GoiNt4+dwF6tN5/gTgCc
         +4IHlBWNZFS3LGxpdcrlOA3kSswyYXWAVvbrMryc=
Date:   Thu, 23 Sep 2021 16:17:57 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        songmuchun@bytedance.com, zhengqi.arch@bytedance.com
Subject:  +
 mm-memory_failure-fix-the-missing-pte_unmap-call-fix.patch added to -mm
 tree
Message-ID: <20210923231757.EZAdqiCeT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_failure-fix-the-missing-pte_unmap-call-fix
has been added to the -mm tree.  Its filename is
     mm-memory_failure-fix-the-missing-pte_unmap-call-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_failure-fix-the-missing-pte_unmap-call-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_failure-fix-the-missing-pte_unmap-call-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_failure-fix-the-missing-pte_unmap-call-fix

cleanup

Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-fix-the-missing-pte_unmap-call-fix
+++ a/mm/memory-failure.c
@@ -330,11 +330,8 @@ static unsigned long dev_pagemap_mapping
 	if (pmd_devmap(*pmd))
 		return PMD_SHIFT;
 	pte = pte_offset_map(pmd, address);
-	if (!pte_present(*pte))
-		goto unmap;
-	if (pte_devmap(*pte))
+	if (pte_present(*pte) && pte_devmap(*pte))
 		ret = PAGE_SHIFT;
-unmap:
 	pte_unmap(pte);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_failure-fix-the-missing-pte_unmap-call-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

