From: akpm@linux-foundation.org
Subject: [patch 053/131] mm/page_owner.c: reduce page_owner
 structure size
Date: Wed, 15 Nov 2017 17:34:30 -0800
Message-ID: <20171116013430.a1wVqkWEt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757751AbdKPBeb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:34:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.sahrawat@samsung.com, akpm@linux-foundation.org, ayush.m@samsung.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, v.narang@samsung.com, vbabka@suse.cz, vinmenon@codeaurora.org

From: Ayush Mittal <ayush.m@samsung.com>
Subject: mm/page_owner.c: reduce page_owner structure size

Maximum page order can be at max 10 which can be accomodated in short data
type(2 bytes).  last_migrate_reason is defined as enum type whose values
can be accomodated in short data type (2 bytes).

Total structure size is currently 16 bytes but after changing structure
size it goes to 12 bytes.

Vlastimil said:

: Looks like it works, so why not.
: Before:
: [    0.001000] allocated 50331648 bytes of page_ext
: After:
: [    0.001000] allocated 41943040 bytes of page_ext

Link: http://lkml.kernel.org/r/1507623917-37991-1-git-send-email-ayush.m@samsung.com
Signed-off-by: Ayush Mittal <ayush.m@samsung.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_owner.c~mm-reducing-page_owner-structure-size mm/page_owner.c
--- a/mm/page_owner.c~mm-reducing-page_owner-structure-size
+++ a/mm/page_owner.c
@@ -20,9 +20,9 @@
 #define PAGE_OWNER_STACK_DEPTH (16)
 
 struct page_owner {
-	unsigned int order;
+	unsigned short order;
+	short last_migrate_reason;
 	gfp_t gfp_mask;
-	int last_migrate_reason;
 	depot_stack_handle_t handle;
 };
 
_
