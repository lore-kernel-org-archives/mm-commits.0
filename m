From: akpm@linux-foundation.org
Subject: + microblaze-fix-pfn_valid-for-nommu.patch added to -mm tree
Date: Mon, 16 Nov 2009 14:15:46 -0800
Message-ID: <200911162215.nAGMFk8G016049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbZKPWRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 17:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@digidescorp.com, dhowells@redhat.com, gerg@snapgear.com, monstr@monstr.eu


The patch titled
     microblaze: fix pfn_valid() for noMMU
has been added to the -mm tree.  Its filename is
     microblaze-fix-pfn_valid-for-nommu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: microblaze: fix pfn_valid() for noMMU
From: Steven J. Magnani <steve@digidescorp.com>

Configuring DEBUG_SLAB causes a noMMU kernel to die during initialization
with an invalid virtual address panic in kfree_debugcheck().
The panic is due to an improper definition of pfn_valid().

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/page.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/microblaze/include/asm/page.h~microblaze-fix-pfn_valid-for-nommu arch/microblaze/include/asm/page.h
--- a/arch/microblaze/include/asm/page.h~microblaze-fix-pfn_valid-for-nommu
+++ a/arch/microblaze/include/asm/page.h
@@ -164,7 +164,8 @@ extern int page_is_ram(unsigned long pfn
 #  endif /* CONFIG_MMU */
 
 #  ifndef CONFIG_MMU
-#  define pfn_valid(pfn)	((pfn) >= min_low_pfn && (pfn) <= max_mapnr)
+#  define pfn_valid(pfn)	(((pfn) >= min_low_pfn) && \
+				((pfn) <= (min_low_pfn + max_mapnr)))
 #  define ARCH_PFN_OFFSET	(PAGE_OFFSET >> PAGE_SHIFT)
 #  else /* CONFIG_MMU */
 #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)
_

Patches currently in -mm which might be from steve@digidescorp.com are

microblaze-fix-pfn_valid-for-nommu.patch

