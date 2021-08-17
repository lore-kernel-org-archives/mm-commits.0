Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C71C4338F
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 01:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6A4260F35
	for <mm-commits@archiver.kernel.org>; Tue, 17 Aug 2021 01:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhHQBSr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 21:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhHQBSq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 21:18:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ECC660EFF;
        Tue, 17 Aug 2021 01:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629163094;
        bh=aBc3LZxvQiYhTuj5S0JD06iE0FT+/eIrFIE9GL/8OoA=;
        h=Date:From:To:Subject:From;
        b=zoAHsmZ+hA0+cpCL9Gnc/oD2rpoMTUUiwK5Oq5nEcGvI1HwOTjSaw1BELTGo5KbYx
         yV9EEoh5BixZ2q1bKoo7SNMsrtxPzh37njIhodOKM19Cjyzv1X/tHG4vbr1r8YK8mP
         i6XkA/iAgBwkFgPkoC8kyW1cesWRsc1WwDDAuqSM=
Date:   Mon, 16 Aug 2021 18:18:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com
Subject:  +
 mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch added to -mm
 tree
Message-ID: <20210817011814.mgYWR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: change argument struct page **hpagep to *hpage
has been added to the -mm tree.  Its filename is
     mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch

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
Subject: mm/hwpoison: change argument struct page **hpagep to *hpage

It's unnecessary to pass in a struct page **hpagep because it's never
modified.  Changing to use *hpage to simplify the code.

Link: https://lkml.kernel.org/r/20210814105131.48814-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-change-argument-struct-page-hpagep-to-hpage
+++ a/mm/memory-failure.c
@@ -1265,14 +1265,13 @@ static int get_hwpoison_page(struct page
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
 static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
-				  int flags, struct page **hpagep)
+				  int flags, struct page *hpage)
 {
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
 	int kill = 1, forcekill;
-	struct page *hpage = *hpagep;
 	bool mlocked = PageMlocked(hpage);
 
 	/*
@@ -1497,7 +1496,7 @@ static int memory_failure_hugetlb(unsign
 		goto out;
 	}
 
-	if (!hwpoison_user_mappings(p, pfn, flags, &head)) {
+	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
@@ -1777,7 +1776,7 @@ try_again:
 	 * Now take care of user space mappings.
 	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
 	 */
-	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
+	if (!hwpoison_user_mappings(p, pfn, flags, p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto unlock_page;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-gup-remove-set-but-unused-local-variable-major.patch
mm-gup-remove-unneed-local-variable-orig_refs.patch
mm-gup-remove-useless-bug_on-in-__get_user_pages.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge.patch
mm-gup-use-helper-page_aligned-in-populate_vma_page_range.patch
shmem-remove-unneeded-variable-ret.patch
shmem-remove-unneeded-header-file.patch
shmem-remove-unneeded-function-forward-declaration.patch
shmem-include-header-file-to-declare-swap_info.patch
mm-memcg-remove-unused-functions.patch
mm-memcg-save-some-atomic-ops-when-flush-is-already-true.patch
mm-hwpoison-remove-unneeded-variable-unmap_success.patch
mm-hwpoison-fix-potential-pte_unmap_unlock-pte-error.patch
mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch
mm-hwpoison-fix-some-obsolete-comments.patch
mm-vmscan-remove-the-pagedirty-check-after-madv_free-pages-are-page_ref_freezed.patch
mm-vmscan-remove-misleading-setting-to-sc-priority.patch
mm-vmscan-remove-unneeded-return-value-of-kswapd_run.patch
mm-vmscan-add-else-to-remove-check_pending-label.patch
mm-vmstat-correct-some-wrong-comments.patch
mm-vmstat-simplify-the-array-size-calculation.patch
mm-vmstat-remove-unneeded-return-value.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

