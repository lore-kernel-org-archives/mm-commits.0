From: akpm@linux-foundation.org
Subject: + arm-mm-support-arch_mmap_rnd_bits-v7.patch added to -mm tree
Date: Mon, 21 Dec 2015 14:45:45 -0800
Message-ID: <56788119.bjATUUSx6h27wGkV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbbLUWpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2015 17:45:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@google.com, dcashman@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mm: support ARCH_MMAP_RND_BITS
has been added to the -mm tree.  Its filename is
     arm-mm-support-arch_mmap_rnd_bits-v7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-support-arch_mmap_rnd_bits-v7.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-support-arch_mmap_rnd_bits-v7.patch

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
arm-mm-support-arch_mmap_rnd_bits-v7.patch
arm64-mm-support-arch_mmap_rnd_bits.patch
arm64-mm-support-arch_mmap_rnd_bits-v6.patch
arm64-mm-support-arch_mmap_rnd_bits-v7.patch
x86-mm-support-arch_mmap_rnd_bits.patch
x86-mm-support-arch_mmap_rnd_bits-v7.patch

