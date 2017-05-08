From: akpm@linux-foundation.org
Subject: [patch 081/114] drivers/misc/sram-exec.c: use set_memory.h
 header
Date: Mon, 08 May 2017 15:58:38 -0700
Message-ID: <20170508225838.n8NMWNDmk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbdEHW6j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: drivers/misc/sram-exec.c: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-15-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sram-exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sram-exec.c~misc-sram-use-set_memoryh-header drivers/misc/sram-exec.c
--- a/drivers/misc/sram-exec.c~misc-sram-use-set_memoryh-header
+++ a/drivers/misc/sram-exec.c
@@ -16,9 +16,10 @@
 
 #include <linux/device.h>
 #include <linux/genalloc.h>
+#include <linux/mm.h>
 #include <linux/sram.h>
 
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 
 #include "sram.h"
 
_
