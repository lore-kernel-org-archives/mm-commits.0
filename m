Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAF7481D4
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 19:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UYNoRkN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE3DC433C8;
	Fri,  8 Dec 2023 19:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702065301;
	bh=2+2LKwTz+gl1gVCoPreo5Im3lCpp6NzqOyXa19KFgMg=;
	h=Date:To:From:Subject:From;
	b=UYNoRkN6OCnUzgeXYzV+rdlv1snlizrCK6Sg4twhJOu8QtSIWevv7VdcPHMA+QGtj
	 5Az1xc7xsVfMvF3cOaKwgHtblzdJdNqPXzuf1v+zzDLgkKQNg78+SgtQUaE+m9OADb
	 ouVgrvbQAgD4MUHkWrpASVS/eLinCUlf5JLWyfb0=
Date: Fri, 08 Dec 2023 11:55:00 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,paulmck@kernel.org,mathieu.desnoyers@efficios.com,boqun.feng@gmail.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-kconfig-move-more-items-into-the-expert-menu.patch added to mm-nonmm-unstable branch
Message-Id: <20231208195501.2EE3DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/Kconfig: move more items into the EXPERT menu
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-kconfig-move-more-items-into-the-expert-menu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-kconfig-move-more-items-into-the-expert-menu.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch
init-kconfig-move-more-items-into-the-expert-menu.patch

