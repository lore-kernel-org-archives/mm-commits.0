Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE11CDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjJNW0m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjJNW0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:26:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91782D6
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:26:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62703C433C7;
        Sat, 14 Oct 2023 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697322400;
        bh=DUcX+rHkIwXdsHWNggymnDnd4ILEEyKH/RXtLb7kDG0=;
        h=Date:To:From:Subject:From;
        b=s+lGVy6rkfZpPpJh27LCZKvanxcbEbIbG3MMgnvpAr7aKEzu7DPp8gSLma/RgrTbu
         PDV2JlaPPjh3Z/306eEM342yOxywqHjQOrEx0tC0nd+Y8txtYBAf8V0NizzMqpsUzX
         qEHZ9/1h7AtOAAaPQ0P9sDYjgqpzgIt3LyOUg1Z4=
Date:   Sat, 14 Oct 2023 15:26:36 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com,
        dan.j.williams@intel.com, aneesh.kumar@linux.ibm.com,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch added to mm-hotfixes-unstable branch
Message-Id: <20231014222639.62703C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparsemem: fix race in accessing memory_section->usage
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm/sparsemem: fix race in accessing memory_section->usage
Date: Fri, 13 Oct 2023 18:34:27 +0530

The below race is observed on a PFN which falls into the device memory
region with the system memory configuration where PFN's are such that
[ZONE_NORMAL ZONE_DEVICE ZONE_NORMAL].  Since normal zone start and end
pfn contains the device memory PFN's as well, the compaction triggered
will try on the device memory PFN's too though they end up in NOP(because
pfn_to_online_page() returns NULL for ZONE_DEVICE memory sections).  When
from other core, the section mappings are being removed for the
ZONE_DEVICE region, that the PFN in question belongs to, on which
compaction is currently being operated is resulting into the kernel crash
with CONFIG_SPASEMEM_VMEMAP enabled.

compact_zone()			memunmap_pages
-------------			---------------
__pageblock_pfn_to_page
   ......
 (a)pfn_valid():
     valid_section()//return true
			      (b)__remove_pages()->
				  sparse_remove_section()->
				    section_deactivate():
				    [Free the array ms->usage and set
				     ms->usage = NULL]
     pfn_section_valid()
     [Access ms->usage which
     is NULL]

NOTE: From the above it can be said that the race is reduced to between
the pfn_valid()/pfn_section_valid() and the section deactivate with
SPASEMEM_VMEMAP enabled.

The commit b943f045a9af("mm/sparse: fix kernel crash with
pfn_section_valid check") tried to address the same problem by clearing
the SECTION_HAS_MEM_MAP with the expectation of valid_section() returns
false thus ms->usage is not accessed.

Fix this issue by the below steps:

a) Clear SECTION_HAS_MEM_MAP before freeing the ->usage.

b) RCU protected read side critical section will either return NULL
   when SECTION_HAS_MEM_MAP is cleared or can successfully access ->usage.

c) Synchronize the rcu on the write side and free the ->usage.  No
   attempt will be made to access ->usage after this as the
   SECTION_HAS_MEM_MAP is cleared thus valid_section() return false.

Since the section_deactivate() is a rare operation and will come in the
hot remove path, impact of synchronize_rcu() should be negligble.

Link: https://lkml.kernel.org/r/1697202267-23600-1-git-send-email-quic_charante@quicinc.com
Fixes: f46edbd1b151 ("mm/sparsemem: add helpers track active portions of a section at boot")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   11 +++++++++--
 mm/sparse.c            |   14 ++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/include/linux/mmzone.h~mm-sparsemem-fix-race-in-accessing-memory_section-usage
+++ a/include/linux/mmzone.h
@@ -1987,6 +1987,7 @@ static inline int pfn_section_valid(stru
 static inline int pfn_valid(unsigned long pfn)
 {
 	struct mem_section *ms;
+	int ret;
 
 	/*
 	 * Ensure the upper PAGE_SHIFT bits are clear in the
@@ -2000,13 +2001,19 @@ static inline int pfn_valid(unsigned lon
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
 	ms = __pfn_to_section(pfn);
-	if (!valid_section(ms))
+	rcu_read_lock();
+	if (!valid_section(ms)) {
+		rcu_read_unlock();
 		return 0;
+	}
 	/*
 	 * Traditionally early sections always returned pfn_valid() for
 	 * the entire section-sized span.
 	 */
-	return early_section(ms) || pfn_section_valid(ms, pfn);
+	ret = early_section(ms) || pfn_section_valid(ms, pfn);
+	rcu_read_unlock();
+
+	return ret;
 }
 #endif
 
--- a/mm/sparse.c~mm-sparsemem-fix-race-in-accessing-memory_section-usage
+++ a/mm/sparse.c
@@ -792,6 +792,13 @@ static void section_deactivate(unsigned
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 
 		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
+		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
+
+		/*
 		 * When removing an early section, the usage map is kept (as the
 		 * usage maps of other sections fall into the same page). It
 		 * will be re-used when re-adding the section - which is then no
@@ -799,16 +806,11 @@ static void section_deactivate(unsigned
 		 * was allocated during boot.
 		 */
 		if (!PageReserved(virt_to_page(ms->usage))) {
+			synchronize_rcu();
 			kfree(ms->usage);
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-		/*
-		 * Mark the section invalid so that valid_section()
-		 * return false. This prevents code from dereferencing
-		 * ms->usage array.
-		 */
-		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
 	/*
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-sparsemem-fix-race-in-accessing-memory_section-usage.patch

