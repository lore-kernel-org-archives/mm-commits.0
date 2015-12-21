From: akpm@linux-foundation.org
Subject: + x86-mm-support-arch_mmap_rnd_bits-v7.patch added to -mm tree
Date: Mon, 21 Dec 2015 14:45:48 -0800
Message-ID: <5678811c.xttV82Tl+TwuJTSM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbLUWpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2015 17:45:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-support-arch_mmap_rnd_bits-v7.txt
has been added to the -mm tree.  Its filename is
     x86-mm-support-arch_mmap_rnd_bits-v7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-support-arch_mmap_rnd_bits-v7.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-support-arch_mmap_rnd_bits-v7.patch

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
Subject: x86-mm-support-arch_mmap_rnd_bits-v7.txt

x86: mm: support ARCH_MMAP_RND_BITS.

Signed-off-by: Daniel Cashman <dcashman@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig   |    4 ++--
 arch/x86/mm/mmap.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/Kconfig~x86-mm-support-arch_mmap_rnd_bits-v7 arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mm-support-arch_mmap_rnd_bits-v7
+++ a/arch/x86/Kconfig
@@ -186,8 +186,8 @@ config MMU
 	def_bool y
 
 config ARCH_MMAP_RND_BITS_MIN
-       default 28 if 64BIT
-       default 8
+	default 28 if 64BIT
+	default 8
 
 config ARCH_MMAP_RND_BITS_MAX
 	default 32 if 64BIT
diff -puN arch/x86/mm/mmap.c~x86-mm-support-arch_mmap_rnd_bits-v7 arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~x86-mm-support-arch_mmap_rnd_bits-v7
+++ a/arch/x86/mm/mmap.c
@@ -71,12 +71,12 @@ unsigned long arch_mmap_rnd(void)
 
 	if (mmap_is_ia32())
 #ifdef CONFIG_COMPAT
-		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_compat_bits);
+		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_compat_bits) - 1);
 #else
-		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_bits);
+		rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_bits) - 1);
 #endif
 	else
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
x86-mm-support-arch_mmap_rnd_bits-v7.patch

