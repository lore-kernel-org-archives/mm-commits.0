From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-add-loglvl-to-show_trace-fix.patch added to -mm
 tree
Date: Mon, 11 May 2020 14:44:38 -0700
Message-ID: <20200511214438.2WCkWlfbM%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgEKVoj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 17:44:39 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dima@arista.com, mm-commits@vger.kernel.org, rppt@kernel.org


The patch titled
     Subject: xtensa-add-loglvl-to-show_trace-fix
has been added to the -mm tree.  Its filename is
     xtensa-add-loglvl-to-show_trace-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xtensa-add-loglvl-to-show_trace-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xtensa-add-loglvl-to-show_trace-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: xtensa-add-loglvl-to-show_trace-fix

build fix

Link: http://lkml.kernel.org/r/20200511194534.GA1018386@kernel.org
Cc: Dmitry Safonov <dima@arista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/kernel/traps.c~xtensa-add-loglvl-to-show_trace-fix
+++ a/arch/xtensa/kernel/traps.c
@@ -515,7 +515,7 @@ void show_stack(struct task_struct *task
 	print_hex_dump(KERN_INFO, " ", DUMP_PREFIX_NONE,
 		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
 		       sp, len, false);
-	show_trace(task, stack, KERN_INFO);
+	show_trace(task, sp, KERN_INFO);
 }
 
 DEFINE_SPINLOCK(die_lock);
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix.patch
xtensa-add-loglvl-to-show_trace-fix.patch
