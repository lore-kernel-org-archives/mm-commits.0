From: akpm@linux-foundation.org
Subject: + arm64-mm-support-arch_mmap_rnd_bits-v6.patch added to -mm tree
Date: Fri, 11 Dec 2015 15:22:33 -0800
Message-ID: <566b5ab9.Q2iHXYp1Qt93nhdZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbbLKXWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Dec 2015 18:22:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-mm-support-arch_mmap_rnd_bits-v6
has been added to the -mm tree.  Its filename is
     arm64-mm-support-arch_mmap_rnd_bits-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-support-arch_mmap_rnd_bits-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-support-arch_mmap_rnd_bits-v6.patch

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
@@ -107,10 +107,12 @@ config MMU
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
@@ -125,7 +127,7 @@ config ARCH_MMAP_RND_BITS_MAX
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
arm64-mm-support-arch_mmap_rnd_bits-v6.patch
x86-mm-support-arch_mmap_rnd_bits.patch

