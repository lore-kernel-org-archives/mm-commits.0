From: akpm@linux-foundation.org
Subject: [patch 028/102] kprobes: include <asm/sections.h> instead of
 <asm-generic/sections.h>
Date: Tue, 11 Oct 2016 13:52:22 -0700
Message-ID: <57fd5106.TLtDr/KqgdRKoBzC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37922 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753032AbcJKUxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de, mhiramat@kernel.org

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
