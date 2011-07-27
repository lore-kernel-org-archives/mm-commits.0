From: akpm@linux-foundation.org
Subject: + sparc-rename-atomic_add_unless.patch added to -mm tree
Date: Tue, 26 Jul 2011 23:02:43 -0700
Message-ID: <201107270601.p6R61adj000857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab1G0GBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 02:01:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, asharma@fb.com, davem@davemloft.net, hans-christian.egtvedt@atmel.com


The patch titled
     sparc: rename atomic_add_unless
has been added to the -mm tree.  Its filename is
     sparc-rename-atomic_add_unless.patch

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
Subject: sparc: rename atomic_add_unless
From: Stephen Rothwell <sfr@canb.auug.org.au>

Should have been done in commit 1af08a1407f4 ("This is in preparation for
more generic atomic").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/lib/atomic32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc/lib/atomic32.c~sparc-rename-atomic_add_unless arch/sparc/lib/atomic32.c
--- a/arch/sparc/lib/atomic32.c~sparc-rename-atomic_add_unless
+++ a/arch/sparc/lib/atomic32.c
@@ -55,7 +55,7 @@ int atomic_cmpxchg(atomic_t *v, int old,
 }
 EXPORT_SYMBOL(atomic_cmpxchg);
 
-int atomic_add_unless(atomic_t *v, int a, int u)
+int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int ret;
 	unsigned long flags;
@@ -67,7 +67,7 @@ int atomic_add_unless(atomic_t *v, int a
 	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
 	return ret != u;
 }
-EXPORT_SYMBOL(atomic_add_unless);
+EXPORT_SYMBOL(__atomic_add_unless);
 
 /* Atomic operations are already serializing */
 void atomic_set(atomic_t *v, int i)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
sparc-rename-atomic_add_unless.patch
linux-next.patch
consolidate-config_debug_strict_user_copy_checks.patch

