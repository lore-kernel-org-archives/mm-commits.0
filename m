From: akpm@linux-foundation.org
Subject: +
 printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch added
 to -mm tree
Date: Tue, 12 Jul 2016 13:59:12 -0700
Message-ID: <57855a20.h2ZA4fllwhMB5E0j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbcGLU7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 16:59:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: include <asm/sections.h> instead of <asm-generic/sections.h>
has been added to the -mm tree.  Its filename is
     printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: printk: include <asm/sections.h> instead of <asm-generic/sections.h>

asm-generic headers are generic implementations for architecture specific
code and should not be included by common code.  Thus use the asm/ version
of sections.h to get at the linker sections.

Link: http://lkml.kernel.org/r/1468285008-7331-1-git-send-email-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh
+++ a/kernel/printk/printk.c
@@ -47,7 +47,7 @@
 #include <linux/uio.h>
 
 #include <asm/uaccess.h>
-#include <asm-generic/sections.h>
+#include <asm/sections.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
_

Patches currently in -mm which might be from hch@lst.de are

memblock-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch
printk-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch

