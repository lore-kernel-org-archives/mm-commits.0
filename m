From: akpm@linux-foundation.org
Subject: + um-mark-config_highmem-as-broken.patch added to -mm tree
Date: Fri, 12 Nov 2010 11:51:19 -0800
Message-ID: <201011121951.oACJpJxu028350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197Ab0KLTvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:51:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, jdike@addtoit.com


The patch titled
     um: mark CONFIG_HIGHMEM as broken
has been added to the -mm tree.  Its filename is
     um-mark-config_highmem-as-broken.patch

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
Subject: um: mark CONFIG_HIGHMEM as broken
From: Richard Weinberger <richard@nod.at>

Currently CONFIG_HIGHMEM is broken on User Mode Linux.  I'm not sure if it
worked ever.

It doesn't compile and this breaks randomconfig testing.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.um |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Kconfig.um~um-mark-config_highmem-as-broken arch/um/Kconfig.um
--- a/arch/um/Kconfig.um~um-mark-config_highmem-as-broken
+++ a/arch/um/Kconfig.um
@@ -131,7 +131,7 @@ config NR_CPUS
 
 config HIGHMEM
 	bool "Highmem support (EXPERIMENTAL)"
-	depends on !64BIT && EXPERIMENTAL
+	depends on !64BIT && BROKEN
 	default n
 	help
 	  This was used to allow UML to run with big amounts of memory.
_

Patches currently in -mm which might be from richard@nod.at are

um-fix-ptrace-build-error.patch
um-mark-config_highmem-as-broken.patch

