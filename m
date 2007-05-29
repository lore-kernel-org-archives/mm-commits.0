From: akpm@linux-foundation.org
Subject: + coredump-masking-documentation-for-proc-pid-coredump_filter.patch added to -mm tree
Date: Tue, 29 May 2007 14:40:28 -0700
Message-ID: <200705292140.l4TLeSOV012335@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbXE2Vkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au, rdunlap@xenotime.net


The patch titled
     coredump masking: documentation for /proc/pid/coredump_filter
has been added to the -mm tree.  Its filename is
     coredump-masking-documentation-for-proc-pid-coredump_filter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coredump masking: documentation for /proc/pid/coredump_filter
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>

This patch adds the documentation for /proc/<pid>/coredump_filter.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   38 +++++++++++++++++++++++++++
 1 files changed, 38 insertions(+)

diff -puN Documentation/filesystems/proc.txt~coredump-masking-documentation-for-proc-pid-coredump_filter Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~coredump-masking-documentation-for-proc-pid-coredump_filter
+++ a/Documentation/filesystems/proc.txt
@@ -42,6 +42,7 @@ Table of Contents
   2.12	/proc/<pid>/oom_adj - Adjust the oom-killer score
   2.13	/proc/<pid>/oom_score - Display current oom-killer score
   2.14	/proc/<pid>/io - Display the IO accounting fields
+  2.15	/proc/<pid>/coredump_filter - Core dump filtering settings
 
 ------------------------------------------------------------------------------
 Preface
@@ -2135,4 +2136,41 @@ those 64-bit counters, process A could s
 More information about this can be found within the taskstats documentation in
 Documentation/accounting.
 
+2.15 /proc/<pid>/coredump_filter - Core dump filtering settings
+---------------------------------------------------------------
+When a process is dumped, all anonymous memory is written to a core file as
+long as the size of the core file isn't limited. But sometimes we don't want
+to dump some memory segments, for example, huge shared memory. Conversely,
+sometimes we want to save file-backed memory segments into a core file, not
+only the individual files.
+
+/proc/<pid>/coredump_filter allows you to customize which memory segments
+will be dumped when the <pid> process is dumped. coredump_filter is a bitmask
+of memory types. If a bit of the bitmask is set, memory segments of the
+corresponding memory type are dumped, otherwise they are not dumped.
+
+The following 4 memory types are supported:
+  - (bit 0) anonymous private memory
+  - (bit 1) anonymous shared memory
+  - (bit 2) file-backed private memory
+  - (bit 3) file-backed shared memory
+
+  Note that MMIO pages such as frame buffer are never dumped and vDSO pages
+  are always dumped regardless of the bitmask status.
+
+Default value of coredump_filter is 0x3; this means all anonymous memory
+segments are dumped.
+
+If you don't want to dump all shared memory segments attached to pid 1234,
+write 1 to the process's proc file.
+
+  $ echo 0x1 > /proc/1234/coredump_filter
+
+When a new process is created, the process inherits the bitmask status from its
+parent. It is useful to set up coredump_filter before the program runs.
+For example:
+
+  $ echo 0x7 > /proc/self/coredump_filter
+  $ ./some_program
+
 ------------------------------------------------------------------------------
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
