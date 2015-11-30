From: akpm@linux-foundation.org
Subject: + arm64-mm-support-arch_mmap_rnd_bits-v4.patch added to -mm tree
Date: Mon, 30 Nov 2015 15:58:24 -0800
Message-ID: <565ce2a0.+xIQADbxp8IqHBHX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbbK3X6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 18:58:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, catalin.marinas@arm.com, linux@arm.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-mm-support-arch_mmap_rnd_bits-v4
has been added to the -mm tree.  Its filename is
     arm64-mm-support-arch_mmap_rnd_bits-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-support-arch_mmap_rnd_bits-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-support-arch_mmap_rnd_bits-v4.patch

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
Subject: arm64-mm-support-arch_mmap_rnd_bits-v4

arm64: arch_mmap_rnd() uses STACK_RND_MASK to generate the
random offset for the mmap base address.  This value represents a
compromise between increased ASLR effectiveness and avoiding
address-space fragmentation. Replace it with a Kconfig option, which
is sensibly bounded, so that platform developers may choose where to
place this compromise. Keep default values as new minimums.

Signed-off-by: Daniel Cashman <dcashman@android.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig   |   20 ++++++++++++++------
 arch/arm64/mm/mmap.c |    2 ++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff -puN arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits-v4 arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits-v4
+++ a/arch/arm64/Kconfig
@@ -108,20 +108,28 @@ config MMU
 
 config ARCH_MMAP_RND_BITS_MIN
        default 15 if ARM64_64K_PAGES
+       default 17 if ARM64_16K_PAGES
        default 19
 
 config ARCH_MMAP_RND_BITS_MAX
-       default 20 if ARM64_64K_PAGES && ARCH_VA_BITS=39
-       default 24 if ARCH_VA_BITS=39
-       default 23 if ARM64_64K_PAGES && ARCH_VA_BITS=42
-       default 27 if ARCH_VA_BITS=42
-       default 29 if ARM64_64K_PAGES && ARCH_VA_BITS=48
-       default 33 if ARCH_VA_BITS=48
+       default 19 if ARM64_VA_BITS=36
+       default 20 if ARM64_64K_PAGES && ARM64_VA_BITS=39
+       default 22 if ARM64_16K_PAGES && ARM64_VA_BITS=39
+       default 24 if ARM64_VA_BITS=39
+       default 23 if ARM64_64K_PAGES && ARM64_VA_BITS=42
+       default 25 if ARM64_16K_PAGES && ARM64_VA_BITS=42
+       default 27 if ARM64_VA_BITS=42
+       default 30 if ARM64_VA_BITS=47
+       default 29 if ARM64_64K_PAGES && ARM64_VA_BITS=48
+       default 31 if ARM64_16K_PAGES && ARM64_VA_BITS=48
+       default 33 if ARM64_VA_BITS=48
        default 15 if ARM64_64K_PAGES
+       default 17 if ARM64_16K_PAGES
        default 19
 
 config ARCH_MMAP_RND_COMPAT_BITS_MIN
        default 7 if ARM64_64K_PAGES
+       default 9 if ARM64_16K_PAGES
        default 11
 
 config ARCH_MMAP_RND_COMPAT_BITS_MAX
diff -puN arch/arm64/mm/mmap.c~arm64-mm-support-arch_mmap_rnd_bits-v4 arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~arm64-mm-support-arch_mmap_rnd_bits-v4
+++ a/arch/arm64/mm/mmap.c
@@ -51,9 +51,11 @@ unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
+ifdef CONFIG_COMPAT
 	if (test_thread_flag(TIF_32BIT))
 		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_compat_bits);
 	else
+#endif
 		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_bits);
 	return rnd << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from dcashman@android.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v4.patch
arm64-mm-support-arch_mmap_rnd_bits-v4.patch

