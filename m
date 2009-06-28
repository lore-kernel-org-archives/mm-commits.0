From: akpm@linux-foundation.org
Subject: [to-be-updated] alpha-fix-2630-smp-build.patch removed from -mm tree
Date: Sat, 27 Jun 2009 18:07:45 -0700
Message-ID: <200906280107.n5S17jJN012261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbZF1BMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jun 2009 21:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: max@stro.at, ink@jurassic.park.msu.ru, rth@twiddle.net, stable@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     alpha: fix 2.6.30 smp build
has been removed from the -mm tree.  Its filename was
     alpha-fix-2630-smp-build.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fix 2.6.30 smp build
From: maximilian attems <max@stro.at>

In file included from include/linux/percpu.h:10,
                 from /usr/src/devel/arch/alpha/include/asm/local.h:4,
                 from include/linux/module.h:20,
                 from arch/alpha/kernel/srm_env.c:33:
arch/alpha/include/asm/percpu.h:100:1: error: "PER_CPU_ATTRIBUTES" redefined
arch/alpha/include/asm/percpu.h:52:1: error: this is the location of the previous definition

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/percpu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/percpu.h~alpha-fix-2630-smp-build arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h~alpha-fix-2630-smp-build
+++ a/arch/alpha/include/asm/percpu.h
@@ -95,8 +95,8 @@ extern unsigned long __per_cpu_offset[NR
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
 #define PER_CPU_FIRST_SECTION ""
 
-#endif
