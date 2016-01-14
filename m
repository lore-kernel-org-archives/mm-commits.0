From: akpm@linux-foundation.org
Subject: [folded-merged] arm-mm-support-arch_mmap_rnd_bits-v7.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:24:15 -0800
Message-ID: <5698200f.i/kfl9h6ngMKw6ip%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbcANWYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:24:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mm: support ARCH_MMAP_RND_BITS
has been removed from the -mm tree.  Its filename was
     arm-mm-support-arch_mmap_rnd_bits-v7.patch

This patch was dropped because it was folded into arm-mm-support-arch_mmap_rnd_bits.patch

------------------------------------------------------
From: Daniel Cashman <dcashman@google.com>
Subject: arm: mm: support ARCH_MMAP_RND_BITS

changed random bit-grabbing to explicit '&' rather than '%'

Signed-off-by: Daniel Cashman <dcashman@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mm/mmap.c~arm-mm-support-arch_mmap_rnd_bits-v7 arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~arm-mm-support-arch_mmap_rnd_bits-v7
+++ a/arch/arm/mm/mmap.c
@@ -173,7 +173,7 @@ unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
-	rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_bits);
+	rnd = (unsigned long)get_random_int() & ((1 << mmap_rnd_bits) - 1);
 
 	return rnd << PAGE_SHIFT;
 }
_

Patches currently in -mm which might be from dcashman@google.com are

mm-mmap-add-new-proc-tunable-for-mmap_base-aslr.patch
arm-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits-v6.patch
arm64-mm-support-arch_mmap_rnd_bits-v7.patch
x86-mm-support-arch_mmap_rnd_bits.patch
x86-mm-support-arch_mmap_rnd_bits-v7.patch

