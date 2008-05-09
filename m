From: akpm@linux-foundation.org
Subject: - mn10300-make-cpu_relax-invoke-barrier.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:51 -0700
Message-ID: <200805092146.m49Lkpu7027154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527AbYEIVrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MN10300: make cpu_relax() invoke barrier()
has been removed from the -mm tree.  Its filename was
     mn10300-make-cpu_relax-invoke-barrier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MN10300: make cpu_relax() invoke barrier()
From: David Howells <dhowells@redhat.com>

Make cpu_relax() invoke barrier() to be the same as other arches.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mn10300/processor.h~mn10300-make-cpu_relax-invoke-barrier include/asm-mn10300/processor.h
--- a/include/asm-mn10300/processor.h~mn10300-make-cpu_relax-invoke-barrier
+++ a/include/asm-mn10300/processor.h
@@ -58,7 +58,7 @@ extern struct mn10300_cpuinfo boot_cpu_d
 extern void identify_cpu(struct mn10300_cpuinfo *);
 extern void print_cpu_info(struct mn10300_cpuinfo *);
 extern void dodgy_tsc(void);
-#define cpu_relax() do {} while (0)
+#define cpu_relax() barrier()
 
 /*
  * User space process size: 1.75GB (default).
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
mn10300-replace-deprecated-topdir-with-newer-srctree.patch
git-unionfs.patch
mutex-subsystem-synchro-test-module.patch

