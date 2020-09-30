Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0471C4727C
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8120B20848
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601502827;
	bh=kgevzwneDW0VsIRCKkkUSRjaizKt5F9/K8yTaOI591s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Gay3EqifRqGMVGXNgQr7E4bSmV0DRELRi7ZqhZbiYnMfRifKNysHvgtU+Ra6dzZdX
	 PoczIDoD20ESJV7iCBprJoS1l4int8DMmS46jdXgC0jWu5gIwVlU+fo70OeBgMcnec
	 jVwcKVAkhlU/OFq16MkqV8PcGof6yGL/e6KByE/Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgI3Vxr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3Vxr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:53:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A228F2076B;
        Wed, 30 Sep 2020 21:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601502826;
        bh=kgevzwneDW0VsIRCKkkUSRjaizKt5F9/K8yTaOI591s=;
        h=Date:From:To:Subject:From;
        b=IuJLbZWrvbqSa+UQHGlBVTMa8hSkrWbW4Ps18LNxtZUUPaqUMzLIwlG/DL0exelUz
         +sbg/XmTsHUbSPzmu+yK0C4//Zch5hUHSowerlxB6POBgAefIIi9IDWyYDnOKbWGy8
         EeNufZSf/SRGKJO02VXuQTQ3Vd/56m/k4HVQ4znU=
Date:   Wed, 30 Sep 2020 14:53:46 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-remove-unnecessary-goto-out-in-_swap_info_get.patch
 added to -mm tree
Message-ID: <20200930215346.Y1J26xsKa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: remove unnecessary goto out in _swap_info_get()
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-goto-out-in-_swap_info_get.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unnecessary-goto-out-in-_swap_info_get.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unnecessary-goto-out-in-_swap_info_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: remove unnecessary goto out in _swap_info_get()

It's unnecessary to goto the out label while out label is just below.

Link: https://lkml.kernel.org/r/20200930102549.1885-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-remove-unnecessary-goto-out-in-_swap_info_get
+++ a/mm/swapfile.c
@@ -1184,7 +1184,6 @@ static struct swap_info_struct *_swap_in
 
 bad_free:
 	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
-	goto out;
 out:
 	return NULL;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-remove-useless-out-label-in-__swap_writepage.patch
mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
mm-remove-unnecessary-goto-out-in-_swap_info_get.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

