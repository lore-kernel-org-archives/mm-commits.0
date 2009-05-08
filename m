From: akpm@linux-foundation.org
Subject: + alpha-unbreak-percpu-again.patch added to -mm tree
Date: Fri, 08 May 2009 13:45:19 -0700
Message-ID: <200905082045.n48KjJOP013324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759769AbZEHUtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 16:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, akpm@linux-foundation.org, dhowells@redhat.com, ink@jurassic.park.msu.ru


The patch titled
     alpha: unbreak percpu again
has been added to the -mm tree.  Its filename is
     alpha-unbreak-percpu-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: unbreak percpu again
From: Tejun Heo <tj@kernel.org>

Commit 9b8de7479d0dbab1ed98b5b015d44232c9d3d08e ("FRV: Fix the section
attribute on UP DECLARE_PER_CPU()") cleaned up DECLARE/DEFINE_PER_CPU()
macros and in the process made alpha percpu.h include
include/asm-generic/percpu.h which breaks compilation due to duplicate
definitions.

Remove inclusion of generic asm helper file and define whatever necessary
in alpha header proper.

In the longer term, percpu definitions will be unified and all these
little subtlties will be removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/percpu.h |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/percpu.h~alpha-unbreak-percpu-again arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h~alpha-unbreak-percpu-again
+++ a/arch/alpha/include/asm/percpu.h
@@ -1,7 +1,9 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
+
 #include <linux/compiler.h>
 #include <linux/threads.h>
+#include <linux/percpu-defs.h>
 
 /*
  * Determine the real variable name from the name visible in the
@@ -73,6 +75,28 @@ extern unsigned long __per_cpu_offset[NR
 
 #endif /* SMP */
 
-#include <asm-generic/percpu.h>
+#ifdef CONFIG_SMP
+#define PER_CPU_BASE_SECTION ".data.percpu"
+#else
+#define PER_CPU_BASE_SECTION ".data"
+#endif
+
+#ifdef CONFIG_SMP
+
+#ifdef MODULE
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#else
+#define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
+#endif
+#define PER_CPU_FIRST_SECTION ".first"
+
+#else
+
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_FIRST_SECTION ""
+
+#endif
+
+#define PER_CPU_ATTRIBUTES
 
 #endif /* __ALPHA_PERCPU_H */
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
alpha-unbreak-percpu-again.patch

