From: akpm@linux-foundation.org
Subject: [merged] powerpc-bitops-introduce-clearset_bit_le.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:30 -0700
Message-ID: <20121005201530.B235C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61307 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2JEUPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:31 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so236823qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoshikawa.takuya@oss.ntt.co.jp, avi@redhat.com, benh@kernel.crashing.org, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: bitops: introduce {clear,set}_bit_le()
has been removed from the -mm tree.  Its filename was
     powerpc-bitops-introduce-clearset_bit_le.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: powerpc: bitops: introduce {clear,set}_bit_le()

Needed to replace test_and_set_bit_le() in virt/kvm/kvm_main.c which is
being used for this missing function.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/bitops.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN arch/powerpc/include/asm/bitops.h~powerpc-bitops-introduce-clearset_bit_le arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h~powerpc-bitops-introduce-clearset_bit_le
+++ a/arch/powerpc/include/asm/bitops.h
@@ -288,6 +288,16 @@ static __inline__ int test_bit_le(unsign
 	return (tmp[nr >> 3] >> (nr & 7)) & 1;
 }
 
+static inline void set_bit_le(int nr, void *addr)
+{
+	set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
+static inline void clear_bit_le(int nr, void *addr)
+{
+	clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
+}
+
 static inline void __set_bit_le(int nr, void *addr)
 {
 	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
_

Patches currently in -mm which might be from yoshikawa.takuya@oss.ntt.co.jp are

origin.patch

