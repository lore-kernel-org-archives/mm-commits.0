Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEB1C4727F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80B7421D41
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601339598;
	bh=uq2pINjFgzNxXwp/vS7bsU56xdzvt48S0Izw+5tQISk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EkDKXLdMtJ6ZWfryZUskphP5Smox5kpBgHyYqK3g5sLshY92vCg27LoY8flSU22T/
	 1J5k3ioF9ANC27/Q30nH/bZ78uRboR6BPAvcLEFgfmn/kU261TO6tP5J7mPhHTtcvJ
	 ZEt1V/Qt7XM5t4hwgOlfUfQpj1tjaPO3BKsaONSQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgI2AdS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgI2AdS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:33:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94FE92193E;
        Tue, 29 Sep 2020 00:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601339596;
        bh=uq2pINjFgzNxXwp/vS7bsU56xdzvt48S0Izw+5tQISk=;
        h=Date:From:To:Subject:From;
        b=blSmZeVy3V4y648tXOxQGZTCxKJM8jVNGBbnzIMYoXlAwUlTcj7kUhuieHEvmeOLV
         VpCW554jE1sM14K0vqSnNOZ9H22oIVgHysgdA5LNV7l5H5dI+QRyfWn0DFGkcm0Gwx
         B8a5Bub7jzj2gd3zRX7bNbscYefMv+ngn9y2ozrM=
Date:   Mon, 28 Sep 2020 17:33:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org
Subject:  + mm-remove-useless-out-label-in-__swap_writepage.patch
 added to -mm tree
Message-ID: <20200929003316.cFrZeypp9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io.c: remove useless out label in __swap_writepage()
has been added to the -mm tree.  Its filename is
     mm-remove-useless-out-label-in-__swap_writepage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-useless-out-label-in-__swap_writepage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-useless-out-label-in-__swap_writepage.patch

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
Subject: mm/page_io.c: remove useless out label in __swap_writepage()

The out label is only used in one place and return ret directly without
something like resource cleanup or lock release and so on.  So we should
remove this jump label and do some cleanup.

Link: https://lkml.kernel.org/r/20200927124032.22521-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-remove-useless-out-label-in-__swap_writepage
+++ a/mm/page_io.c
@@ -349,13 +349,11 @@ int __swap_writepage(struct page *page,
 		return 0;
 	}
 
-	ret = 0;
 	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
 	if (bio == NULL) {
 		set_page_dirty(page);
 		unlock_page(page);
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 	bio->bi_opf = REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc);
 	bio_associate_blkg_from_page(bio, page);
@@ -363,8 +361,8 @@ int __swap_writepage(struct page *page,
 	set_page_writeback(page);
 	unlock_page(page);
 	submit_bio(bio);
-out:
-	return ret;
+
+	return 0;
 }
 
 int swap_readpage(struct page *page, bool synchronous)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-remove-useless-out-label-in-__swap_writepage.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

