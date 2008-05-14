From: akpm@linux-foundation.org
Subject: + per_cpu-fix-define_per_cpu_shared_aligned-for-modules-fix.patch added to -mm tree
Date: Tue, 13 May 2008 22:32:07 -0700
Message-ID: <200805140532.m4E5W7cb018334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbYENFcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 01:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, fenghua.yu@intel.com, rusty@rustcorp.com.au


The patch titled
     per_cpu-fix-define_per_cpu_shared_aligned-for-modules fix
has been added to the -mm tree.  Its filename is
     per_cpu-fix-define_per_cpu_shared_aligned-for-modules-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
per_cpu-fix-define_per_cpu_shared_aligned-for-modules.patch
per_cpu-fix-define_per_cpu_shared_aligned-for-modules-fix.patch

