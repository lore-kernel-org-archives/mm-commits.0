From: akpm@linux-foundation.org
Subject: +
 revert-scripts-gdb-add-documentation-example-for-radix-tree.patch added to
 -mm tree
Date: Mon, 11 Jul 2016 12:51:55 -0700
Message-ID: <5783f8db.iArsu5uq3MnRSTc7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbcGKTv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 15:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kieran@ksquared.org.ukkieran@ksquared.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "scripts/gdb: add documentation example for radix tree"
has been added to the -mm tree.  Its filename is
     revert-scripts-gdb-add-documentation-example-for-radix-tree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-scripts-gdb-add-documentation-example-for-radix-tree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-scripts-gdb-add-documentation-example-for-radix-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-silence-nothing-to-do-message.patch
scripts-gdb-rebuild-constantspy-on-dependancy-change.patch
revert-scripts-gdb-add-a-radix-tree-parser.patch
revert-scripts-gdb-add-documentation-example-for-radix-tree.patch

