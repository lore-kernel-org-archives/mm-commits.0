From: akpm@linux-foundation.org
Subject: + docs-procs-describe-proc-pid-map_files-entry-fix.patch added to -mm tree
Date: Tue, 27 Jan 2015 14:19:26 -0800
Message-ID: <54c80eee.elj+uW61zG1M4g7Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbbA0WT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 17:19:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, calvinowens@fb.com, gorcunov@openvz.org, keescook@chromium.org, kirill@shutemov.name, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: docs-procs-describe-proc-pid-map_files-entry-fix
has been added to the -mm tree.  Its filename is
     docs-procs-describe-proc-pid-map_files-entry-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-procs-describe-proc-pid-map_files-entry-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-procs-describe-proc-pid-map_files-entry-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-procs-describe-proc-pid-map_files-entry-fix

tweaks

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Calvin Owens <calvinowens@fb.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/filesystems/proc.txt~docs-procs-describe-proc-pid-map_files-entry-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~docs-procs-describe-proc-pid-map_files-entry-fix
+++ a/Documentation/filesystems/proc.txt
@@ -1766,8 +1766,8 @@ pair provide additional information part
 
 3.9	/proc/<pid>/map_files - Information about memory mapped files
 ---------------------------------------------------------------------
-This directory consists of simbolic links which represent memory mapped files
-the process is carrying. A typical output is like the following
+This directory contains symbolic links which represent memory mapped files
+the process is maintaining.  Example output:
 
      | lr-------- 1 root root 64 Jan 27 11:24 333c600000-333c620000 -> /usr/lib64/ld-2.18.so
      | lr-------- 1 root root 64 Jan 27 11:24 333c81f000-333c820000 -> /usr/lib64/ld-2.18.so
@@ -1776,15 +1776,15 @@ the process is carrying. A typical outpu
      | lr-------- 1 root root 64 Jan 27 11:24 35d0421000-35d0422000 -> /usr/lib64/libselinux.so.1
      | lr-------- 1 root root 64 Jan 27 11:24 400000-41a000 -> /usr/bin/ls
 
-The name of a link is virtual memory bounds a particular map exhibits, i.e.
+The name of a link represents the virtual memory bounds of a mapping, i.e.
 vm_area_struct::vm_start-vm_area_struct::vm_end.
 
-The main purpose of map_files directory is to be able to retrieve a set of
-memory mapped files in a fast way instead of parsing /proc/<pid>/maps or
-/proc/<pid>/smaps which contain a way more records. Same time one can open(2)
-mappings from the listings of two processes and comparing inodes figure out
-which anonymous memory areas are actually shared.
-
+The main purpose of the map_files is to retrieve a set of memory mapped
+files in a fast way instead of parsing /proc/<pid>/maps or
+/proc/<pid>/smaps, both of which contain many more records.  At the same
+time one can open(2) mappings from the listings of two processes and
+comparing their inode numbers to figure out which anonymous memory areas
+are actually shared.
 
 ------------------------------------------------------------------------------
 Configuring procfs
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

