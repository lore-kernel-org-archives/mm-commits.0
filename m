From: akpm@linux-foundation.org
Subject: [patch 60/84] scripts/gdb: add documentation example for radix
 tree
Date: Mon, 23 May 2016 16:25:10 -0700
Message-ID: <57439156.JooM0lSR81Yqs5ui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbcEWXZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kieran.bingham@linaro.org, corbet@lwn.net, jan.kiszka@siemens.com

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
