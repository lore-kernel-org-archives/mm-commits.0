From: akpm@linux-foundation.org
Subject: + frv-build-fix.patch added to -mm tree
Date: Wed, 06 Jun 2007 10:55:07 -0700
Message-ID: <200706061755.l56Ht7WT002872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757908AbXFFRzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 13:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peterz@infradead.org, a.p.zijlstra@chello.nl, dhowells@redhat.com


The patch titled
     frv: build fix
has been added to the -mm tree.  Its filename is
     frv-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

frv-build-fix.patch
