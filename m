From: akpm@linux-foundation.org
Subject: [patch 072/101] memblock: include <asm/sections.h> instead of
 <asm-generic/sections.h>
Date: Thu, 28 Jul 2016 15:48:06 -0700
Message-ID: <579a8ba6.Bn2R8cCnQQhUtOyG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbcG1WsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:48:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de

From: Christoph Hellwig <hch@lst.de>
Subject: memblock: include <asm/sections.h> instead of <asm-generic/sections.h>

asm-generic headers are generic implementations for architecture specific
code and should not be included by common code.  Thus use the asm/ version
of sections.h to get at the linker sections.

Link: http://lkml.kernel.org/r/1468285103-7470-1-git-send-email-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~memblock-include-asm-sectionsh-instead-of-asm-generic-sectionsh mm/memblock.c
--- a/mm/memblock.c~memblock-include-asm-sectionsh-instead-of-asm-generic-sectionsh
+++ a/mm/memblock.c
@@ -20,7 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 
-#include <asm-generic/sections.h>
+#include <asm/sections.h>
 #include <linux/io.h>
 
 #include "internal.h"
_
