From: akpm@linux-foundation.org
Subject: + x86-srat-use-numa_no_node.patch added to -mm tree
Date: Fri, 13 Sep 2013 15:33:58 -0700
Message-ID: <523392d6.TNC5gNKqlywvdb1a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3IMWd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 18:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, rientjes@google.com, mingo@redhat.com, hpa@zytor.com, wujianguo@huawei.com

Subject: + x86-srat-use-numa_no_node.patch added to -mm tree
To: wujianguo@huawei.com,hpa@zytor.com,mingo@redhat.com,rientjes@google.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 15:33:58 -0700


The patch titled
     Subject: x86/srat: use NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     x86-srat-use-numa_no_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-srat-use-numa_no_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-srat-use-numa_no_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: x86/srat: use NUMA_NO_NODE

setup_node() return NUMA_NO_NODE or valid node id(>=0), So use more
appropriate "if (node == NUMA_NO_NODE)" instead of "if (node < 0)"

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/srat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/srat.c~x86-srat-use-numa_no_node arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~x86-srat-use-numa_no_node
+++ a/arch/x86/mm/srat.c
@@ -76,7 +76,7 @@ acpi_numa_x2apic_affinity_init(struct ac
 		return;
 	}
 	node = setup_node(pxm);
-	if (node < 0) {
+	if (node == NUMA_NO_NODE) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
@@ -112,7 +112,7 @@ acpi_numa_processor_affinity_init(struct
 	if (acpi_srat_revision >= 2)
 		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node = setup_node(pxm);
-	if (node < 0) {
+	if (node == NUMA_NO_NODE) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
@@ -166,7 +166,7 @@ acpi_numa_memory_affinity_init(struct ac
 		pxm &= 0xff;
 
 	node = setup_node(pxm);
-	if (node < 0) {
+	if (node == NUMA_NO_NODE) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
 		goto out_err_bad_srat;
 	}
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch
mm-vmalloc-use-numa_no_node.patch
mm-acpi-use-numa_no_node.patch
x86-srat-use-numa_no_node.patch

