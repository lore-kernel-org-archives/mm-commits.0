Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA8BC4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D0160C41
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 18:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhHGSnv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 14:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGSnv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 14:43:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D8076105A;
        Sat,  7 Aug 2021 18:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628361813;
        bh=4N9fhWS9YLHH/k+hI0mP/y9PK/SvaiwvFdHiZn9R+SQ=;
        h=Date:From:To:Subject:From;
        b=vfKDs5Nte9ncRjG4Ukvifiydui3dAzh59rmBCqLLXW7uY5bBk8nm63ZAm6T3gsihs
         cjBmSlhZGlmhYwMcwKP/6hSm2AG5B1IgbHKdAtcM4g+zIAaoZaBwl+9MClAjCTOe6R
         VP9R9iYaA9MlH/Rx7gynpBDSmckKZvuMoe45h2BE=
Date:   Sat, 07 Aug 2021 11:43:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, jack@suse.cz, imbrenda@linux.ibm.com,
        linmiaohe@huawei.com
Subject:  + mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
 added to -mm tree
Message-ID: <20210807184333.SJMk5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: gup: remove useless BUG_ON in __get_user_pages()
has been added to the -mm tree.  Its filename is
     mm-gup-remove-useless-bug_on-in-__get_user_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-remove-useless-bug_on-in-__get_user_pages.patch

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
Subject: mm: gup: remove useless BUG_ON in __get_user_pages()

Indeed, this BUG_ON couldn't catch anything useful.  We are sure ret == 0
here because we would already bail out if ret != 0 and ret is untouched
till here.

Link: https://lkml.kernel.org/r/20210807093620.21347-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/gup.c~mm-gup-remove-useless-bug_on-in-__get_user_pages
+++ a/mm/gup.c
@@ -1149,7 +1149,6 @@ static long __get_user_pages(struct mm_s
 					 * We must stop here.
 					 */
 					BUG_ON(gup_flags & FOLL_NOWAIT);
-					BUG_ON(ret != 0);
 					goto out;
 				}
 				continue;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

