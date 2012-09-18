From: akpm@linux-foundation.org
Subject: + powerpc-bitops-introduce-clearset_bit_le.patch added to -mm tree
Date: Tue, 18 Sep 2012 16:21:49 -0700
Message-ID: <20120918232150.9966F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:33501 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2IRXVw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 19:21:52 -0400
Received: by wibhr14 with SMTP id hr14so16506wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 16:21:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoshikawa.takuya@oss.ntt.co.jp, avi@redhat.com, benh@kernel.crashing.org, mtosatti@redhat.com


The patch titled
     Subject: powerpc: bitops: introduce {clear,set}_bit_le()
has been added to the -mm tree.  Its filename is
     powerpc-bitops-introduce-clearset_bit_le.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
sfc-use-standard-__clearset_bit_le-functions.patch
drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function.patch
bitops-introduce-generic-clearset_bit_le.patch
powerpc-bitops-introduce-clearset_bit_le.patch
kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le.patch

