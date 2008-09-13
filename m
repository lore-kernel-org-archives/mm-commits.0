From: akpm@linux-foundation.org
Subject: - x86-pgd_cdtor-cleanup.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:21 -0700
Message-ID: <200809130745.m8D7jL33026761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbYIMHpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, hpa@zytor.com, jeremy@goop.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: pgd_{c,d}tor() cleanup
has been removed from the -mm tree.  Its filename was
     x86-pgd_cdtor-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: pgd_{c,d}tor() cleanup
From: Jan Beulich <jbeulich@novell.com>

Giving pgd_ctor() a properly typed parameter allows eliminating a local
variable.  Adjust pgd_dtor() to match.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/pgtable.c~x86-pgd_cdtor-cleanup arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~x86-pgd_cdtor-cleanup
+++ a/arch/x86/mm/pgtable.c
@@ -63,10 +63,8 @@ static inline void pgd_list_del(pgd_t *p
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 
-static void pgd_ctor(void *p)
+static void pgd_ctor(pgd_t *pgd)
 {
-	pgd_t *pgd = p;
