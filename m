From: akpm@linux-foundation.org
Subject: +
 arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch added to
 -mm tree
Date: Mon, 09 Dec 2013 14:43:17 -0800
Message-ID: <52a64785.hlmZCboEvAw5vPQQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3LIWnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 17:43:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu, hpa@zytor.com, toshi.kani@hp.com

Subject: + arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch added to -mm tree
To: toshi.kani@hp.com,hpa@zytor.com,mingo@elte.hu,rientjes@google.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 14:43:17 -0800


The patch titled
     Subject: arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix
has been added to the -mm tree.  Its filename is
     arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch

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
Subject: arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/srat.c~arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix
+++ a/arch/x86/mm/srat.c
@@ -42,7 +42,11 @@ static __init inline int srat_disabled(v
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
_

Patches currently in -mm which might be from toshi.kani@hp.com are

arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
linux-next.patch

