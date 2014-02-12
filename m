From: akpm@linux-foundation.org
Subject: + asm-systemh-clean-asm-systemh-from-docs.patch added to -mm tree
Date: Wed, 12 Feb 2014 12:59:45 -0800
Message-ID: <52fbe0c1.QF5HU7q3LY22b4In%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBLU7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 15:59:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@redhat.com, arnd@arndb.de, dhowells@redhat.com

Subject: + asm-systemh-clean-asm-systemh-from-docs.patch added to -mm tree
To: dhowells@redhat.com,arnd@arndb.de,mingo@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 12:59:45 -0800


The patch titled
     Subject: asm/system.h: clean asm/system.h from docs
has been added to the -mm tree.  Its filename is
     asm-systemh-clean-asm-systemh-from-docs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-systemh-clean-asm-systemh-from-docs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-systemh-clean-asm-systemh-from-docs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: asm/system.h: clean asm/system.h from docs

Clean asm/system.h from docs as nothing should refer to that header anymore.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-hacking.tmpl |    2 +-
 Documentation/irqflags-tracing.txt        |    7 -------
 Documentation/scheduler/sched-arch.txt    |    2 +-
 3 files changed, 2 insertions(+), 9 deletions(-)

diff -puN Documentation/DocBook/kernel-hacking.tmpl~asm-systemh-clean-asm-systemh-from-docs Documentation/DocBook/kernel-hacking.tmpl
--- a/Documentation/DocBook/kernel-hacking.tmpl~asm-systemh-clean-asm-systemh-from-docs
+++ a/Documentation/DocBook/kernel-hacking.tmpl
@@ -671,7 +671,7 @@ printk(KERN_INFO "my ip: %pI4\n", &amp;i
 
   <sect1 id="routines-local-irqs">
    <title><function>local_irq_save()</function>/<function>local_irq_restore()</function>
-    <filename class="headerfile">include/asm/system.h</filename>
+    <filename class="headerfile">include/linux/irqflags.h</filename>
    </title>
 
    <para>
diff -puN Documentation/irqflags-tracing.txt~asm-systemh-clean-asm-systemh-from-docs Documentation/irqflags-tracing.txt
--- a/Documentation/irqflags-tracing.txt~asm-systemh-clean-asm-systemh-from-docs
+++ a/Documentation/irqflags-tracing.txt
@@ -22,13 +22,6 @@ rather straightforward and risk-free man
 Architectures that want to support this need to do a couple of
 code-organizational changes first:
 
-- move their irq-flags manipulation code from their asm/system.h header
-  to asm/irqflags.h
-
-- rename local_irq_disable()/etc to raw_local_irq_disable()/etc. so that
-  the linux/irqflags.h code can inject callbacks and can construct the
-  real local_irq_disable()/etc APIs.
-
 - add and enable TRACE_IRQFLAGS_SUPPORT in their arch level Kconfig file
 
 and then a couple of functional changes are needed as well to implement
diff -puN Documentation/scheduler/sched-arch.txt~asm-systemh-clean-asm-systemh-from-docs Documentation/scheduler/sched-arch.txt
--- a/Documentation/scheduler/sched-arch.txt~asm-systemh-clean-asm-systemh-from-docs
+++ a/Documentation/scheduler/sched-arch.txt
@@ -8,7 +8,7 @@ Context switch
 By default, the switch_to arch function is called with the runqueue
 locked. This is usually not a problem unless switch_to may need to
 take the runqueue lock. This is usually due to a wake up operation in
-the context switch. See arch/ia64/include/asm/system.h for an example.
+the context switch. See arch/ia64/include/asm/switch_to.h for an example.
 
 To request the scheduler call switch_to with the runqueue unlocked,
 you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
asm-systemh-clean-asm-systemh-from-docs.patch
asm-systemh-sparc-sparc_cpu_model-isnt-in-asm-systemh-any-more.patch
asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch
asm-systemh-arm-delete-asm-systemh.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

