Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E9DE82CA5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Sep 2023 15:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjI0Pry (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbjI0Prj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2023 11:47:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3B9284E6;
        Wed, 27 Sep 2023 08:47:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7ABC433C7;
        Wed, 27 Sep 2023 15:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695829630;
        bh=2rMgseKbIX4TDdskairnX1o3/qQEXOmLx97RSfB7Xew=;
        h=Date:To:From:Subject:From;
        b=gOZul6zlDBDAGvOoD46LtWJjnFhz6ViCorRjU/j+Kjr5gQyj28CxXJjhbT3DCFJVi
         B82yfft7yvdRJOxlm+Oco5mJIsNxyqFc6OvP8azY235so7jW1k/zFl7GVBiMY14T09
         wGKEnXlz26rShBgkhv61lvbn6ZrhtvIDhsI39pBs=
Date:   Wed, 27 Sep 2023 08:47:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, osalvador@suse.de, naoya.horiguchi@nec.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20230927154709.EB7ABC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: correct start page when guard page debug is enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_alloc: correct start page when guard page debug is enabled
Date: Wed, 27 Sep 2023 17:44:01 +0800

When guard page debug is enabled and set_page_guard returns success, we
miss to forward page to point to start of next split range and we will do
split unexpectedly in page range without target page.  Move start page
update before set_page_guard to fix this.

As we split to wrong target page, then splited pages are not able to merge
back to original order when target page is put back and splited pages
except target page is not usable.  To be specific:

Consider target page is the third page in buddy page with order 2.
| buddy-2 | Page | Target | Page |

After break down to target page, we will only set first page to Guard
because of bug.
| Guard   | Page | Target | Page |

When we try put_page_back_buddy with target page, the buddy page of target
if neither guard nor buddy, Then it's not able to construct original page
with order 2
| Guard | Page | buddy-0 | Page |

All pages except target page is not in free list and is not usable.

Link: https://lkml.kernel.org/r/20230927094401.68205-1-shikemeng@huaweicloud.com
Fixes: 06be6ff3d2ec ("mm,hwpoison: rework soft offline for free pages")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled
+++ a/mm/page_alloc.c
@@ -6475,6 +6475,7 @@ static void break_down_buddy_pages(struc
 			next_page = page;
 			current_buddy = page + size;
 		}
+		page = next_page;
 
 		if (set_page_guard(zone, current_buddy, high, migratetype))
 			continue;
@@ -6482,7 +6483,6 @@ static void break_down_buddy_pages(struc
 		if (current_buddy != target) {
 			add_to_free_list(current_buddy, zone, high, migratetype);
 			set_buddy_order(current_buddy, high);
-			page = next_page;
 		}
 	}
 }
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch
mm-compaction-use-correct-list-in-move_freelist_head-tail.patch
mm-compaction-call-list_is_first-last-more-intuitively-in-move_freelist_head-tail.patch
mm-compaction-correctly-return-failure-with-bogus-compound_order-in-strict-mode.patch
mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch
mm-compaction-improve-comment-of-is_via_compact_memory.patch
mm-compaction-factor-out-code-to-test-if-we-should-run-compaction-for-target-order.patch

