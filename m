From: akpm@linux-foundation.org
Subject: - frv-build-fix.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:34:58 -0700
Message-ID: <200706081734.l58HYwL3006331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936123AbXFHRf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: build fix
has been removed from the -mm tree.  Its filename was
     frv-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: frv: build fix
From: Peter Zijlstra <peterz@infradead.org>

In file included from /usr/src/linux-2.6-2/net/ipv4/ip_input.c:118:
include2/asm/system.h:245: error: parse error before "__cmpxchg_32"
include2/asm/system.h:245: error: parse error before '*' token
include2/asm/system.h:245: warning: type defaults to `int' in declaration of `__cmpxchg_32'
include2/asm/system.h:245: warning: function declaration isn't a prototype
include2/asm/system.h:245: warning: data definition has no type or storage class

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/system.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-frv/system.h~frv-build-fix include/asm-frv/system.h
--- a/include/asm-frv/system.h~frv-build-fix
+++ a/include/asm-frv/system.h
@@ -12,6 +12,7 @@
 #ifndef _ASM_SYSTEM_H
 #define _ASM_SYSTEM_H
 
+#include <linux/types.h>
 #include <linux/linkage.h>
 
 struct thread_struct;
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
