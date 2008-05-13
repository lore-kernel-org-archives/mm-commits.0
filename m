From: akpm@linux-foundation.org
Subject: + per_cpu-fix-define_per_cpu_shared_aligned-for-modules.patch added to -mm tree
Date: Tue, 13 May 2008 09:26:18 -0700
Message-ID: <200805131626.m4DGQIwm021120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757003AbYEMQ0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 12:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, fenghua.yu@intel.com, rusty@rustcorp.com.au


The patch titled
     per_cpu: fix DEFINE_PER_CPU_SHARED_ALIGNED for modules
has been added to the -mm tree.  Its filename is
     per_cpu-fix-define_per_cpu_shared_aligned-for-modules.patch

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
Subject: per_cpu: fix DEFINE_PER_CPU_SHARED_ALIGNED for modules
From: Eric Dumazet <dada1@cosmosbay.com>

Current module loader lookups ".data.percpu" ELF section to perform
per_cpu relocation.  But DEFINE_PER_CPU_SHARED_ALIGNED() uses another
section (".data.percpu.shared_aligned"), currently only handled in
vmlinux.lds, not by module loader.

To correct this problem, instead of adding logic into module loader, or
using at build time a module.lds file for all arches to group
".data.percpu.shared_aligned" into ".data.percpu", just use ".data.percpu"
for modules.

Alignment requirements are correctly handled by ld and module loader.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/percpu.h~per_cpu-fix-define_per_cpu_shared_aligned-for-modules include/linux/percpu.h
--- a/include/linux/percpu.h~per_cpu-fix-define_per_cpu_shared_aligned-for-modules
+++ a/include/linux/percpu.h
@@ -13,8 +13,14 @@
 	__attribute__((__section__(".data.percpu")))			\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
 
+#ifdef CONFIG_MODULES
+#define SHARED_ALIGNED_SECTION ".data.percpu"
+#else
+#define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
+#endif
+
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	__attribute__((__section__(".data.percpu.shared_aligned")))	\
+	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
 #else
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

oprofile-dont-request-cache-line-alignment-for-cpu_buffer.patch
linux-next.patch
per_cpu-fix-define_per_cpu_shared_aligned-for-modules.patch

