From: akpm@linux-foundation.org
Subject: [patch 78/78] mm, x86: fix HIGHMEM64 && PARAVIRT build config for native_pud_clear()
Date: Mon, 27 Feb 2017 14:30:25 -0800
Message-ID: <58b4a881.TKOssJMPWRs1Hstd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdB0Wzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave.jiang@intel.com, boris.ostrovsky@oracle.com, labbott@redhat.com, mawilcox@microsoft.com

From: Dave Jiang <dave.jiang@intel.com>
Subject: mm, x86: fix HIGHMEM64 && PARAVIRT build config for native_pud_clear()

Looks like I also missed the build config that includes CONFIG_HIGHMEM64G
&& CONFIG_PARAVIRT to export the native_pud_clear() dummy function.

Fixes: a00cc7d9dd93d ("mm, x86: add support for PUD-sized transparent hugepages")
Link: http://lkml.kernel.org/r/148823188084.56076.17451228917824355200.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reported-by: Laura Abbott <labbott@redhat.com>
Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-3level.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pgtable-3level.h~mm-x86-fix-highmem64-paravirt-build-config-for-native_pud_clear arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~mm-x86-fix-highmem64-paravirt-build-config-for-native_pud_clear
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -121,7 +121,8 @@ static inline void native_pmd_clear(pmd_
 	*(tmp + 1) = 0;
 }
 
-#ifndef CONFIG_SMP
+#if !defined(CONFIG_SMP) || (defined(CONFIG_HIGHMEM64G) && \
+		defined(CONFIG_PARAVIRT))
 static inline void native_pud_clear(pud_t *pudp)
 {
 }
_
