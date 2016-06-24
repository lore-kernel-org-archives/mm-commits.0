From: akpm@linux-foundation.org
Subject: [patch 39/41] mm/page_owner: avoid null pointer dereference
Date: Fri, 24 Jun 2016 14:50:24 -0700
Message-ID: <576dab20.G/z4a/pV8gKIwKHn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbcFXVuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, iamjoonsoo.kim@lge.com, sudip.mukherjee@codethink.co.uk, vbabka@suse.cz

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: mm/page_owner: avoid null pointer dereference

We have dereferenced page_ext before checking it. Lets check it first
and then used it.

Fixes: f86e4271978b ("mm: check the return value of lookup_page_ext for all call sites")
Link: http://lkml.kernel.org/r/1465249059-7883-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-use-stackdepot-to-store-stacktrace-fix mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-use-stackdepot-to-store-stacktrace-fix
+++ a/mm/page_owner.c
@@ -207,13 +207,15 @@ void __dump_page_owner(struct page *page
 		.nr_entries = page_ext->nr_entries,
 		.entries = &page_ext->trace_entries[0],
 	};
-	gfp_t gfp_mask = page_ext->gfp_mask;
-	int mt = gfpflags_to_migratetype(gfp_mask);
+	gfp_t gfp_mask;
+	int mt;
 
 	if (unlikely(!page_ext)) {
 		pr_alert("There is not page extension available.\n");
 		return;
 	}
+	gfp_mask = page_ext->gfp_mask;
+	mt = gfpflags_to_migratetype(gfp_mask);
 
 	if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags)) {
 		pr_alert("page_owner info is not active (free page?)\n");
_
