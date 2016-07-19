From: akpm@linux-foundation.org
Subject: [merged]
 revert-scripts-gdb-add-documentation-example-for-radix-tree.patch removed
 from -mm tree
Date: Tue, 19 Jul 2016 11:10:14 -0700
Message-ID: <578e6d06.vRN2wRonp2eE8h++%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbcGSSKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 14:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran@ksquared.org.ukkieran@ksquared.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "scripts/gdb: add documentation example for radix tree"
has been removed from the -mm tree.  Its filename was
     revert-scripts-gdb-add-documentation-example-for-radix-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kieran Bingham <kieran@ksquared.org.uk>
Subject: Revert "scripts/gdb: add documentation example for radix tree"

This reverts commit 9b5580359a84 ("scripts/gdb: add documentation
example for radix tree")

The python implementation of radix tree was merged at the same time as a
refactoring of the radix tree implementation and doesn't work. The
feature is being reverted, thus we revert the documentation as well.

Link: http://lkml.kernel.org/r/1467127337-11135-7-git-send-email-kieran@bingham.xyz
Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gdb-kernel-debugging.txt |   21 ---------------------
 1 file changed, 21 deletions(-)

diff -puN Documentation/gdb-kernel-debugging.txt~revert-scripts-gdb-add-documentation-example-for-radix-tree Documentation/gdb-kernel-debugging.txt
--- a/Documentation/gdb-kernel-debugging.txt~revert-scripts-gdb-add-documentation-example-for-radix-tree
+++ a/Documentation/gdb-kernel-debugging.txt
@@ -139,27 +139,6 @@ Examples of using the Linux-provided gdb
       start_comm = "swapper/2\000\000\000\000\000\000"
     }
 
- o Dig into a radix tree data structure, such as the IRQ descriptors:
-    (gdb) print (struct irq_desc)$lx_radix_tree_lookup(irq_desc_tree, 18)
-    $6 = {
-      irq_common_data = {
-        state_use_accessors = 67584,
-        handler_data = 0x0 <__vectors_start>,
-        msi_desc = 0x0 <__vectors_start>,
-        affinity = {{
-            bits = {65535}
-          }}
-      },
-      irq_data = {
-        mask = 0,
-        irq = 18,
-        hwirq = 27,
-        common = 0xee803d80,
-        chip = 0xc0eb0854 <gic_data>,
-        domain = 0xee808000,
-        parent_data = 0x0 <__vectors_start>,
-        chip_data = 0xc0eb0854 <gic_data>
-      } <... trimmed ...>
 
 List of commands and functions
 ------------------------------
_

Patches currently in -mm which might be from kieran@ksquared.org.uk are


