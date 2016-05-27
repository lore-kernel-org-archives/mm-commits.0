From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-add-documentation-example-for-radix-tree.patch removed from -mm tree
Date: Fri, 27 May 2016 11:44:20 -0700
Message-ID: <57489584.hKdzlragwBEh5wYi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbcE0SoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:44:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran.bingham@linaro.org, corbet@lwn.net, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add documentation example for radix tree
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-documentation-example-for-radix-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kieran Bingham <kieran.bingham@linaro.org>
Subject: scripts/gdb: add documentation example for radix tree

Provide a worked example for utilising the lx_radix_tree_lookup function

Link: http://lkml.kernel.org/r/e786008ac5aec4b84198812805b326d718bdeb4b.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gdb-kernel-debugging.txt |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN Documentation/gdb-kernel-debugging.txt~scripts-gdb-add-documentation-example-for-radix-tree Documentation/gdb-kernel-debugging.txt
--- a/Documentation/gdb-kernel-debugging.txt~scripts-gdb-add-documentation-example-for-radix-tree
+++ a/Documentation/gdb-kernel-debugging.txt
@@ -139,6 +139,27 @@ Examples of using the Linux-provided gdb
       start_comm = "swapper/2\000\000\000\000\000\000"
     }
 
+ o Dig into a radix tree data structure, such as the IRQ descriptors:
+    (gdb) print (struct irq_desc)$lx_radix_tree_lookup(irq_desc_tree, 18)
+    $6 = {
+      irq_common_data = {
+        state_use_accessors = 67584,
+        handler_data = 0x0 <__vectors_start>,
+        msi_desc = 0x0 <__vectors_start>,
+        affinity = {{
+            bits = {65535}
+          }}
+      },
+      irq_data = {
+        mask = 0,
+        irq = 18,
+        hwirq = 27,
+        common = 0xee803d80,
+        chip = 0xc0eb0854 <gic_data>,
+        domain = 0xee808000,
+        parent_data = 0x0 <__vectors_start>,
+        chip_data = 0xc0eb0854 <gic_data>
+      } <... trimmed ...>
 
 List of commands and functions
 ------------------------------
_

Patches currently in -mm which might be from kieran.bingham@linaro.org are


