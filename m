From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-define-find=5Fsmallestbiggest=5Fsectio?=
 =?US-ASCII?Q?n=5Fpfn-as-unsigned-long.patch?= removed from -mm tree
Date: Wed, 04 Oct 2017 12:42:01 -0700
Message-ID: <20171004194201.7taIcxh7l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, vbabka@suse.cz, yasu.isimatu@gmail.com


The patch titled
     Subject: mm/memory_hotplug: define find_{smallest|biggest}_section_pfn as unsigned long
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-define-find_smallestbiggest_section_pfn-as-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Subject: mm/memory_hotplug: define find_{smallest|biggest}_section_pfn as unsigned long

find_{smallest|biggest}_section_pfn()s find the smallest/biggest section
and return the pfn of the section.  But the functions are defined as int. 
So the functions always return 0x00000000 - 0xffffffff.  It means if
memory address is over 16TB, the functions does not work correctly.

To handle 64 bit value, the patch defines
find_{smallest|biggest}_section_pfn() as unsigned long.

Fixes: 815121d2b5cd ("memory_hotplug: clear zone when removing the memory")
Link: http://lkml.kernel.org/r/d9d5593a-d0a4-c4be-ab08-493df59a85c6@gmail.com
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-define-find_smallestbiggest_section_pfn-as-unsigned-long mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-define-find_smallestbiggest_section_pfn-as-unsigned-long
+++ a/mm/memory_hotplug.c
@@ -338,7 +338,7 @@ EXPORT_SYMBOL_GPL(__add_pages);
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /* find the smallest valid pfn in the range [start_pfn, end_pfn) */
-static int find_smallest_section_pfn(int nid, struct zone *zone,
+static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
 				     unsigned long start_pfn,
 				     unsigned long end_pfn)
 {
@@ -363,7 +363,7 @@ static int find_smallest_section_pfn(int
 }
 
 /* find the biggest valid pfn in the range [start_pfn, end_pfn). */
-static int find_biggest_section_pfn(int nid, struct zone *zone,
+static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
 				    unsigned long start_pfn,
 				    unsigned long end_pfn)
 {
_

Patches currently in -mm which might be from yasu.isimatu@gmail.com are


