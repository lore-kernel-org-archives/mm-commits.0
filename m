From: akpm@linux-foundation.org
Subject: + mm-document-missing-fields-for-proc-meminfo.patch added to -mm tree
Date: Tue, 18 Mar 2008 14:02:07 -0700
Message-ID: <200803182102.m2IL28kZ016112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757985AbYCSTmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, a.p.zijlstra@chello.nl


The patch titled
     mm: document missing fields for /proc/meminfo
has been added to the -mm tree.  Its filename is
     mm-document-missing-fields-for-proc-meminfo.patch

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
Subject: mm: document missing fields for /proc/meminfo
From: Miklos Szeredi <mszeredi@suse.cz>


A few fields in /proc/meminfo were not documented.  Fix.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: linux/Documentation/filesystems/proc.txt
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-document-missing-fields-for-proc-meminfo Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-document-missing-fields-for-proc-meminfo
+++ a/Documentation/filesystems/proc.txt
@@ -463,11 +463,17 @@ SwapTotal:           0 kB
 SwapFree:            0 kB
 Dirty:             968 kB
 Writeback:           0 kB
+AnonPages:      861800 kB
 Mapped:         280372 kB
-Slab:           684068 kB
+Slab:           284364 kB
+SReclaimable:   159856 kB
+SUnreclaim:     124508 kB
+PageTables:      24448 kB
+NFS_Unstable:        0 kB
+Bounce:              0 kB
+WritebackTmp:        0 kB
 CommitLimit:   7669796 kB
 Committed_AS:   100056 kB
-PageTables:      24448 kB
 VmallocTotal:   112216 kB
 VmallocUsed:       428 kB
 VmallocChunk:   111088 kB
@@ -503,8 +509,17 @@ VmallocChunk:   111088 kB
               on the disk
        Dirty: Memory which is waiting to get written back to the disk
    Writeback: Memory which is actively being written back to the disk
+   AnonPages: Non-file backed pages mapped into userspace page tables
       Mapped: files which have been mmaped, such as libraries
         Slab: in-kernel data structures cache
+SReclaimable: Part of Slab, that might be reclaimed, such as caches
+  SUnreclaim: Part of Slab, that cannot be reclaimed on memory pressure
+  PageTables: amount of memory dedicated to the lowest level of page
+              tables.
+NFS_Unstable: NFS pages sent to the server, but not yet committed to stable
+	      storage
+      Bounce: Memory used for block device "bounce buffers"
+WritebackTmp: Memory used by FUSE for temporary writeback buffers
  CommitLimit: Based on the overcommit ratio ('vm.overcommit_ratio'),
               this is the total amount of  memory currently available to
               be allocated on the system. This limit is only adhered to
@@ -531,8 +546,6 @@ Committed_AS: The amount of memory prese
               above) will not be permitted. This is useful if one needs
               to guarantee that processes will not fail due to lack of
               memory once that memory has been successfully allocated.
-  PageTables: amount of memory dedicated to the lowest level of page
-              tables.
 VmallocTotal: total size of vmalloc memory area
  VmallocUsed: amount of vmalloc area which is used
 VmallocChunk: largest contigious block of vmalloc area which is free
_

Patches currently in -mm which might be from mszeredi@suse.cz are

mm-rotate_reclaimable_page-cleanup.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
vfs-remove-lives_below_in_same_fs.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch

