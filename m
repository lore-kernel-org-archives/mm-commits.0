From: akpm@linux-foundation.org
Subject: [merged]
 arch-parisc-mm-faultc-fix-uninitialized-variable-usage.patch removed from
 -mm tree
Date: Thu, 17 Oct 2013 11:12:29 -0700
Message-ID: <5260288d.QKdowSt056xp1dXt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab3JQSMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, mhocko@suse.cz, jejb@parisc-linux.org, hannes@cmpxchg.org, deller@gmx.de, felipensp@gmail.com

Subject: [merged] arch-parisc-mm-faultc-fix-uninitialized-variable-usage.patch removed from -mm tree
To: felipensp@gmail.com,deller@gmx.de,hannes@cmpxchg.org,jejb@parisc-linux.org,mhocko@suse.cz,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:29 -0700


The patch titled
     Subject: arch/parisc/mm/fault.c: fix uninitialized variable usage
has been removed from the -mm tree.  Its filename was
     arch-parisc-mm-faultc-fix-uninitialized-variable-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Pena <felipensp@gmail.com>
Subject: arch/parisc/mm/fault.c: fix uninitialized variable usage

The FAULT_FLAG_WRITE flag has been set based on uninitialized variable.

Fixes regression added by 

: commit 759496ba6407c6994d6a5ce3a5e74937d7816208
: Author:     Johannes Weiner <hannes@cmpxchg.org>
: AuthorDate: Thu Sep 12 15:13:39 2013 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Thu Sep 12 15:38:01 2013 -0700
: 
:     arch: mm: pass userspace fault flag to generic fault handler

Signed-off-by: Felipe Pena <felipensp@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/fault.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/parisc/mm/fault.c~arch-parisc-mm-faultc-fix-uninitialized-variable-usage arch/parisc/mm/fault.c
--- a/arch/parisc/mm/fault.c~arch-parisc-mm-faultc-fix-uninitialized-variable-usage
+++ a/arch/parisc/mm/fault.c
@@ -182,6 +182,9 @@ void do_page_fault(struct pt_regs *regs,
 
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
+
+	acc_type = parisc_acctyp(code, regs->iir);
+
 	if (acc_type & VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 retry:
@@ -196,8 +199,6 @@ retry:
 
 good_area:
 
-	acc_type = parisc_acctyp(code,regs->iir);
