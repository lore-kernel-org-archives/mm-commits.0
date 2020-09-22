Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8753CC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C722238A1
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600798124;
	bh=5nvxYt90/9go18FbiMRH/qFT+xAkO0X6ml5c2ucqphQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1a4MVmmVfLAzp4GpFrzpdY805Owo2o+3kBbNT3CIUgbUSlYGFx6ySjhkxgkc3Ut1y
	 AYJhS5vv/9bSYhnQyj0/oCV7lE+xqiIQMlBUaoyRtvPNnzyBxZBKuZ3aszYqoAoY5z
	 WooChrmppW4mX5VY8QX7K0dHNWiUwJgDmdm44Iwg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIVSIn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 14:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVSIn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 14:08:43 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D5A72376F;
        Tue, 22 Sep 2020 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600798123;
        bh=5nvxYt90/9go18FbiMRH/qFT+xAkO0X6ml5c2ucqphQ=;
        h=Date:From:To:Subject:From;
        b=e4W5WIkH46J8IMHklsoGySkUPeOex7G8JCJ9sGfWQibZR2UknGdjlHIPi1eE0Gp+1
         QR1ZGPCl3VbnKQ7aK7E3bxBFnP21g+Ln+GtwuPvn2DgX0zLn0fn0KK+aMPzOw0Bt3U
         SrbTjL0GSx23aBBj3nw4362H3kFK4ingFazEnxSo=
Date:   Tue, 22 Sep 2020 11:08:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        richard.weiyang@linux.alibaba.com
Subject:  + mm-mempolicy-remove-or-narrow-the-lock-on-current.patch
 added to -mm tree
Message-ID: <20200922180842.j27Cw%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: remove or narrow the lock on current
has been added to the -mm tree.  Its filename is
     mm-mempolicy-remove-or-narrow-the-lock-on-current.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-remove-or-narrow-the-lock-on-current.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-remove-or-narrow-the-lock-on-current.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mempolicy: remove or narrow the lock on current

It is not necessary to hold the lock of current when setting nodemask of
a new policy.

Link: https://lkml.kernel.org/r/20200921040416.86185-1-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-remove-or-narrow-the-lock-on-current
+++ a/mm/mempolicy.c
@@ -875,13 +875,12 @@ static long do_set_mempolicy(unsigned sh
 		goto out;
 	}
 
-	task_lock(current);
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
-		task_unlock(current);
 		mpol_put(new);
 		goto out;
 	}
+	task_lock(current);
 	old = current->mempolicy;
 	current->mempolicy = new;
 	if (new && new->mode == MPOL_INTERLEAVE)
@@ -1324,9 +1323,7 @@ static long do_mbind(unsigned long start
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
 			mmap_write_lock(mm);
-			task_lock(current);
 			err = mpol_set_nodemask(new, nmask, scratch);
-			task_unlock(current);
 			if (err)
 				mmap_write_unlock(mm);
 		} else
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch
mm-mmap-not-necessary-to-check-mapping-separately.patch
mm-mmap-check-on-file-instead-of-the-rb_root_cached-of-its-address_space.patch
mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch
mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache.patch
mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch
mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch
mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch
mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch
mm-mempolicy-remove-or-narrow-the-lock-on-current.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

