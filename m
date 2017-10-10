From: akpm@linux-foundation.org
Subject: + mm-reducing-page_owner-structure-size.patch added to -mm tree
Date: Tue, 10 Oct 2017 13:42:33 -0700
Message-ID: <59dd30b9.exPhvbQRCrCtOh5G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932304AbdJJUme (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 16:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ayush.m@samsung.com, a.sahrawat@samsung.com, vbabka@suse.cz, vinmenon@codeaurora.org, v.narang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: reduce page_owner structure size
has been added to the -mm tree.  Its filename is
     mm-reducing-page_owner-structure-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-reducing-page_owner-structure-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-reducing-page_owner-structure-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -19,9 +19,9 @@
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

Patches currently in -mm which might be from ayush.m@samsung.com are

mm-reducing-page_owner-structure-size.patch

