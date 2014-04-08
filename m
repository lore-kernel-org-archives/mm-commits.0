From: akpm@linux-foundation.org
Subject: [merged] asm-systemh-clean-asm-systemh-from-docs.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:40:17 -0700
Message-ID: <53446cc1.Hr+3niQtvY7Nk85/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHVkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@redhat.com, arnd@arndb.de, dhowells@redhat.com

Subject: [merged] asm-systemh-clean-asm-systemh-from-docs.patch removed from -mm tree
To: dhowells@redhat.com,arnd@arndb.de,mingo@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:40:17 -0700


The patch titled
     Subject: asm/system.h: clean asm/system.h from docs
has been removed from the -mm tree.  Its filename was
     asm-systemh-clean-asm-systemh-from-docs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
