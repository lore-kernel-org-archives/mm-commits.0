From: akpm@linux-foundation.org
Subject: [merged] fs-proc-meminfoc-fix-compilation-error.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:07:48 -0800
Message-ID: <201112092007.pB9K7mBH027184@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:55076 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab1LIUHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: claudio@evidence.eu.com, aarcange@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/meminfo.c: fix compilation error
has been removed from the -mm tree.  Its filename was
     fs-proc-meminfoc-fix-compilation-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Claudio Scordino <claudio@evidence.eu.com>
Subject: fs/proc/meminfo.c: fix compilation error

Fix the error message "directives may not be used inside a macro argument"
which appears when the kernel is compiled for the cris architecture.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/proc/meminfo.c~fs-proc-meminfoc-fix-compilation-error fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~fs-proc-meminfoc-fix-compilation-error
+++ a/fs/proc/meminfo.c
@@ -131,12 +131,13 @@ static int meminfo_proc_show(struct seq_
 		K(i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
 		K(global_page_state(NR_WRITEBACK)),
-		K(global_page_state(NR_ANON_PAGES)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		K(global_page_state(NR_ANON_PAGES)
 		  + global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
-		  HPAGE_PMD_NR
+		  HPAGE_PMD_NR),
+#else
+		K(global_page_state(NR_ANON_PAGES)),
 #endif
-		  ),
 		K(global_page_state(NR_FILE_MAPPED)),
 		K(global_page_state(NR_SHMEM)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
_

Patches currently in -mm which might be from claudio@evidence.eu.com are

origin.patch

