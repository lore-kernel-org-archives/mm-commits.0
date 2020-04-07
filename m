From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-2.patch removed
 from -mm tree
Date: Mon, 06 Apr 2020 18:51:26 -0700
Message-ID: <20200407015126.fZfhqN_c5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgDGBv1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: add IRQENTRY_TEXT and SOFTIRQENTRY_TEXT to linker script
has been removed from the -mm tree.  Its filename was
     kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-2.patch

This patch was dropped because it was folded into kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch

------------------------------------------------------
From: glider@google.com
Subject: ia64: add IRQENTRY_TEXT and SOFTIRQENTRY_TEXT to linker script

This is needed to fix linker errors caused by lib/stackdepot.c
referencing __{soft,}irqentry_text_{start,end}.

Link: http://lkml.kernel.org/r/20200311121124.243352-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/ia64/kernel/vmlinux.lds.S~kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-2
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -54,6 +54,8 @@ SECTIONS {
 		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.gnu.linkonce.t*)
 	}
 
_

Patches currently in -mm which might be from glider@google.com are

stackdepot-check-depot_index-before-accessing-the-stack-slab.patch
stackdepot-build-with-fno-builtin.patch
kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch
