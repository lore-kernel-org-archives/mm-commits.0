From: akpm@linux-foundation.org
Subject: [obsolete] x86-visws-fix-up-build.patch removed from -mm tree
Date: Wed, 08 Apr 2009 15:39:18 -0700
Message-ID: <200904082239.n38MdICp004553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbZDHWlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2009 18:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: visws: fix UP build
has been removed from the -mm tree.  Its filename was
     x86-visws-fix-up-build.patch

This patch was dropped because it is obsolete

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

