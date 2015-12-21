From: akpm@linux-foundation.org
Subject: + arm64-mm-support-arch_mmap_rnd_bits-v7.patch added to -mm tree
Date: Mon, 21 Dec 2015 14:40:01 -0800
Message-ID: <56787fc1.AH3uXPLYskFxyEMg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbbLUWkC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2015 17:40:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-mm-support-arch_mmap_rnd_bits-v7
has been added to the -mm tree.  Its filename is
     arm64-mm-support-arch_mmap_rnd_bits-v7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-support-arch_mmap_rnd_bits-v7.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-support-arch_mmap_rnd_bits-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Cashman <dcashman@google.com>
Subject: arm64-mm-support-arch_mmap_rnd_bits-v7

* changed random bit-grabbing to explicit '&' rather than '%'
* removed unsupported ARM64 combinations for CONFIG_ARCH_MMAP_RND_BITS_MAX

Signed-off-by: Daniel Cashman <dcashman@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig   |   12 ++++--------
 arch/arm64/mm/mmap.c |    4 ++--
 2 files changed, 6 insertions(+), 10 deletions(-)

diff -puN arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits-v7 arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits-v7
+++ a/arch/arm64/Kconfig
@@ -115,18 +115,14 @@ config ARCH_MMAP_RND_BITS_MIN
 #  VA_BITS - PAGE_SHIFT - 3
 config ARCH_MMAP_RND_BITS_MAX
        default 19 if ARM64_VA_BITS=36
-       default 20 if ARM64_64K_PAGES && ARM64_VA_BITS=39
-       default 22 if ARM64_16K_PAGES && ARM64_VA_BITS=39
        default 24 if ARM64_VA_BITS=39
-       default 23 if ARM64_64K_PAGES && ARM64_VA_BITS=42
-       default 25 if ARM64_16K_PAGES && ARM64_VA_BITS=42
        default 27 if ARM64_VA_BITS=42
        default 30 if ARM64_VA_BITS=47
-       default 29 if ARM64_64K_PAGES && ARM64_VA_BITS=48
-       default 31 if ARM64_16K_PAGES && ARM64_VA_BITS=48
+       default 29 if ARM64_VA_BITS=48 && ARM64_64K_PAGES
+       default 31 if ARM64_VA_BITS=48 && ARM64_16K_PAGES
        default 33 if ARM64_VA_BITS=48
-       default 15 if ARM64_64K_PAGES
-       default 17 if ARM64_16K_PAGES
+       default 14 if ARM64_64K_PAGES
+       default 16 if ARM64_16K_PAGES
        default 18
 
 config ARCH_MMAP_RND_COMPAT_BITS_MIN
diff -puN arch/arm64/mm/mmap.c~arm64-mm-support-arch_mmap_rnd_bits-v7 arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~arm64-mm-support-arch_mmap_rnd_bits-v7
+++ a/arch/arm64/mm/mmap.c
@@ -53,10 +53,10 @@ unsigned long arch_mmap_rnd(void)
 
 #ifdef CONFIG_COMPAT
 	if (test_thread_flag(TIF_32BIT))
-		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_compat_bits);
+		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_compat_bits) - 1);
 	else
 #endif
-		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_bits);
+		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_bits) - 1);
 	return rnd << PAGE_SHIFT;
 }
 
_

Patches currently in -mm which might be from dcashman@google.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
arm-mm-support-arch_mmap_rnd_bits.patch
arm-mm-support-arch_mmap_rnd_bits-v7.patch
arm64-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits-v6.patch
arm64-mm-support-arch_mmap_rnd_bits-v7.patch
x86-mm-support-arch_mmap_rnd_bits.patch

