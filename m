From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-1.patch removed
 from -mm tree
Date: Mon, 06 Apr 2020 18:51:23 -0700
Message-ID: <20200407015123.FBGRCfkwn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgDGBvZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nds32: linker script: add SOFTIRQENTRY_TEXT
has been removed from the -mm tree.  Its filename was
     kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-1.patch

This patch was dropped because it was folded into kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch

------------------------------------------------------
From: glider@google.com
Subject: nds32: linker script: add SOFTIRQENTRY_TEXT

This section is required for lib/stackdepot.c to link, as
filter_irq_stacks() accesses __softirqentry_text_start and
__softirqentry_text_end.

Link: http://lkml.kernel.org/r/20200311121002.241430-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/nds32/kernel/vmlinux.lds.S~kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-1
+++ a/arch/nds32/kernel/vmlinux.lds.S
@@ -47,6 +47,7 @@ SECTIONS
 		LOCK_TEXT
 		KPROBES_TEXT
 		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.fixup)
 	}
 
_

Patches currently in -mm which might be from glider@google.com are

stackdepot-check-depot_index-before-accessing-the-stack-slab.patch
stackdepot-build-with-fno-builtin.patch
kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch
kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-2.patch
