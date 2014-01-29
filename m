From: akpm@linux-foundation.org
Subject: + mm-dont-lose-the-soft_dirty-flag-on-mprotect.patch added to -mm tree
Date: Wed, 29 Jan 2014 12:19:39 -0800
Message-ID: <52e9625b.oYTsVYRkzB14RAdw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaA2UTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jan 2014 15:19:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, wency@cn.fujitsu.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gorcunov@openvz.org, bp@suse.de, avagin@openvz.org

Subject: + mm-dont-lose-the-soft_dirty-flag-on-mprotect.patch added to -mm tree
To: avagin@openvz.org,bp@suse.de,gorcunov@openvz.org,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de,wency@cn.fujitsu.com,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 29 Jan 2014 12:19:39 -0800


The patch titled
     Subject: mm: don't lose the SOFT_DIRTY flag on mprotect
has been added to the -mm tree.  Its filename is
     mm-dont-lose-the-soft_dirty-flag-on-mprotect.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-lose-the-soft_dirty-flag-on-mprotect.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-lose-the-soft_dirty-flag-on-mprotect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: mm: don't lose the SOFT_DIRTY flag on mprotect

The SOFT_DIRTY bit shows that the content of memory was changed after a
defined point in the past.  mprotect() doesn't change the content of
memory, so it must not change the SOFT_DIRTY bit.

This patch does nothing with _PAGE_SWP_SOFT_DIRTY, becase pte_modify() is
called only for present pages.

Fixes 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes
tracking").

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_types.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pgtable_types.h~mm-dont-lose-the-soft_dirty-flag-on-mprotect arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-dont-lose-the-soft_dirty-flag-on-mprotect
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -121,7 +121,8 @@
 
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
-			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY)
+			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY |	\
+			 _PAGE_SOFT_DIRTY)
 #define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
_

Patches currently in -mm which might be from avagin@openvz.org are

mm-dont-lose-the-soft_dirty-flag-on-mprotect.patch

