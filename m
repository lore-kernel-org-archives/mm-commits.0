Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37456C67871
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiJYARN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiJYAQh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:16:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6BFDF44
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:36:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52ACE615F0
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFD6C433D6;
        Mon, 24 Oct 2022 22:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650968;
        bh=lgJLmm+VM6KO+FPkqX01tf7k2KP2XZpe3Rwzo2oyu9k=;
        h=Date:To:From:Subject:From;
        b=I939okRxnpQbih3oKjZzUAK5SSjl3PUrwXrklIkZ3sYvF6EtllXda5KZ9jVFx4wBs
         taF6mCrtBn2x1S3aK9s6NPOEXH3/jGjyf6CAWsj2AKql2s8RibjoAZFk6l0MNH3oU+
         Dajja+6GT/4U15T2dHHNi9wWNDEgd6sAiXcA8/sY=
Date:   Mon, 24 Oct 2022 15:36:07 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-make-action_result-return-int-v2.patch added to mm-unstable branch
Message-Id: <20221024223608.9BFD6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-make-action_result-return-int-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-make-action_result-return-int-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-make-action_result-return-int-v2.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-memory-failure-make-action_result-return-int-v2
Date: Mon, 24 Oct 2022 11:51:38 +0800

- MF_DELAYED is considered as success, suggested by HORIGUCHI

- adjust order between unlock_page(head) and action_result()
  after !hwpoison_user_mappings() to clean code more in
  try_memory_failure_hugetlb()

Link: https://lkml.kernel.org/r/20221024035138.99119-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-make-action_result-return-int-v2
+++ a/mm/memory-failure.c
@@ -1191,7 +1191,7 @@ static int action_result(unsigned long p
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
-	return result == MF_RECOVERED ? 0 : -EBUSY;
+	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
 static int page_action(struct page_state *ps, struct page *p,
@@ -1202,14 +1202,12 @@ static int page_action(struct page_state
 	/* page p should be unlocked after returning from ps->action().  */
 	result = ps->action(ps, p);
 
-	action_result(pfn, ps->type, result);
-
 	/* Could do more checks here if page looks ok */
 	/*
 	 * Could adjust zone counters here to correct for the missing page.
 	 */
 
-	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
+	return action_result(pfn, ps->type, result);
 }
 
 static inline bool PageHWPoisonTakenOff(struct page *page)
@@ -1890,9 +1888,8 @@ retry:
 	page_flags = head->flags;
 
 	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
-		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		unlock_page(head);
-		return res;
+		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 	}
 
 	return identify_page_state(pfn, p, page_flags);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch
mm-remove-kern_addr_valid-completely.patch
nios2-remove-unused-init_mmap.patch
x86-sgx-use-vm_access_flags.patch
mm-mprotect-use-vm_access_flags.patch
mm-debug_vm_pgtable-use-vm_access_flags.patch
amdgpu-use-vm_access_flags.patch
mm-memory-failure-make-put_ref_page-more-useful.patch
mm-memory-failure-avoid-pfn_valid-twice-in-soft_offline_page.patch
mm-memory-failure-make-action_result-return-int.patch
mm-memory-failure-make-action_result-return-int-v2.patch

