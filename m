From: akpm@linux-foundation.org
Subject: +
 x86-mm-fix-nohighmem-x86_pae-build-config-for-native_pud_clear.patch added
 to -mm tree
Date: Mon, 13 Mar 2017 12:28:59 -0700
Message-ID: <58c6f2fb.6ENzpUB/w29H8JPx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752287AbdCMT3B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2017 15:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: fix NOHIGHMEM && X86_PAE build config for native_pud_clear()
has been added to the -mm tree.  Its filename is
     x86-mm-fix-nohighmem-x86_pae-build-config-for-native_pud_clear.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-fix-nohighmem-x86_pae-build-config-for-native_pud_clear.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-fix-nohighmem-x86_pae-build-config-for-native_pud_clear.patch

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
Subject: x86, mm: fix NOHIGHMEM && X86_PAE build config for native_pud_clear()

Looks like a 32bit x86 build failure case where X86_PAE and NOHIMEM
are on. This was reported by kbuild test bot.

   In file included from include/linux/mm.h:68:0,
                    from include/linux/highmem.h:7,
                    from include/linux/bio.h:21,
                    from include/linux/writeback.h:205,
                    from include/linux/memcontrol.h:30,
                    from include/linux/swap.h:8,
                    from include/linux/suspend.h:4,
                    from arch/x86/kernel/asm-offsets.c:12:
   arch/x86/include/asm/pgtable.h: In function 'native_local_pudp_get_and_clear':
>> arch/x86/include/asm/pgtable.h:888:2: error: implicit declaration of function 'native_pud_clear' [-Werror=implicit-function-declaration]
     native_pud_clear(pudp);
     ^~~~~~~~~~~~~~~~

Fixes: a00cc7d9dd93d ("mm, x86: add support for PUD-sized transparent hugepages")
Link: http://lkml.kernel.org/r/148883869853.70777.12180810304957921737.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-3level.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/pgtable-3level.h~x86-mm-fix-nohighmem-x86_pae-build-config-for-native_pud_clear arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~x86-mm-fix-nohighmem-x86_pae-build-config-for-native_pud_clear
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -121,8 +121,9 @@ static inline void native_pmd_clear(pmd_
 	*(tmp + 1) = 0;
 }
 
-#if !defined(CONFIG_SMP) || (defined(CONFIG_HIGHMEM64G) && \
-		defined(CONFIG_PARAVIRT))
+#if !defined(CONFIG_SMP) || \
+	(defined(CONFIG_HIGHMEM64G) && defined(CONFIG_PARAVIRT)) || \
+	(defined(CONFIG_NOHIGHMEM) && defined(CONFIG_X86_PAE))
 static inline void native_pud_clear(pud_t *pudp)
 {
 }
_

Patches currently in -mm which might be from dave.jiang@intel.com are

x86-mm-fix-nohighmem-x86_pae-build-config-for-native_pud_clear.patch

