From: akpm@linux-foundation.org
Subject: + hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
 added to -mm tree
Date: Thu, 13 Nov 2014 13:54:54 -0800
Message-ID: <546528ae.bhUPJ9ihaTonTcsJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934250AbaKMVyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:54:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@redhat.com, andi@firstfloor.org, dave@stgolabs.net, isimatu.yasuaki@jp.fujitsu.com, riel@redhat.com, rientjes@google.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: hugetlb_register_all_nodes(): add __init marker
has been added to the -mm tree.  Its filename is
     hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: hugetlb_register_all_nodes(): add __init marker

This function is only called during initialization.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-hugetlb_register_all_nodes-add-__init-marker mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-hugetlb_register_all_nodes-add-__init-marker
+++ a/mm/hugetlb.c
@@ -2083,7 +2083,7 @@ static void hugetlb_register_node(struct
  * devices of nodes that have memory.  All on-line nodes should have
  * registered their associated device by this time.
  */
-static void hugetlb_register_all_nodes(void)
+static void __init hugetlb_register_all_nodes(void)
 {
 	int nid;
 
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

hugetlb-fix-hugepages=-entry-in-kernel-parameterstxt.patch
hugetlb-alloc_bootmem_huge_page-use-is_aligned.patch
hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch
linux-next.patch

