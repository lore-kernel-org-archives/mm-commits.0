From: akpm@linux-foundation.org
Subject: + mips-export-flush_icache_range.patch added to -mm tree
Date: Wed, 09 Apr 2014 13:33:37 -0700
Message-ID: <5345aea1.SvrJ7u274Hydp5tE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933969AbaDIUdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 16:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergei.shtylyov@cogentembedded.com, sanjayl@kymasys.com, ralf@linux-mips.org, paul.gortmaker@windriver.com, blogic@openwrt.org, keescook@chromium.org

Subject: + mips-export-flush_icache_range.patch added to -mm tree
To: keescook@chromium.org,blogic@openwrt.org,paul.gortmaker@windriver.com,ralf@linux-mips.org,sanjayl@kymasys.com,sergei.shtylyov@cogentembedded.com
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 13:33:37 -0700


The patch titled
     Subject: mips: export flush_icache_range
has been added to the -mm tree.  Its filename is
     mips-export-flush_icache_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-export-flush_icache_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-export-flush_icache_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mips: export flush_icache_range

The lkdtm module performs tests against executable memory ranges, so it
needs to flush the icache for proper behaviors.  Other architectures
already export this, so do the same for MIPS.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sanjay Lal <sanjayl@kymasys.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mips/mm/cache.c~mips-export-flush_icache_range arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~mips-export-flush_icache_range
+++ a/arch/mips/mm/cache.c
@@ -38,6 +38,7 @@ void (*__flush_kernel_vmap_range)(unsign
 void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
 
 EXPORT_SYMBOL_GPL(__flush_kernel_vmap_range);
+EXPORT_SYMBOL_GPL(flush_icache_range);
 
 /* MIPS specific cache operations */
 void (*flush_cache_sigtramp)(unsigned long addr);
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
mips-export-flush_icache_range.patch
mips-export-flush_icache_range-fix.patch
lib-vsprintf-add-%pt-format-specifier.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch

