From: akpm@linux-foundation.org
Subject: [patch 039/111] printk: include <asm/sections.h> instead of
 <asm-generic/sections.h>
Date: Tue, 02 Aug 2016 14:03:59 -0700
Message-ID: <57a10abf.axnQteqxjedHGKbM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbcHBVRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de

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
