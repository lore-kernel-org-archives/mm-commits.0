From: akpm@linux-foundation.org
Subject: +
 lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch
 added to -mm tree
Date: Mon, 11 Nov 2013 15:02:54 -0800
Message-ID: <5281621e.1ZRv6JVTN8iK1t8X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KKXCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 18:02:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, jwboyer@fedoraproject.org, hpa@zytor.com, jwboyer@redhat.com

Subject: + lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch added to -mm tree
To: jwboyer@redhat.com,hpa@zytor.com,jwboyer@fedoraproject.org,mingo@redhat.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 15:02:54 -0800


The patch titled
     Subject: lib/cpumask: make CPUMASK_OFFSTACK usable without debug dependency
has been added to the -mm tree.  Its filename is
     lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-cpumask-make-cpumask_offstack-usable-without-debug-dependency.patch
linux-next.patch

