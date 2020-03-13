From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-1.patch added to
 -mm tree
Date: Thu, 12 Mar 2020 20:13:24 -0700
Message-ID: <20200313031324.2sccoJeLk%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCMDNZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 23:13:25 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nds32: linker script: add SOFTIRQENTRY_TEXT
has been added to the -mm tree.  Its filename is
     kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-1.patch
kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc-fix-2.patch
