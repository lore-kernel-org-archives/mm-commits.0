From: akpm@linux-foundation.org
Subject: +
 mm-x86-fix-highmem64-paravirt-build-config-for-native_pud_clear.patch added to -mm tree
Date: Mon, 27 Feb 2017 13:48:39 -0800
Message-ID: <58b49eb7.Y8re/K7L73eSebjq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdB0Vsl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 16:48:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, boris.ostrovsky@oracle.com, labbott@redhat.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, x86: fix HIGHMEM64 && PARAVIRT build config for native_pud_clear()
has been added to the -mm tree.  Its filename is
     mm-x86-fix-highmem64-paravirt-build-config-for-native_pud_clear.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-x86-fix-highmem64-paravirt-build-config-for-native_pud_clear.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-fix-highmem64-paravirt-build-config-for-native_pud_clear.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from dave.jiang@intel.com are

mm-x86-fix-highmem64-paravirt-build-config-for-native_pud_clear.patch

