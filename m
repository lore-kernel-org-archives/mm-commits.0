From: akpm@linux-foundation.org
Subject: + x86-visws-fix-up-build.patch added to -mm tree
Date: Tue, 07 Apr 2009 14:03:35 -0700
Message-ID: <200904072103.n37L3Zq4027688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbZDGVVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 17:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, mingo@elte.hu


The patch titled
     x86: visws: fix UP build
has been added to the -mm tree.  Its filename is
     x86-visws-fix-up-build.patch

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
Subject: x86: visws: fix UP build
From: Alexander Beregalov <a.beregalov@gmail.com>

arch/x86/kernel/visws_quirks.c: In function 'visws_find_smp_config':
arch/x86/kernel/visws_quirks.c:229: error: 'setup_max_cpus' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/visws_quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/visws_quirks.c~x86-visws-fix-up-build arch/x86/kernel/visws_quirks.c
--- a/arch/x86/kernel/visws_quirks.c~x86-visws-fix-up-build
+++ a/arch/x86/kernel/visws_quirks.c
@@ -220,8 +220,10 @@ static int __init visws_find_smp_config(
 		ncpus = CO_CPU_MAX;
 	}
 
+#ifdef CONFIG_SMP
 	if (ncpus > setup_max_cpus)
 		ncpus = setup_max_cpus;
+#endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	smp_found_config = 1;
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
befs-fix-build-on-parisc.patch
linux-next.patch
x86-visws-fix-up-build.patch

