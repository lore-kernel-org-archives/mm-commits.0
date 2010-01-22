From: akpm@linux-foundation.org
Subject: + init-mainc-make-setup_max_cpus-static-for-smp.patch added to -mm tree
Date: Fri, 22 Jan 2010 14:48:36 -0800
Message-ID: <201001222248.o0MMma8p000764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627Ab0AVWsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 17:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     init/main.c: make setup_max_cpus static for !SMP
has been added to the -mm tree.  Its filename is
     init-mainc-make-setup_max_cpus-static-for-smp.patch

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
Subject: init/main.c: make setup_max_cpus static for !SMP
From: H Hartley Sweeten <hartleys@visionengravers.com>

init/main.c: make setup_max_cpus static for !SMP

The only in tree external users of the symbol setup_max_cpus are in
arch/x86/.  The files ./kernel/alternative.c, ./kernel/visws_quirks.c, and
./mm/kmemcheck/kmemcheck.c are all guarded by CONFIG_SMP being defined. 
For this case the symbol is an unsigned int and declared as an extern in
include/linux/smp.h.

When CONFIG_SMP is not defined the symbol setup_max_cpus is
a constant value that is only used in init/main.c.  Make the symbol
static for this case.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~init-mainc-make-setup_max_cpus-static-for-smp init/main.c
--- a/init/main.c~init-mainc-make-setup_max_cpus-static-for-smp
+++ a/init/main.c
@@ -161,7 +161,7 @@ static int __init maxcpus(char *str)
 
 early_param("maxcpus", maxcpus);
 #else
-const unsigned int setup_max_cpus = NR_CPUS;
+static const unsigned int setup_max_cpus = NR_CPUS;
 #endif
 
 /*
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch
nodemaskh-remove-macro-any_online_node.patch
init-mainc-make-setup_max_cpus-static-for-smp.patch

