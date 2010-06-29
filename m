From: akpm@linux-foundation.org
Subject: + um-os-linux-memc-needs-sys-stath.patch added to -mm tree
Date: Tue, 29 Jun 2010 11:49:27 -0700
Message-ID: <201006291849.o5TInRtH022492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab0F2SuV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jun 2010 14:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aleaxander@gmail.com, Aleaxander@gmail.com, bharrosh@panasas.com, jdike@addtoit.com, stable@kernel.org


The patch titled
     um: os-linux/mem.c needs sys/stat.h
has been added to the -mm tree.  Its filename is
     um-os-linux-memc-needs-sys-stath.patch

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
Subject: um: os-linux/mem.c needs sys/stat.h
From: Liu Aleaxander <aleaxander@gmail.com>

The os-linux/mem.c file calls fchmod function, which is declared in sys/stat.h
header file, so include it.  Fixes build breakage under FC13.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/mem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/os-Linux/mem.c~um-os-linux-memc-needs-sys-stath arch/um/os-Linux/mem.c
--- a/arch/um/os-Linux/mem.c~um-os-linux-memc-needs-sys-stath
+++ a/arch/um/os-Linux/mem.c
@@ -10,6 +10,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <string.h>
+#include <sys/stat.h>
 #include <sys/mman.h>
 #include <sys/param.h>
 #include "init.h"
_

Patches currently in -mm which might be from aleaxander@gmail.com are

um-os-linux-memc-needs-sys-stath.patch

