From: akpm@linux-foundation.org
Subject: + mm-page_owner-use-stackdepot-to-store-stacktrace-fix.patch
 added to -mm tree
Date: Mon, 06 Jun 2016 14:45:38 -0700
Message-ID: <5755ef02.Mk4QXtLG8rIv9+LP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbcFFVpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 17:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, iamjoonsoo.kim@lge.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: avoid null pointer dereference
has been added to the -mm tree.  Its filename is
     mm-page_owner-use-stackdepot-to-store-stacktrace-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-use-stackdepot-to-store-stacktrace-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-use-stackdepot-to-store-stacktrace-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: mm/page_owner: avoid null pointer dereference

We have dereferenced page_ext before checking it. Lets check it first
and then used it.

Link: http://lkml.kernel.org/r/1465249059-7883-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-use-stackdepot-to-store-stacktrace-fix mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-use-stackdepot-to-store-stacktrace-fix
+++ a/mm/page_owner.c
@@ -291,13 +291,15 @@ void __dump_page_owner(struct page *page
 		.skip = 0
 	};
 	depot_stack_handle_t handle;
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

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

mm-page_owner-use-stackdepot-to-store-stacktrace-fix.patch
fpga-zynq-fpga-fix-build-failure.patch

