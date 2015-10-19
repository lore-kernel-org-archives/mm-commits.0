From: akpm@linux-foundation.org
Subject: + mm-hugetlb-make-node_hstates-array-static.patch added to -mm
 tree
Date: Mon, 19 Oct 2015 15:38:32 -0700
Message-ID: <562570e8.PuRDUnb+CovvsCJ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbbJSWjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:39:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: make node_hstates array static
has been added to the -mm tree.  Its filename is
     mm-hugetlb-make-node_hstates-array-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-make-node_hstates-array-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-make-node_hstates-array-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/hugetlb: make node_hstates array static

There are no users of the node_hstates array outside of the
mm/hugetlb.c. So let's make it static.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-make-node_hstates-array-static mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-make-node_hstates-array-static
+++ a/mm/hugetlb.c
@@ -2376,7 +2376,7 @@ struct node_hstate {
 	struct kobject		*hugepages_kobj;
 	struct kobject		*hstate_kobjs[HUGE_MAX_HSTATE];
 };
-struct node_hstate node_hstates[MAX_NUMNODES];
+static struct node_hstate node_hstates[MAX_NUMNODES];
 
 /*
  * A subset of global hstate attributes for node devices
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-msync-use-offset_in_page-macro.patch
mm-nommu-use-offset_in_page-macro.patch
mm-mincore-use-offset_in_page-macro.patch
mm-early_ioremap-use-offset_in_page-macro.patch
mm-percpu-use-offset_in_page-macro.patch
mm-util-use-offset_in_page-macro.patch
mm-mlock-use-offset_in_page-macro.patch
mm-vmalloc-use-offset_in_page-macro.patch
mm-mmap-use-offset_in_page-macro.patch
mm-mremap-use-offset_in_page-macro.patch
mm-memblock-make-memblock_remove_range-static.patch
mm-hugetlb-make-node_hstates-array-static.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

