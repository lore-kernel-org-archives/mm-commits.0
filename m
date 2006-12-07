From: akpm@osdl.org
Subject: - enables-booting-a-numa-system-where-some-nodes-have-no.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:26 -0800
Message-ID: <200612072257.kB7MvQc8029278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163637AbWLGW6Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krafft@de.ibm.com, apw@shadowen.org, clameter@engr.sgi.com, mbligh@google.com, mm-commits@vger.kernel.org


The patch titled
     enable booting a NUMA system where some nodes have no memory
has been removed from the -mm tree.  Its filename was
     enables-booting-a-numa-system-where-some-nodes-have-no.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: enable booting a NUMA system where some nodes have no memory
From: Christian Krafft <krafft@de.ibm.com>

When booting a NUMA system with nodes that have no memory (eg by limiting
memory), bootmem_alloc_core tried to find pages in an uninitialized
bootmem_map.  This caused a null pointer access.  This fix adds a check, so
that NULL is returned.  That will enable the caller (bootmem_alloc_nopanic)
to alloc memory on other without a panic.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Martin Bligh <mbligh@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/bootmem.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/bootmem.c~enables-booting-a-numa-system-where-some-nodes-have-no mm/bootmem.c
--- a/mm/bootmem.c~enables-booting-a-numa-system-where-some-nodes-have-no
+++ a/mm/bootmem.c
@@ -196,6 +196,10 @@ __alloc_bootmem_core(struct bootmem_data
 	if (limit && bdata->node_boot_start >= limit)
 		return NULL;
 
+	/* on nodes without memory - bootmem_map is NULL */
+	if (!bdata->node_bootmem_map)
+		return NULL;
+
 	end_pfn = bdata->node_low_pfn;
 	limit = PFN_DOWN(limit);
 	if (limit && end_pfn > limit)
_

Patches currently in -mm which might be from krafft@de.ibm.com are

origin.patch

