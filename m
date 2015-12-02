From: akpm@linux-foundation.org
Subject: + mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch added
 to -mm tree
Date: Tue, 01 Dec 2015 16:24:51 -0800
Message-ID: <565e3a53.BXPRkxW5jSl7t6vG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbLBAYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:24:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5
has been added to the -mm tree.  Its filename is
     mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4.patch
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5.patch
arm-mm-support-arch_mmap_rnd_bits-v5.patch
arm64-mm-support-arch_mmap_rnd_bits-v4.patch
arm64-mm-support-arch_mmap_rnd_bits-v5.patch
x86-mm-support-arch_mmap_rnd_bits-v5.patch

