From: akpm@linux-foundation.org
Subject: [merged]
 lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch
 removed from -mm tree
Date: Wed, 27 Nov 2013 12:26:35 -0800
Message-ID: <5296557b.RvDu/DZOqh91MnyC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3K0U0h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 15:26:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, jwboyer@fedoraproject.org, hpa@zytor.com, jwboyer@redhat.com

Subject: [merged] lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch removed from -mm tree
To: jwboyer@redhat.com,hpa@zytor.com,jwboyer@fedoraproject.org,mingo@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 12:26:35 -0800


The patch titled
     Subject: lib/cpumask: make CPUMASK_OFFSTACK usable without debug dependency
has been removed from the -mm tree.  Its filename was
     lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Boyer <jwboyer@redhat.com>
Subject: lib/cpumask: make CPUMASK_OFFSTACK usable without debug dependency

When CPUMASK_OFFSTACK was added in 2008, it was dependent upon
DEBUG_PER_CPU_MAPS being enabled, or an architecture could select it.  The
debug dependency adds additional overhead that isn't required for
operation of the feature, and we need CPUMASK_OFFSTACK to increase the
NR_CPUS value beyond 512 on x86.  We drop the current dependency and make
sure SMP is set.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig~lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency lib/Kconfig
--- a/lib/Kconfig~lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency
+++ a/lib/Kconfig
@@ -349,7 +349,8 @@ config CHECK_SIGNATURE
 	bool
 
 config CPUMASK_OFFSTACK
-	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	bool "Force CPU masks off stack"
+	depends on SMP
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
_

Patches currently in -mm which might be from jwboyer@redhat.com are

linux-next.patch

