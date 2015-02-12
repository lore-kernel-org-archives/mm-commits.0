From: akpm@linux-foundation.org
Subject: [merged] docs-procs-describe-proc-pid-map_files-entry.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:39:03 -0800
Message-ID: <54dd0157.4TZGWAxLG0aOwtv6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbbBLTjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:39:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, calvinowens@fb.com, keescook@chromium.org, kirill@shutemov.name, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/proc.txt: describe /proc/<pid>/map_files
has been removed from the -mm tree.  Its filename was
     docs-procs-describe-proc-pid-map_files-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Documentation/filesystems/proc.txt: describe /proc/<pid>/map_files

[akpm@linux-foundation.org: tweaks]
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
+This directory contains symbolic links which represent memory mapped files
+the process is maintaining.  Example output:
+
+     | lr-------- 1 root root 64 Jan 27 11:24 333c600000-333c620000 -> /usr/lib64/ld-2.18.so
+     | lr-------- 1 root root 64 Jan 27 11:24 333c81f000-333c820000 -> /usr/lib64/ld-2.18.so
+     | lr-------- 1 root root 64 Jan 27 11:24 333c820000-333c821000 -> /usr/lib64/ld-2.18.so
+     | ...
+     | lr-------- 1 root root 64 Jan 27 11:24 35d0421000-35d0422000 -> /usr/lib64/libselinux.so.1
+     | lr-------- 1 root root 64 Jan 27 11:24 400000-41a000 -> /usr/bin/ls
+
+The name of a link represents the virtual memory bounds of a mapping, i.e.
+vm_area_struct::vm_start-vm_area_struct::vm_end.
+
+The main purpose of the map_files is to retrieve a set of memory mapped
+files in a fast way instead of parsing /proc/<pid>/maps or
+/proc/<pid>/smaps, both of which contain many more records.  At the same
+time one can open(2) mappings from the listings of two processes and
+comparing their inode numbers to figure out which anonymous memory areas
+are actually shared.
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
mm-pagemap-limit-scan-to-virtual-region-being-asked.patch

