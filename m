From: akpm@linux-foundation.org
Subject: [folded-merged]
 arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch removed
 from -mm tree
Date: Tue, 21 Jan 2014 14:31:28 -0800
Message-ID: <52def540.hHA4jUHJiY4AK6l5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaAUWba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 17:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@elte.hu, hpa@zytor.com, toshi.kani@hp.com

Subject: [folded-merged] arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch removed from -mm tree
To: toshi.kani@hp.com,hpa@zytor.com,mingo@elte.hu,rientjes@google.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 14:31:28 -0800


The patch titled
     Subject: arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit-fix.patch

This patch was dropped because it was folded into arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch

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

origin.patch
arch-x86-mm-sratc-skip-numa_no_node-while-parsing-slit.patch

