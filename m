From: akpm@linux-foundation.org
Subject: [merged]
 kernel-spinlockc-add-default-arch__relax-definitions-for-generic_lockbreak.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:46:15 -0700
Message-ID: <52321a07.BOiMYITfwlOwld+7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab3ILTqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, schwidefsky@de.ibm.com, mingo@elte.hu, benh@kernel.crashing.org, will.deacon@arm.com

Subject: [merged] kernel-spinlockc-add-default-arch__relax-definitions-for-generic_lockbreak.patch removed from -mm tree
To: will.deacon@arm.com,benh@kernel.crashing.org,mingo@elte.hu,schwidefsky@de.ibm.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:46:15 -0700


The patch titled
     Subject: kernel/spinlock.c: add default arch_*_relax definitions for GENERIC_LOCKBREAK
has been removed from the -mm tree.  Its filename was
     kernel-spinlockc-add-default-arch__relax-definitions-for-generic_lockbreak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: kernel/spinlock.c: add default arch_*_relax definitions for GENERIC_LOCKBREAK

When running with GENERIC_LOCKBREAK=y, the locking implementations emit
calls to arch_{read,write,spin}_relax when spinning on a contended lock in
order to allow architectures to favour the CPU owning the lock if
possible.

In reality, everybody apart from PowerPC and S390 just does cpu_relax()
here, so make that the default behaviour and allow it to be overridden if
required.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/spinlock.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN kernel/spinlock.c~kernel-spinlockc-add-default-arch__relax-definitions-for-generic_lockbreak kernel/spinlock.c
--- a/kernel/spinlock.c~kernel-spinlockc-add-default-arch__relax-definitions-for-generic_lockbreak
+++ a/kernel/spinlock.c
@@ -34,6 +34,20 @@
 #else
 #define raw_read_can_lock(l)	read_can_lock(l)
 #define raw_write_can_lock(l)	write_can_lock(l)
+
+/*
+ * Some architectures can relax in favour of the CPU owning the lock.
+ */
+#ifndef arch_read_relax
+# define arch_read_relax(l)	cpu_relax()
+#endif
+#ifndef arch_write_relax
+# define arch_write_relax(l)	cpu_relax()
+#endif
+#ifndef arch_spin_relax
+# define arch_spin_relax(l)	cpu_relax()
+#endif
+
 /*
  * We build the __lock_function inlines here. They are too large for
  * inlining all over the place, but here is only one user per function
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch

