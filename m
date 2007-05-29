From: akpm@linux-foundation.org
Subject: + coredump-masking-bound-suid_dumpable-sysctl.patch added to -mm tree
Date: Tue, 29 May 2007 14:40:15 -0700
Message-ID: <200705292140.l4TLeGjT012312@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbXE2Vke (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:40:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, hugh@veritas.com, nickpiggin@yahoo.com.au


The patch titled
     coredump masking: bound suid_dumpable sysctl
has been added to the -mm tree.  Its filename is
     coredump-masking-bound-suid_dumpable-sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coredump masking: bound suid_dumpable sysctl
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>

This patch series is version 5 of the core dump masking feature, which
controls which VMAs should be dumped based on their memory types and
per-process flags.

I adopted most of Andrew's suggestion at the previous version.  He also
suggested using system call instead of /proc/<pid>/ interface, I decided to
use the latter continuously because adding new system call with pid argument
will give a big impact on the kernel.  


You can access the per-process flags via /proc/<pid>/coredump_filter
interface.  coredump_filter represents a bitmask of memory types, and if a bit
is set, VMAs of corresponding memory type are written into a core file when
the process is dumped.  The bitmask is inherited from the parent process when
a process is created.

The original purpose is to avoid longtime system slowdown when a number of
processes which share a huge shared memory are dumped at the same time.  To
achieve this purpose, this patch series adds an ability to suppress dumping
anonymous shared memory for specified processes.  In this version, three other
memory types are also supported.

Here are the coredump_filter bits:
  bit 0: anonymous private memory
  bit 1: anonymous shared memory
  bit 2: file-backed private memory
  bit 3: file-backed shared memory

The default value of coredump_filter is 0x3.  This means the new core dump
routine has the same behavior as conventional behavior by default.

In this version, coredump_filter bits and mm.dumpable are merged into
mm.flags, and it is accessed by atomic bitops.

The supported core file formats are ELF and ELF-FDPIC.  ELF has been tested,
but ELF-FDPIC has not been built and tested because I don't have the test
environment.



This patch limits a value of suid_dumpable sysctl to the range of 0 to 2.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~coredump-masking-bound-suid_dumpable-sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~coredump-masking-bound-suid_dumpable-sysctl
+++ a/kernel/sysctl.c
@@ -690,6 +690,7 @@ static ctl_table kern_table[] = {
 /* Constants for minimum and maximum testing in vm_table.
    We use these as one-element integer vectors. */
 static int zero;
+static int two = 2;
 static int one_hundred = 100;
 
 
@@ -1117,7 +1118,10 @@ static ctl_table fs_table[] = {
 		.data		= &max_user_mounts,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 	{
 		.ctl_name	= KERN_SETUID_DUMPABLE,
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
