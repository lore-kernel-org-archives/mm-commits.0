From: akpm@linux-foundation.org
Subject: [folded-merged]
 docs-procs-describe-proc-pid-map_files-entry-fix.patch removed from -mm
 tree
Date: Wed, 11 Feb 2015 15:19:18 -0800
Message-ID: <54dbe376.+2yKOMs6iL46iFol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbBKXTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:19:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, calvinowens@fb.com, gorcunov@openvz.org, keescook@chromium.org, kirill@shutemov.name, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: docs-procs-describe-proc-pid-map_files-entry-fix
has been removed from the -mm tree.  Its filename was
     docs-procs-describe-proc-pid-map_files-entry-fix.patch

This patch was dropped because it was folded into docs-procs-describe-proc-pid-map_files-entry.patch

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
