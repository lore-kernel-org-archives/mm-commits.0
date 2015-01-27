From: akpm@linux-foundation.org
Subject: + docs-procs-describe-proc-pid-map_files-entry.patch added to -mm tree
Date: Tue, 27 Jan 2015 14:19:24 -0800
Message-ID: <54c80eec.QgyCHSiGvhe1hF97%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070AbbA0WTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 17:19:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, calvinowens@fb.com, keescook@chromium.org, kirill@shutemov.name, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/proc.txt: describe /proc/<pid>/map_files
has been added to the -mm tree.  Its filename is
     docs-procs-describe-proc-pid-map_files-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-procs-describe-proc-pid-map_files-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-procs-describe-proc-pid-map_files-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Documentation/filesystems/proc.txt: describe /proc/<pid>/map_files

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Calvin Owens <calvinowens@fb.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN Documentation/filesystems/proc.txt~docs-procs-describe-proc-pid-map_files-entry Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~docs-procs-describe-proc-pid-map_files-entry
+++ a/Documentation/filesystems/proc.txt
@@ -42,6 +42,7 @@ Table of Contents
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
   3.7   /proc/<pid>/task/<tid>/children - Information about task children
   3.8   /proc/<pid>/fdinfo/<fd> - Information about opened file
+  3.9   /proc/<pid>/map_files - Information about memory mapped files
 
   4	Configuring procfs
   4.1	Mount options
@@ -1763,6 +1764,28 @@ pair provide additional information part
 	with TIMER_ABSTIME option which will be shown in 'settime flags', but 'it_value'
 	still exhibits timer's remaining time.
 
+3.9	/proc/<pid>/map_files - Information about memory mapped files
+---------------------------------------------------------------------
+This directory consists of simbolic links which represent memory mapped files
+the process is carrying. A typical output is like the following
+
+     | lr-------- 1 root root 64 Jan 27 11:24 333c600000-333c620000 -> /usr/lib64/ld-2.18.so
+     | lr-------- 1 root root 64 Jan 27 11:24 333c81f000-333c820000 -> /usr/lib64/ld-2.18.so
+     | lr-------- 1 root root 64 Jan 27 11:24 333c820000-333c821000 -> /usr/lib64/ld-2.18.so
+     | ...
+     | lr-------- 1 root root 64 Jan 27 11:24 35d0421000-35d0422000 -> /usr/lib64/libselinux.so.1
+     | lr-------- 1 root root 64 Jan 27 11:24 400000-41a000 -> /usr/bin/ls
+
+The name of a link is virtual memory bounds a particular map exhibits, i.e.
+vm_area_struct::vm_start-vm_area_struct::vm_end.
+
+The main purpose of map_files directory is to be able to retrieve a set of
+memory mapped files in a fast way instead of parsing /proc/<pid>/maps or
+/proc/<pid>/smaps which contain a way more records. Same time one can open(2)
+mappings from the listings of two processes and comparing inodes figure out
+which anonymous memory areas are actually shared.
+
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------
_

Patches currently in -mm which might be from gorcunov@openvz.org are

mm-pagemap-limit-scan-to-virtual-region-being-asked.patch
arm-define-__pagetable_pmd_folded-for-lpae.patch
mm-account-pmd-page-tables-to-the-process.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
docs-procs-describe-proc-pid-map_files-entry.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch

