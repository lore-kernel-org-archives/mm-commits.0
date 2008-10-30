From: akpm@linux-foundation.org
Subject: + x86-convert-highmem-macros-to-functions.patch added to -mm tree
Date: Thu, 30 Oct 2008 14:48:54 -0700
Message-ID: <200810302148.m9ULms8M025616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760864AbYJ3Vtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 17:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, mingo@elte.hu


The patch titled
     x86: convert highmem macros to functions
has been added to the -mm tree.  Its filename is
     x86-convert-highmem-macros-to-functions.patch

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
Subject: x86: convert highmem macros to functions
From: Marcin Slusarz <marcin.slusarz@gmail.com>

convert kmap_init, permanent_kmaps_init, set_highmem_pages_init macros
defined when !CONFIG_HIGHMEM to functions

supresses following warning from gcc:
arch/x86/mm/init_32.c: In function 'pagetable_init':
arch/x86/mm/init_32.c:516: warning: unused variable 'pgd_base'

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/init_32.c~x86-convert-highmem-macros-to-functions arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~x86-convert-highmem-macros-to-functions
+++ a/arch/x86/mm/init_32.c
@@ -436,9 +436,9 @@ static void __init set_highmem_pages_ini
 #endif /* !CONFIG_NUMA */
 
 #else
-# define kmap_init()				do { } while (0)
-# define permanent_kmaps_init(pgd_base)		do { } while (0)
-# define set_highmem_pages_init()	do { } while (0)
+static inline void kmap_init(void) {}
+static inline void permanent_kmaps_init(pgd_t *pgd_base) {}
+static inline void set_highmem_pages_init(void) {}
 #endif /* CONFIG_HIGHMEM */
 
 void __init native_pagetable_setup_start(pgd_t *base)
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

fbcon-dont-inline-updatescrollmode.patch
x86-convert-highmem-macros-to-functions.patch

