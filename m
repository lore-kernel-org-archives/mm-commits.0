From: akpm@linux-foundation.org
Subject: [patch 077/114] include/linux/filter.h: use set_memory.h
 header
Date: Mon, 08 May 2017 15:58:26 -0700
Message-ID: <20170508225826.BZGK5dAJF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbdEHW61 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel@iogearbox.net, labbott@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: include/linux/filter.h: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-11-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/filter.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/filter.h~bpf-use-set_memoryh-header include/linux/filter.h
--- a/include/linux/filter.h~bpf-use-set_memoryh-header
+++ a/include/linux/filter.h
@@ -19,7 +19,9 @@
 
 #include <net/sch_generic.h>
 
-#include <asm/cacheflush.h>
+#ifdef CONFIG_ARCH_HAS_SET_MEMORY
+#include <asm/set_memory.h>
+#endif
 
 #include <uapi/linux/filter.h>
 #include <uapi/linux/bpf.h>
_
