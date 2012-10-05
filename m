From: akpm@linux-foundation.org
Subject: [merged] bitops-introduce-generic-clearset_bit_le.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:23 -0700
Message-ID: <20121005201524.2B7AD5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38438 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:26 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so138958bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoshikawa.takuya@oss.ntt.co.jp, arnd@arndb.de, avi@redhat.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: introduce generic {clear,set}_bit_le()
has been removed from the -mm tree.  Its filename was
     bitops-introduce-generic-clearset_bit_le.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

