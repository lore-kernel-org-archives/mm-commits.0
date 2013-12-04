From: akpm@linux-foundation.org
Subject: + arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
 added to -mm tree
Date: Wed, 04 Dec 2013 14:26:35 -0800
Message-ID: <529fac1b.rjzmaEQdPVYHW0v3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3LDW0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 17:26:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, toshi.kani@hp.com

Subject: + arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch added to -mm tree
To: toshi.kani@hp.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 14:26:35 -0800


The patch titled
     Subject: arch/x86/mm/srat.c: skip NUMA_NO_NODE while parsing SLIT
has been added to the -mm tree.  Its filename is
     arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/srat.c~arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit
+++ a/arch/x86/mm/srat.c
@@ -47,10 +47,16 @@ void __init acpi_numa_slit_init(struct a
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

arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
linux-next.patch

