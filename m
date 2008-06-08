From: akpm@linux-foundation.org
Subject: - frv-ip_fast_csum-requires-a-memory-clobber-on-its-inline-asm.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:16 -0700
Message-ID: <200806081948.m58JmGbO017492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbYFHTse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: ip_fast_csum() requires a memory clobber on its inline asm
has been removed from the -mm tree.  Its filename was
     frv-ip_fast_csum-requires-a-memory-clobber-on-its-inline-asm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: ip_fast_csum() requires a memory clobber on its inline asm
From: David Howells <dhowells@redhat.com>

ip_fast_csum() requires a memory clobber on its inline asm as it accesses
memory in a fashion that gcc can't predict.

The GCC manual says:

 If your assembler instructions access memory in an unpredictable
 fashion, add `memory' to the list of clobbered registers.  This will
 cause GCC to not keep memory values cached in registers across the
 assembler instruction and not optimize stores or loads to that memory.

The bug hasn't been noticed in FRV, but it has been seen in PA-RISC.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/checksum.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-frv/checksum.h~frv-ip_fast_csum-requires-a-memory-clobber-on-its-inline-asm include/asm-frv/checksum.h
--- a/include/asm-frv/checksum.h~frv-ip_fast_csum-requires-a-memory-clobber-on-its-inline-asm
+++ a/include/asm-frv/checksum.h
@@ -75,7 +75,7 @@ __sum16 ip_fast_csum(const void *iph, un
 	    : "=r" (sum), "=r" (iph), "=r" (ihl), "=r" (inc), "=&r"(tmp)
 	    : "0" (sum), "1" (iph), "2" (ihl), "3" (4),
 	    "m"(*(volatile struct { int _[100]; } *)iph)
-	    : "icc0", "icc1"
+	    : "icc0", "icc1", "memory"
 	    );
 
 	return (__force __sum16)~sum;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
git-unionfs.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

