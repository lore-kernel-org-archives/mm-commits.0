From: akpm@linux-foundation.org
Subject: + mm-page_owner-make-init_pages_in_zone-faster-fix.patch added to -mm tree
Date: Fri, 25 Aug 2017 14:26:55 -0700
Message-ID: <59a0961f.om5B0shxDg+IeLWG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933182AbdHYV04 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 17:26:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] mm, page_owner: make init_pages_in_zone() faster-fix
has been added to the -mm tree.  Its filename is
     mm-page_owner-make-init_pages_in_zone-faster-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-make-init_pages_in_zone-faster-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-make-init_pages_in_zone-faster-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] mm, page_owner: make init_pages_in_zone() faster-fix

don't duplicate code of __set_page_owner(), per Michal Hocko

Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-make-init_pages_in_zone-faster-fix mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-make-init_pages_in_zone-faster-fix
+++ a/mm/page_owner.c
@@ -165,17 +165,13 @@ static noinline depot_stack_handle_t sav
 	return handle;
 }
 
-noinline void __set_page_owner(struct page *page, unsigned int order,
-					gfp_t gfp_mask)
+static inline void __set_page_owner_handle(struct page_ext *page_ext,
+	depot_stack_handle_t handle, unsigned int order, gfp_t gfp_mask)
 {
-	struct page_ext *page_ext = lookup_page_ext(page);
 	struct page_owner *page_owner;
 
-	if (unlikely(!page_ext))
-		return;
-
 	page_owner = get_page_owner(page_ext);
-	page_owner->handle = save_stack(gfp_mask);
+	page_owner->handle = handle;
 	page_owner->order = order;
 	page_owner->gfp_mask = gfp_mask;
 	page_owner->last_migrate_reason = -1;
@@ -183,18 +179,17 @@ noinline void __set_page_owner(struct pa
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 }
 
-static void __set_page_owner_init(struct page_ext *page_ext,
-					depot_stack_handle_t handle)
+noinline void __set_page_owner(struct page *page, unsigned int order,
+					gfp_t gfp_mask)
 {
-	struct page_owner *page_owner;
+	struct page_ext *page_ext = lookup_page_ext(page);
+	depot_stack_handle_t handle;
 
-	page_owner = get_page_owner(page_ext);
-	page_owner->handle = handle;
-	page_owner->order = 0;
-	page_owner->gfp_mask = 0;
-	page_owner->last_migrate_reason = -1;
+	if (unlikely(!page_ext))
+		return;
 
-	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
+	handle = save_stack(gfp_mask);
+	__set_page_owner_handle(page_ext, handle, order, gfp_mask);
 }
 
 void __set_page_owner_migrate_reason(struct page *page, int reason)
@@ -582,12 +577,12 @@ static void init_pages_in_zone(pg_data_t
 			if (unlikely(!page_ext))
 				continue;
 
-			/* Maybe overraping zone */
+			/* Maybe overlaping zone */
 			if (test_bit(PAGE_EXT_OWNER, &page_ext->flags))
 				continue;
 
 			/* Found early allocated page */
-			__set_page_owner_init(page_ext, init_handle);
+			__set_page_owner_handle(page_ext, init_handle, 0, 0);
 			count++;
 		}
 	}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_owner-make-init_pages_in_zone-faster.patch
mm-page_owner-make-init_pages_in_zone-faster-fix.patch
mm-page_ext-periodically-reschedule-during-page_ext_init.patch
mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch

