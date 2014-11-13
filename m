From: akpm@linux-foundation.org
Subject: + memory-hotplug-remove-redundant-call-of-page_to_pfn.patch added to -mm tree
Date: Thu, 13 Nov 2014 14:12:11 -0800
Message-ID: <54652cbb.oQMDptkRZz0Kc8tH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765AbaKMWMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 17:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, dave@sr71.net, isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, wangnan0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: remove redundant call of page_to_pfn
has been added to the -mm tree.  Its filename is
     memory-hotplug-remove-redundant-call-of-page_to_pfn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-remove-redundant-call-of-page_to_pfn.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-remove-redundant-call-of-page_to_pfn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: memory-hotplug: remove redundant call of page_to_pfn

This is just a small optimization.  The start_pfn can be obtained directly
by phys_index << PFN_SECTION_SHIFT.  So the call of page_to_pfn() is
redundant and remove it.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-remove-redundant-call-of-page_to_pfn drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-remove-redundant-call-of-page_to_pfn
+++ a/drivers/base/memory.c
@@ -228,8 +228,8 @@ memory_block_action(unsigned long phys_i
 	struct page *first_page;
 	int ret;
 
-	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
-	start_pfn = page_to_pfn(first_page);
+	start_pfn = phys_index << PFN_SECTION_SHIFT;
+	first_page = pfn_to_page(start_pfn);
 
 	switch (action) {
 		case MEM_ONLINE:
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

memory-hotplug-remove-redundant-call-of-page_to_pfn.patch

