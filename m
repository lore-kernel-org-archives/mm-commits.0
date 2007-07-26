From: akpm@linux-foundation.org
Subject: + serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch added to -mm tree
Date: Wed, 25 Jul 2007 22:03:57 -0700
Message-ID: <200707260503.l6Q53vO1015073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbXGZFEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 01:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, bunk@stusta.de, jason.wessel@windriver.com


The patch titled
     serial: sh-sci: Fix build failure from kgdb fallout
has been added to the -mm tree.  Its filename is
     serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: sh-sci: Fix build failure from kgdb fallout
From: Paul Mundt <lethal@linux-sh.org>

serial: sh-sci: Fix build failure from kgdb fallout.

  CC      drivers/serial/sh-sci.o
drivers/serial/sh-sci.c: In function 'put_string':
drivers/serial/sh-sci.c:188: error: 'hexchars' undeclared (first use in this function)
drivers/serial/sh-sci.c:188: error: (Each undeclared identifier is reported only once
drivers/serial/sh-sci.c:188: error: for each function it appears in.)
make[3]: *** [drivers/serial/sh-sci.o] Error 1

Reported-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sh-sci.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/sh-sci.c~serial-sh-sci-fix-build-failure-from-kgdb-fallout drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~serial-sh-sci-fix-build-failure-from-kgdb-fallout
+++ a/drivers/serial/sh-sci.c
@@ -162,6 +162,7 @@ static void put_string(struct sci_port *
 
 #if defined(CONFIG_SH_STANDARD_BIOS) || defined(CONFIG_SH_KGDB)
 	int checksum;
+	const char hexchars[] = "0123456789abcdef";
 	int usegdb=0;
 
 #ifdef CONFIG_SH_STANDARD_BIOS
_

Patches currently in -mm which might be from lethal@linux-sh.org are

git-sh.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
clean-up-duplicate-includes-in-mm.patch
