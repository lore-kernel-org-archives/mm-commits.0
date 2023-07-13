Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B88AC001B0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 16:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbjGMQSb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 12:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbjGMQS3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 12:18:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC232729
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 09:18:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D3F960C26
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 16:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F5AC433C7;
        Thu, 13 Jul 2023 16:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689265106;
        bh=N+gQWtq4Nq8uKoStl2hrYn6roQGGJu0CTwawcxluO4o=;
        h=Date:To:From:Subject:From;
        b=GoHxTTqXN1AD+wFO1eh2KoDKXuEfrXb8rSSpiKQEHQ0AcrHVJbRVhrfElekiSNoWw
         rHtz5P9FYdkCl/G9mdPYvDj4nrD5M7wge+vnCirytaMF8ktn9YVP/1klf2zPD5SaJX
         otSWeiLVf0swXQjmC/P+djr7jWuTqMI/HS/nTHa4=
Date:   Thu, 13 Jul 2023 09:18:25 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        jthoughton@google.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-delete-all-entries-before-traversal-in-__folio_free_raw_hwp.patch added to mm-unstable branch
Message-Id: <20230713161825.E0F5AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: delete all entries before traversal in __folio_free_raw_hwp
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-delete-all-entries-before-traversal-in-__folio_free_raw_hwp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-delete-all-entries-before-traversal-in-__folio_free_raw_hwp.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/hwpoison: delete all entries before traversal in __folio_free_raw_hwp
Date: Thu, 13 Jul 2023 00:18:30 +0000

Patch series "Improve hugetlbfs read on HWPOISON hugepages", v4.

Today when hardware memory is corrupted in a hugetlb hugepage, kernel
leaves the hugepage in pagecache [1]; otherwise future mmap or read will
suject to silent data corruption.  This is implemented by returning -EIO
from hugetlb_read_iter immediately if the hugepage has HWPOISON flag set.

Since memory_failure already tracks the raw HWPOISON subpages in a
hugepage, a natural improvement is possible: if userspace only asks for
healthy subpages in the pagecache, kernel can return these data.

This patchset implements this improvement.  It consist of three parts. 
The 1st commit exports the functionality to tell if a subpage inside a
hugetlb hugepage is a raw HWPOISON page.  The 2nd commit teaches
hugetlbfs_read_iter to return as many healthy bytes as possible.  The 3rd
commit properly tests this new feature.

[1] commit 8625147cafaa ("hugetlbfs: don't delete error page from pagecache")


This patch (of 4):

Traversal on llist (e.g.  llist_for_each_safe) is only safe AFTER entries
are deleted from the llist.  Correct the way __folio_free_raw_hwp deletes
and frees raw_hwp_page entries in raw_hwp_list: first llist_del_all, then
kfree within llist_for_each_safe.

As of today, concurrent adding, deleting, and traversal on raw_hwp_list
from hugetlb.c and/or memory-failure.c are fine with each other.  Note
this is guaranteed partly by the lock-free nature of llist, and partly by
holding hugetlb_lock and/or mf_mutex.  For example, as llist_del_all is
lock-free with itself, folio_clear_hugetlb_hwpoison()s from
__update_and_free_hugetlb_folio and memory_failure won't need explicit
locking when freeing the raw_hwp_list.  New code that manipulates
raw_hwp_list must be careful to ensure the concurrency correctness.

Link: https://lkml.kernel.org/r/20230713001833.3778937-1-jiaqiyan@google.com
Link: https://lkml.kernel.org/r/20230713001833.3778937-2-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-delete-all-entries-before-traversal-in-__folio_free_raw_hwp
+++ a/mm/memory-failure.c
@@ -1830,12 +1830,11 @@ static inline struct llist_head *raw_hwp
 
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
-	struct llist_head *head;
-	struct llist_node *t, *tnode;
+	struct llist_node *t, *tnode, *head;
 	unsigned long count = 0;
 
-	head = raw_hwp_list_head(folio);
-	llist_for_each_safe(tnode, t, head->first) {
+	head = llist_del_all(raw_hwp_list_head(folio));
+	llist_for_each_safe(tnode, t, head) {
 		struct raw_hwp_page *p = container_of(tnode, struct raw_hwp_page, node);
 
 		if (move_flag)
@@ -1845,7 +1844,6 @@ static unsigned long __folio_free_raw_hw
 		kfree(p);
 		count++;
 	}
-	llist_del_all(head);
 	return count;
 }
 
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-hwpoison-delete-all-entries-before-traversal-in-__folio_free_raw_hwp.patch
mm-hwpoison-check-if-a-raw-page-in-a-hugetlb-folio-is-raw-hwpoison.patch
hugetlbfs-improve-read-hwpoison-hugepage.patch
selftests-mm-add-tests-for-hwpoison-hugetlbfs-read.patch

