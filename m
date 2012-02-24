From: akpm@linux-foundation.org
Subject: + sparsemem-bootmem-catch-greater-than-section-size-allocations.patch added to -mm tree
Date: Fri, 24 Feb 2012 12:58:09 -0800
Message-ID: <20120224205809.DC2A7A00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:52125 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2BXU6L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 15:58:11 -0500
Received: by yhgm50 with SMTP id m50so60274yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 12:58:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, anton@au1.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, haveblue@us.ibm.com, paulus@samba.org, rcj@linux.vnet.ibm.com


The patch titled
     Subject: sparsemem/bootmem: catch greater than section size allocations
has been added to the -mm tree.  Its filename is
     sparsemem-bootmem-catch-greater-than-section-size-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nishanth Aravamudan <nacc@us.ibm.com>
Return-Path: <nacc@linux.vnet.ibm.com>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=7.0 tests=BAYES_00,T_RP_MATCHES_RCVD
	autolearn=unavailable version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id q1OJbR9u029810
	for <akpm@localhost>; Fri, 24 Feb 2012 11:37:27 -0800
X-Original-To: akpm@linux-foundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Fri, 24 Feb 2012 11:37:27 -0800 (PST)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTP id 1955A6E0
	for <akpm@linux-foundation.org>; Fri, 24 Feb 2012 19:35:31 +0000 (UTC)
X-Greylist: domain auto-whitelisted by SQLgrey-1.7.6
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 86CFE1F9B5
	for <akpm@linux-foundation.org>; Fri, 24 Feb 2012 19:35:30 +0000 (UTC)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <akpm@linux-foundation.org> from <nacc@linux.vnet.ibm.com>;
	Fri, 24 Feb 2012 14:35:29 -0500
Received: from d01dlp02.pok.ibm.com (9.56.224.85)
	by e8.ny.us.ibm.com (192.168.1.108) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
	Fri, 24 Feb 2012 14:34:32 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 51B796E8061
	for <akpm@linux-foundation.org>; Fri, 24 Feb 2012 14:34:31 -0500 (EST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q1OJYSjY323006
	for <akpm@linux-foundation.org>; Fri, 24 Feb 2012 14:34:29 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q1OJY1eQ017076
	for <akpm@linux-foundation.org>; Fri, 24 Feb 2012 12:34:02 -0700
Received: from arkanoid.localdomain (dyn9050020227.mts.ibm.com [9.50.20.227] (may be forged))
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id q1OJY1Gb016854;
	Fri, 24 Feb 2012 12:34:01 -0700
Received: by arkanoid.localdomain (Postfix, from userid 1000)
	id 5C2AEF2A10; Fri, 24 Feb 2012 11:33:58 -0800 (PST)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, Anton Blanchard <anton@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org
Subject: sparsemem/bootmem: catch greater than section size allocations
Date: Fri, 24 Feb 2012 11:33:58 -0800
Message-Id: <1330112038-18951-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022419-9360-0000-0000-000003F27ADE

While testing AMS (Active Memory Sharing) / CMO (Cooperative Memory
Overcommit) on powerpc, we tripped the following:

kernel BUG at mm/bootmem.c:483!
cpu 0x0: Vector: 700 (Program Check) at [c000000000c03940]
    pc: c000000000a62bd8: .alloc_bootmem_core+0x90/0x39c
    lr: c000000000a64bcc: .sparse_early_usemaps_alloc_node+0x84/0x29c
    sp: c000000000c03bc0
   msr: 8000000000021032
  current = 0xc000000000b0cce0
  paca    = 0xc000000001d80000
    pid   = 0, comm = swapper
kernel BUG at mm/bootmem.c:483!
enter ? for help
[c000000000c03c80] c000000000a64bcc
.sparse_early_usemaps_alloc_node+0x84/0x29c
[c000000000c03d50] c000000000a64f10 .sparse_init+0x12c/0x28c
[c000000000c03e20] c000000000a474f4 .setup_arch+0x20c/0x294
[c000000000c03ee0] c000000000a4079c .start_kernel+0xb4/0x460
[c000000000c03f90] c000000000009670 .start_here_common+0x1c/0x2c

This is

        BUG_ON(limit && goal + size > limit);

and after some debugging, it seems that

	goal = 0x7ffff000000
	limit = 0x80000000000

and sparse_early_usemaps_alloc_node ->
sparse_early_usemaps_alloc_pgdat_section -> alloc_bootmem_section calls

	return alloc_bootmem_section(usemap_size() * count, section_nr);

This is on a system with 8TB available via the AMS pool, and as a quirk
of AMS in firmware, all of that memory shows up in node 0. So, we end up
with an allocation that will fail the goal/limit constraints. In theory,
we could "fall-back" to alloc_bootmem_node() in
sparse_early_usemaps_alloc_node(), but since we actually have HOTREMOVE
defined, we'll BUG_ON() instead. A simple solution appears to be to
disable the limit check if the size of the allocation in
alloc_bootmem_secition exceeds the section size.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org
Cc: linuxppc-dev@lists.ozlabs.org
---
 include/linux/mmzone.h |    2 ++
 mm/bootmem.c           |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 650ba2f..4176834 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -967,6 +967,8 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
  * PA_SECTION_SHIFT		physical address to/from section number
  * PFN_SECTION_SHIFT		pfn to/from section number
  */
+#define BYTES_PER_SECTION	(1UL << SECTION_SIZE_BITS)
+
 #define SECTIONS_SHIFT		(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
 
 #define PA_SECTION_SHIFT	(SECTION_SIZE_BITS)
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 668e94d..5cbbc76 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -770,7 +770,10 @@ void * __init alloc_bootmem_section(unsigned long size,
 
 	pfn = section_nr_to_pfn(section_nr);
 	goal = pfn << PAGE_SHIFT;
-	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+	if (size > BYTES_PER_SECTION)
+		limit = 0;
+	else
+		limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
 	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
-- 
1.7.5.4
Subject: Subject: sparsemem/bootmem: catch greater than section size allocations

Patches currently in -mm which might be from nacc@us.ibm.com are

sparsemem-bootmem-catch-greater-than-section-size-allocations.patch

