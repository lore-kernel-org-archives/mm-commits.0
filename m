From: akpm@linux-foundation.org
Subject: [nacked] shmem-avoid-huge-pages-for-small-files.patch removed
 from -mm tree
Date: Mon, 07 Nov 2016 15:33:54 -0800
Message-ID: <58210f62.r8sHEEwaxXVgp6fh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45948 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752168AbcKGXdz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2016 18:33:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, david@fromorbit.com, hughd@google.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: avoid huge pages for small files
has been removed from the -mm tree.  Its filename was
     shmem-avoid-huge-pages-for-small-files.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: shmem: avoid huge pages for small files

Huge pages are detrimental for small file: they causes noticible overhead
on both allocation performance and memory footprint.

This patch aimed to address this issue by avoiding huge pages until file
grown to size of huge page.  This would cover most of the cases where huge
pages causes regressions in performance.

Couple notes:

  - if shmem_enabled is set to 'force', the limit is ignored. We still
    want to generate as many pages as possible for functional testing.

  - the limit doesn't affect khugepaged behaviour: it still can collapse
    pages based on its settings;

Link: http://lkml.kernel.org/r/20161021224629.tnwuvruhblkg22qj@black.fi.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    3 +++
 mm/shmem.c                     |    5 +++++
 2 files changed, 8 insertions(+)

diff -puN Documentation/vm/transhuge.txt~shmem-avoid-huge-pages-for-small-files Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~shmem-avoid-huge-pages-for-small-files
+++ a/Documentation/vm/transhuge.txt
@@ -238,6 +238,9 @@ values:
   - "force":
     Force the huge option on for all - very useful for testing;
 
+To avoid overhead for small files, we don't allocate huge pages for a file
+until it grows to size of huge pages.
+
 == Need of application restart ==
 
 The transparent_hugepage/enabled values and tmpfs mount option only affect
diff -puN mm/shmem.c~shmem-avoid-huge-pages-for-small-files mm/shmem.c
--- a/mm/shmem.c~shmem-avoid-huge-pages-for-small-files
+++ a/mm/shmem.c
@@ -1692,6 +1692,11 @@ repeat:
 				goto alloc_huge;
 			/* TODO: implement fadvise() hints */
 			goto alloc_nohuge;
+		case SHMEM_HUGE_ALWAYS:
+			i_size = i_size_read(inode);
+			if (index < HPAGE_PMD_NR && i_size < HPAGE_PMD_SIZE)
+				goto alloc_nohuge;
+			break;
 		}
 
 alloc_huge:
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


