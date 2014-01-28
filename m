From: akpm@linux-foundation.org
Subject: [merged]
 arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch removed from
 -mm tree
Date: Tue, 28 Jan 2014 11:10:03 -0800
Message-ID: <52e8008b.SteA9J0dBe6fw30S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaA1TKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:10:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu, hpa@zytor.com, toshi.kani@hp.com

Subject: [merged] arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch removed from -mm tree
To: toshi.kani@hp.com,hpa@zytor.com,mingo@elte.hu,rientjes@google.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:10:03 -0800


The patch titled
     Subject: arch/x86/mm/srat.c: skip NUMA_NO_NODE while parsing SLIT
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: arch/x86/mm/srat.c: skip NUMA_NO_NODE while parsing SLIT

When ACPI SLIT table has an I/O locality (i.e.  a locality unique to an
I/O device), numa_set_distance() emits the warning message below.

 NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10

acpi_numa_slit_init() calls numa_set_distance() with pxm_to_node(), which
assumes that all localities have been parsed with SRAT previously.  SRAT
does not list I/O localities, where as SLIT lists all localities including
I/Os.  Hence, pxm_to_node() returns NUMA_NO_NODE (-1) for an I/O locality.
 I/O localities are not supported and are ignored today, but emitting such
warning message leads unnecessary confusion.

Change acpi_numa_slit_init() to avoid calling numa_set_distance() with
NUMA_NO_NODE.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/srat.c~arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit
+++ a/arch/x86/mm/srat.c
@@ -42,15 +42,25 @@ static __init inline int srat_disabled(v
 	return acpi_numa < 0;
 }
 
-/* Callback for SLIT parsing */
+/**
+ * Callback for SLIT parsing.  pxm_to_node() returns NUMA_NO_NODE for
+ * I/O localities since SRAT does not list them.  I/O localities are
+ * not supported at this point.
+ */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
 	int i, j;
 
-	for (i = 0; i < slit->locality_count; i++)
-		for (j = 0; j < slit->locality_count; j++)
+	for (i = 0; i < slit->locality_count; i++) {
+		if (pxm_to_node(i) == NUMA_NO_NODE)
+			continue;
+		for (j = 0; j < slit->locality_count; j++) {
+			if (pxm_to_node(j) == NUMA_NO_NODE)
+				continue;
 			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
 				slit->entry[slit->locality_count * i + j]);
+		}
+	}
 }
 
 /* Callback for Proximity Domain -> x2APIC mapping */
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
linux-next.patch

