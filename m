From: akpm@linux-foundation.org
Subject: +
 kprobes-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch added
 to -mm tree
Date: Tue, 13 Sep 2016 15:42:13 -0700
Message-ID: <57d880c5.UVCi3gpU6JKLsTlR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932773AbcIMWmO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 18:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mhiramat@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: include <asm/sections.h> instead of <asm-generic/sections.h>
has been added to the -mm tree.  Its filename is
     kprobes-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch

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
Subject: kprobes: include <asm/sections.h> instead of <asm-generic/sections.h>

asm-generic headers are generic implementations for architecture specific
code and should not be included by common code.  Thus use the asm/ version
of sections.h to get at the linker sections.

Link: http://lkml.kernel.org/r/1473602302-6208-1-git-send-email-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-include-asm-sectionsh-instead-of-asm-generic-sectionsh kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-include-asm-sectionsh-instead-of-asm-generic-sectionsh
+++ a/kernel/kprobes.c
@@ -49,7 +49,7 @@
 #include <linux/cpu.h>
 #include <linux/jump_label.h>
 
-#include <asm-generic/sections.h>
+#include <asm/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from hch@lst.de are

kprobes-include-asm-sectionsh-instead-of-asm-generic-sectionsh.patch

