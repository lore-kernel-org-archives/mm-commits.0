From: akpm@linux-foundation.org
Subject: + bitops-introduce-generic-clearset_bit_le.patch added to -mm tree
Date: Tue, 18 Sep 2012 16:21:45 -0700
Message-ID: <20120918232146.A2D7C20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:42344 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666Ab2IRXVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2012 19:21:49 -0400
Received: by lagw12 with SMTP id w12so16073lag.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 16:21:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoshikawa.takuya@oss.ntt.co.jp, arnd@arndb.de, avi@redhat.com, mtosatti@redhat.com


The patch titled
     Subject: bitops: introduce generic {clear,set}_bit_le()
has been added to the -mm tree.  Its filename is
     bitops-introduce-generic-clearset_bit_le.patch

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
Subject: bitops: introduce generic {clear,set}_bit_le()

Needed to replace test_and_set_bit_le() in virt/kvm/kvm_main.c which is
being used for this missing function.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/le.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/asm-generic/bitops/le.h~bitops-introduce-generic-clearset_bit_le include/asm-generic/bitops/le.h
--- a/include/asm-generic/bitops/le.h~bitops-introduce-generic-clearset_bit_le
+++ a/include/asm-generic/bitops/le.h
@@ -54,6 +54,16 @@ static inline int test_bit_le(int nr, co
 	return test_bit(nr ^ BITOP_LE_SWIZZLE, addr);
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

