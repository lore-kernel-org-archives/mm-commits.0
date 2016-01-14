From: akpm@linux-foundation.org
Subject: [folded-merged] arm64-mm-support-arch_mmap_rnd_bits-v6.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:24:42 -0800
Message-ID: <5698202a.4gRDREC97ihe1vq7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbcANWYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:24:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-mm-support-arch_mmap_rnd_bits-v6
has been removed from the -mm tree.  Its filename was
     arm64-mm-support-arch_mmap_rnd_bits-v6.patch

This patch was dropped because it was folded into arm64-mm-support-arch_mmap_rnd_bits.patch

------------------------------------------------------
From: Daniel Cashman <dcashman@google.com>
Subject: arm64-mm-support-arch_mmap_rnd_bits-v6

arm64: arch_mmap_rnd() uses STACK_RND_MASK to generate the
random offset for the mmap base address.  This value represents a
compromise between increased ASLR effectiveness and avoiding
address-space fragmentation. Replace it with a Kconfig option, which
is sensibly bounded, so that platform developers may choose where to
place this compromise. Keep default values as new minimums.

Signed-off-by: Daniel Cashman <dcashman@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits-v6 arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~arm64-mm-support-arch_mmap_rnd_bits-v6
+++ a/arch/arm64/Kconfig
@@ -51,8 +51,8 @@ config ARM64
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KASAN if SPARSEMEM_VMEMMAP && !(ARM64_16K_PAGES && ARM64_VA_BITS_48)
 	select HAVE_ARCH_KGDB
-	select HAVE_ARCH_MMAP_RND_BITS if MMU
-	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if MMU && COMPAT
+	select HAVE_ARCH_MMAP_RND_BITS
+	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_BPF_JIT
@@ -109,10 +109,12 @@ config MMU
 	def_bool y
 
 config ARCH_MMAP_RND_BITS_MIN
-       default 15 if ARM64_64K_PAGES
-       default 17 if ARM64_16K_PAGES
-       default 19
+       default 14 if ARM64_64K_PAGES
+       default 16 if ARM64_16K_PAGES
+       default 18
 
+# max bits determined by the following formula:
+#  VA_BITS - PAGE_SHIFT - 3
 config ARCH_MMAP_RND_BITS_MAX
        default 19 if ARM64_VA_BITS=36
        default 20 if ARM64_64K_PAGES && ARM64_VA_BITS=39
@@ -127,7 +129,7 @@ config ARCH_MMAP_RND_BITS_MAX
        default 33 if ARM64_VA_BITS=48
        default 15 if ARM64_64K_PAGES
        default 17 if ARM64_16K_PAGES
-       default 19
+       default 18
 
 config ARCH_MMAP_RND_COMPAT_BITS_MIN
        default 7 if ARM64_64K_PAGES
_

Patches currently in -mm which might be from dcashman@google.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
arm-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits-v7.patch
x86-mm-support-arch_mmap_rnd_bits.patch
x86-mm-support-arch_mmap_rnd_bits-v7.patch

