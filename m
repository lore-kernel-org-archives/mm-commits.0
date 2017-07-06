From: akpm@linux-foundation.org
Subject: [patch 048/108] mm, memory_hotplug: consider offline
 memblocks removable
Date: Thu, 06 Jul 2017 15:37:53 -0700
Message-ID: <20170706223753.O7vfFlwzx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbdGFWiB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: consider offline memblocks removable

is_pageblock_removable_nolock() relies on having zone association to
examine all the page blocks to check whether they are movable or free. 
This is just wasting of cycles when the memblock is offline.  Later patch
in the series will also change the time when the page is associated with a
zone so we let's bail out early if the memblock is offline.

Link: http://lkml.kernel.org/r/20170515085827.16474-7-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Igor Mammedov <imammedo@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/base/memory.c~mm-memory_hotplug-consider-offline-memblocks-removable drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory_hotplug-consider-offline-memblocks-removable
+++ a/drivers/base/memory.c
@@ -128,6 +128,9 @@ static ssize_t show_mem_removable(struct
 	int ret = 1;
 	struct memory_block *mem = to_memory_block(dev);
 
+	if (mem->state != MEM_ONLINE)
+		goto out;
+
 	for (i = 0; i < sections_per_block; i++) {
 		if (!present_section_nr(mem->start_section_nr + i))
 			continue;
@@ -135,6 +138,7 @@ static ssize_t show_mem_removable(struct
 		ret &= is_mem_section_removable(pfn, PAGES_PER_SECTION);
 	}
 
+out:
 	return sprintf(buf, "%d\n", ret);
 }
 
_
