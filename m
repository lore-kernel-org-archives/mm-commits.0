From: akpm@linux-foundation.org
Subject: + fs-proc-meminfoc-fix-compilation-error.patch added to -mm tree
Date: Wed, 16 Nov 2011 14:07:06 -0800
Message-ID: <201111162207.pAGM76Zq018383@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:63409 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1KPWHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2011 17:07:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: claudio@evidence.eu.com, aarcange@redhat.com, stable@vger.kernel.org


The patch titled
     Subject: fs/proc/meminfo.c: fix compilation error
has been added to the -mm tree.  Its filename is
     fs-proc-meminfoc-fix-compilation-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: fs/proc/meminfo.c: fix compilation error

Patches currently in -mm which might be from claudio@evidence.eu.com are

linux-next.patch
fs-proc-meminfoc-fix-compilation-error.patch

