Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6D14F8A3
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sn43Ea8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F74C433C7;
	Wed, 20 Dec 2023 23:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113422;
	bh=7RRFhrYdxAl3WUDUSxuC4eDVyAOx8wnbvW8IcaSCQxY=;
	h=Date:To:From:Subject:From;
	b=Sn43Ea8WmFqL2FqOk2W2q0qIEIh+77Mpmip+Y0tyHTDILaNmIiPLAWU7YuGMOLRUT
	 e8nBvBFIoluvvO/mghL5M6qnLTADNQN+4RedDUbQKoGRWuxIAp3X8aK1gn7rX3lx2P
	 vZv3YkvQ0FddKYWIAKCUKv1ky9GK5czwqaV2eezg=
Date: Wed, 20 Dec 2023 15:03:41 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,boqun.feng@gmail.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-kconfig-move-more-items-into-the-expert-menu.patch removed from -mm tree
Message-Id: <20231220230342.75F74C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/Kconfig: move more items into the EXPERT menu
has been removed from the -mm tree.  Its filename was
     init-kconfig-move-more-items-into-the-expert-menu.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: init/Kconfig: move more items into the EXPERT menu
Date: Thu, 7 Dec 2023 20:58:19 -0800

KCMP, RSEQ, CACHESTAT_SYSCALL, and PC104 depend on EXPERT but not shown in
the EXPERT menu.  Move some lines around so that they are displayed in the
EXPERT menu.

Drop one useless comment.

Change "enabled" to "enable" for DEBUG_RSEQ.

Link: https://lkml.kernel.org/r/20231208045819.2922-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |  102 ++++++++++++++++++++++++-------------------------
 1 file changed, 50 insertions(+), 52 deletions(-)

--- a/init/Kconfig~init-kconfig-move-more-items-into-the-expert-menu
+++ a/init/Kconfig
@@ -1676,6 +1676,56 @@ config MEMBARRIER
 
 	  If unsure, say Y.
 
+config KCMP
+	bool "Enable kcmp() system call" if EXPERT
+	help
+	  Enable the kernel resource comparison system call. It provides
+	  user-space with the ability to compare two processes to see if they
+	  share a common resource, such as a file descriptor or even virtual
+	  memory space.
+
+	  If unsure, say N.
+
+config RSEQ
+	bool "Enable rseq() system call" if EXPERT
+	default y
+	depends on HAVE_RSEQ
+	select MEMBARRIER
+	help
+	  Enable the restartable sequences system call. It provides a
+	  user-space cache for the current CPU number value, which
+	  speeds up getting the current CPU number from user-space,
+	  as well as an ABI to speed up user-space operations on
+	  per-CPU data.
+
+	  If unsure, say Y.
+
+config DEBUG_RSEQ
+	default n
+	bool "Enable debugging of rseq() system call" if EXPERT
+	depends on RSEQ && DEBUG_KERNEL
+	help
+	  Enable extra debugging checks for the rseq system call.
+
+	  If unsure, say N.
+
+config CACHESTAT_SYSCALL
+	bool "Enable cachestat() system call" if EXPERT
+	default y
+	help
+	  Enable the cachestat system call, which queries the page cache
+	  statistics of a file (number of cached pages, dirty pages,
+	  pages marked for writeback, (recently) evicted pages).
+
+	  If unsure say Y here.
+
+config PC104
+	bool "PC/104 support" if EXPERT
+	help
+	  Expose PC/104 form factor device drivers and options available for
+	  selection and configuration. Enable this option if your target
+	  machine has a PC/104 bus.
+
 config KALLSYMS
 	bool "Load all symbols for debugging/ksymoops" if EXPERT
 	default y
@@ -1740,57 +1790,12 @@ config KALLSYMS_BASE_RELATIVE
 
 # end of the "standard kernel features (expert users)" menu
 
-# syscall, maps, verifier
-
 config ARCH_HAS_MEMBARRIER_CALLBACKS
 	bool
 
 config ARCH_HAS_MEMBARRIER_SYNC_CORE
 	bool
 
-config KCMP
-	bool "Enable kcmp() system call" if EXPERT
-	help
-	  Enable the kernel resource comparison system call. It provides
-	  user-space with the ability to compare two processes to see if they
-	  share a common resource, such as a file descriptor or even virtual
-	  memory space.
-
-	  If unsure, say N.
-
-config RSEQ
-	bool "Enable rseq() system call" if EXPERT
-	default y
-	depends on HAVE_RSEQ
-	select MEMBARRIER
-	help
-	  Enable the restartable sequences system call. It provides a
-	  user-space cache for the current CPU number value, which
-	  speeds up getting the current CPU number from user-space,
-	  as well as an ABI to speed up user-space operations on
-	  per-CPU data.
-
-	  If unsure, say Y.
-
-config CACHESTAT_SYSCALL
-	bool "Enable cachestat() system call" if EXPERT
-	default y
-	help
-	  Enable the cachestat system call, which queries the page cache
-	  statistics of a file (number of cached pages, dirty pages,
-	  pages marked for writeback, (recently) evicted pages).
-
-	  If unsure say Y here.
-
-config DEBUG_RSEQ
-	default n
-	bool "Enabled debugging of rseq() system call" if EXPERT
-	depends on RSEQ && DEBUG_KERNEL
-	help
-	  Enable extra debugging checks for the rseq system call.
-
-	  If unsure, say N.
-
 config HAVE_PERF_EVENTS
 	bool
 	help
@@ -1805,13 +1810,6 @@ config PERF_USE_VMALLOC
 	help
 	  See tools/perf/design.txt for details
 
-config PC104
-	bool "PC/104 support" if EXPERT
-	help
-	  Expose PC/104 form factor device drivers and options available for
-	  selection and configuration. Enable this option if your target
-	  machine has a PC/104 bus.
-
 menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
_

Patches currently in -mm which might be from rdunlap@infradead.org are

stacktrace-fix-kernel-doc-typo.patch
nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

