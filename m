From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch
 added to -mm tree
Date: Thu, 19 Sep 2013 15:38:43 -0700
Message-ID: <523b7cf3.K//R1kFUsFMA1cBy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3ISWio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, qiuxishi@huawei.com

Subject: + mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch added to -mm tree
To: qiuxishi@huawei.com,isimatu.yasuaki@jp.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:38:43 -0700


The patch titled
     Subject: mm/memory_hotplug.c: use pfn_to_nid() instead of page_to_nid(pfn_to_page())
has been added to the -mm tree.  Its filename is
     mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm/memory_hotplug.c: use pfn_to_nid() instead of page_to_nid(pfn_to_page())

Use "pfn_to_nid(pfn)" instead of "page_to_nid(pfn_to_page(pfn))".

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page
+++ a/mm/memory_hotplug.c
@@ -934,7 +934,7 @@ int __ref online_pages(unsigned long pfn
 	arg.nr_pages = nr_pages;
 	node_states_check_changes_online(nr_pages, zone, &arg);
 
-	nid = page_to_nid(pfn_to_page(pfn));
+	nid = pfn_to_nid(pfn);
 
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-arch-use-__free_reserved_page-to-simplify-the-code.patch
drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch
mm-use-populated_zone-instead-of-ifzone-present_pages.patch
mm-memory_hotplugc-rename-the-function-is_memblock_offlined_cb.patch
mm-memory_hotplugc-use-pfn_to_nid-instead-of-page_to_nidpfn_to_page.patch
documentation-dma-attributestxt-fix-typo.patch

