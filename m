From: akpm@linux-foundation.org
Subject: [patch 12/17] kcov: fix comparison callback signature
Date: Thu, 14 Dec 2017 15:33:02 -0800
Message-ID: <5a330a2e.CM/PdbntsJc+TLF5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754358AbdLNXdD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:33:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dvyukov@google.com, glider@google.com, quentin.casasnovas@oracle.com, vegard.nossum@oracle.com

From: Dmitry Vyukov <dvyukov@google.com>
Subject: kcov: fix comparison callback signature

Fix a silly copy-paste bug.  We truncated u32 args to u16.

Link: http://lkml.kernel.org/r/20171207101134.107168-1-dvyukov@google.com
Fixes: ded97d2c2b2c ("kcov: support comparison operands collection")
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: syzkaller@googlegroups.com
Cc: Alexander Potapenko <glider@google.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kcov.c~kcov-fix-comparison-callback-signature kernel/kcov.c
--- a/kernel/kcov.c~kcov-fix-comparison-callback-signature
+++ a/kernel/kcov.c
@@ -157,7 +157,7 @@ void notrace __sanitizer_cov_trace_cmp2(
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_cmp2);
 
-void notrace __sanitizer_cov_trace_cmp4(u16 arg1, u16 arg2)
+void notrace __sanitizer_cov_trace_cmp4(u32 arg1, u32 arg2)
 {
 	write_comp_data(KCOV_CMP_SIZE(2), arg1, arg2, _RET_IP_);
 }
@@ -183,7 +183,7 @@ void notrace __sanitizer_cov_trace_const
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_const_cmp2);
 
-void notrace __sanitizer_cov_trace_const_cmp4(u16 arg1, u16 arg2)
+void notrace __sanitizer_cov_trace_const_cmp4(u32 arg1, u32 arg2)
 {
 	write_comp_data(KCOV_CMP_SIZE(2) | KCOV_CMP_CONST, arg1, arg2,
 			_RET_IP_);
_
