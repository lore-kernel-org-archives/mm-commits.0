Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AB8E94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbjJFVqj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbjJFVqi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:46:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F961BE;
        Fri,  6 Oct 2023 14:46:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD177C433C8;
        Fri,  6 Oct 2023 21:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628797;
        bh=PCl4CBWRE6qLOar8gKrsXLI2bjflznbGFV52K5Zf7g0=;
        h=Date:To:From:Subject:From;
        b=sCoVwAV9QVPl9vtKnDdxldauXG+d40T4+MqQo92JEm1/Ncsy7B48wtFahvtVKgT1/
         /mFRM5Ykk3vKAoGBHUpibwJU/a7/LZnk2xdColQsFOfBjTXvtumpoT3twhfaIVl9T6
         La3D+v8EEczoGL/5T/jT9VzBkpB9aTUVxN8Rhx7s=
Date:   Fri, 06 Oct 2023 14:46:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, osalvador@suse.de, naoya.horiguchi@nec.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch removed from -mm tree
Message-Id: <20231006214636.AD177C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: correct start page when guard page debug is enabled
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch
mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

