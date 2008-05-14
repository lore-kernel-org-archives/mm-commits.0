From: akpm@linux-foundation.org
Subject: - per_cpu-fix-define_per_cpu_shared_aligned-for-modules-fix.patch removed from -mm tree
Date: Wed, 14 May 2008 15:21:57 -0700
Message-ID: <200805142221.m4EMLvL1024055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbYENWWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 18:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, fenghua.yu@intel.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     per_cpu-fix-define_per_cpu_shared_aligned-for-modules fix
has been removed from the -mm tree.  Its filename was
     per_cpu-fix-define_per_cpu_shared_aligned-for-modules-fix.patch

This patch was dropped because it was folded into per_cpu-fix-define_per_cpu_shared_aligned-for-modules.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: per_cpu-fix-define_per_cpu_shared_aligned-for-modules fix
From: Eric Dumazet <dada1@cosmosbay.com>

A typo was included in the patch I sent yesterday, since I was testing :

#ifdef CONFIG_MODULES

while the intention was to test

#ifdef MODULE

So that all SHARED_ALIGNED vmlinux percpu variables still are in the
special section.
The fix is only needed when compiling modules.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/percpu.h~per_cpu-fix-define_per_cpu_shared_aligned-for-modules-fix include/linux/percpu.h
--- a/include/linux/percpu.h~per_cpu-fix-define_per_cpu_shared_aligned-for-modules-fix
+++ a/include/linux/percpu.h
@@ -13,7 +13,7 @@
 	__attribute__((__section__(".data.percpu")))			\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
-#ifdef CONFIG_MODULES
+#ifdef MODULE
 #define SHARED_ALIGNED_SECTION ".data.percpu"
 #else
 #define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

oprofile-dont-request-cache-line-alignment-for-cpu_buffer.patch
per_cpu-fix-define_per_cpu_shared_aligned-for-modules.patch
per_cpu-fix-define_per_cpu_shared_aligned-for-modules-fix.patch
linux-next.patch

