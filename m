From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch removed from -mm
 tree
Date: Fri, 04 Dec 2015 15:14:47 -0800
Message-ID: <56621e67.5JHqgGLqz2q3J2Kv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbbLDXOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:14:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch

This patch was dropped because it was folded into mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch

------------------------------------------------------
From: Daniel Cashman <dcashman@android.com>
Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5

Signed-off-by: Daniel Cashman <dcashman@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig    |    6 +++---
 kernel/sysctl.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/Kconfig~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5 arch/Kconfig
--- a/arch/Kconfig~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5
+++ a/arch/Kconfig
@@ -516,7 +516,7 @@ config HAVE_ARCH_MMAP_RND_BITS
 	help
 	  An arch should select this symbol if it supports setting a variable
 	  number of bits for use in establishing the base address for mmap
-	  allocations and provides values for both:
+	  allocations, has MMU enabled and provides values for both:
 	  - ARCH_MMAP_RND_BITS_MIN
 	  - ARCH_MMAP_RND_BITS_MAX
 
@@ -549,8 +549,8 @@ config HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	help
 	  An arch should select this symbol if it supports running applications
 	  in compatibility mode, supports setting a variable number of bits for
-	  use in establishing the base address for mmap allocations, and
-	  provides values for both:
+	  use in establishing the base address for mmap allocations, has MMU
+	  enabled and provides values for both:
 	  - ARCH_MMAP_RND_COMPAT_BITS_MIN
 	  - ARCH_MMAP_RND_COMPAT_BITS_MAX
 
diff -puN kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5 kernel/sysctl.c
--- a/kernel/sysctl.c~mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5
+++ a/kernel/sysctl.c
@@ -1575,8 +1575,8 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(mmap_rnd_bits),
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *) &mmap_rnd_bits_min,
-		.extra2		= (void *) &mmap_rnd_bits_max,
+		.extra1		= &mmap_rnd_bits_min,
+		.extra2		= &mmap_rnd_bits_max,
 	},
 #endif
 #ifdef CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS
@@ -1586,8 +1586,8 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(mmap_rnd_compat_bits),
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *) &mmap_rnd_compat_bits_min,
-		.extra2		= (void *) &mmap_rnd_compat_bits_max,
+		.extra1		= &mmap_rnd_compat_bits_min,
+		.extra2		= &mmap_rnd_compat_bits_max,
 	},
 #endif
 	{ }
_

Patches currently in -mm which might be from dcashman@android.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
arm-mm-support-arch_mmap_rnd_bits-v5.patch
arm64-mm-support-arch_mmap_rnd_bits-v4.patch
arm64-mm-support-arch_mmap_rnd_bits-v5.patch
x86-mm-support-arch_mmap_rnd_bits-v5.patch

