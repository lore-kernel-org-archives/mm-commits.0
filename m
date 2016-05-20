From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch removed
 from -mm tree
Date: Fri, 20 May 2016 16:46:31 -0700
Message-ID: <573fa1d7.4J5H8YWjnh1fiKFd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcETXqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@horizon.com, zhaoxiu.zeng@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix
has been removed from the -mm tree.  Its filename was
     lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

This patch was dropped because it was folded into lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix

avoid #defining a CONFIG_ variable

Cc: George Spelvin <linux@horizon.com>
Cc: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/cpu-features.h |    2 +-
 lib/gcd.c                            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/mips/include/asm/cpu-features.h~lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix arch/mips/include/asm/cpu-features.h
--- a/arch/mips/include/asm/cpu-features.h~lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix
+++ a/arch/mips/include/asm/cpu-features.h
@@ -187,7 +187,7 @@
 	  (defined(cpu_has_mips64r1) && cpu_has_mips64r1) || \
 	  (defined(cpu_has_mips64r2) && cpu_has_mips64r2) || \
 	  (defined(cpu_has_mips64r6) && cpu_has_mips64r6))
-#define CONFIG_CPU_NO_EFFICIENT_FFS 1
+#define CPU_NO_EFFICIENT_FFS 1
 #endif
 
 #ifndef cpu_has_mips_1
diff -puN lib/gcd.c~lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix lib/gcd.c
--- a/lib/gcd.c~lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix
+++ a/lib/gcd.c
@@ -10,7 +10,7 @@
  * has decent hardware division.
  */
 
-#if !defined(CONFIG_CPU_NO_EFFICIENT_FFS)
+#if !defined(CONFIG_CPU_NO_EFFICIENT_FFS) && !defined(CPU_NO_EFFICIENT_FFS)
 
 /* If __ffs is available, the even/odd algorithm benchmarks slower. */
 unsigned long gcd(unsigned long a, unsigned long b)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean.patch

