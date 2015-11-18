From: akpm@linux-foundation.org
Subject: +
 mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status.patch
 added to -mm tree
Date: Wed, 18 Nov 2015 13:59:20 -0800
Message-ID: <564cf4b8.DbhMQXnaR28Knt4b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbbKRV7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 16:59:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hughd@google.com, khlebnikov@yandex-team.ru, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, procfs: breakdown RSS for anon, shmem and file in /proc/pid/status
has been added to the -mm tree.  Its filename is
     mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Marchand <jmarchan@redhat.com>
Subject: mm, procfs: breakdown RSS for anon, shmem and file in /proc/pid/status

There are several shortcomings with the accounting of shared memory (SysV
shm, shared anonymous mapping, mapping of a tmpfs file).  The values in
/proc/<pid>/status and <...>/statm don't allow to distinguish between
shmem memory and a shared mapping to a regular file, even though theirs
implication on memory usage are quite different: during reclaim, file
mapping can be dropped or written back on disk, while shmem needs a place
in swap.

Also, to distinguish the memory occupied by anonymous and file mappings,
one has to read the /proc/pid/statm file, which has a field for the file
mappings (again, including shmem) and total memory occupied by these
mappings (i.e.  equivalent to VmRSS in the <...>/status file.  Getting the
value for anonymous mappings only is thus not exactly user-friendly (the
statm file is intended to be rather efficiently machine-readable).

To address both of these shortcomings, this patch adds a breakdown of
VmRSS in /proc/<pid>/status via new fields RssAnon, RssFile and RssShmem,
making use of the previous preparatory patch.  These fields tell the user
the memory occupied by private anonymous pages, mapped regular files and
shmem, respectively.  Other existing fields in /status and /statm files
are left without change.  The /statm file can be extended in the future,
if there's a need for that.

Example (part of) /proc/pid/status output including the new Rss* fields:

VmPeak:  2001008 kB
VmSize:  2001004 kB
VmLck:         0 kB
VmPin:         0 kB
VmHWM:      5108 kB
VmRSS:      5108 kB
RssAnon:              92 kB
RssFile:            1324 kB
RssShmem:           3692 kB
VmData:      192 kB
VmStk:       136 kB
VmExe:         4 kB
VmLib:      1784 kB
VmPTE:      3928 kB
VmPMD:        20 kB
VmSwap:        0 kB
HugetlbPages:          0 kB

[vbabka@suse.cz: forward-porting, tweak changelog]
Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   13 +++++++++++--
 fs/proc/task_mmu.c                 |   14 ++++++++++++--
 2 files changed, 23 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status
+++ a/Documentation/filesystems/proc.txt
@@ -169,6 +169,9 @@ read the file /proc/PID/status:
   VmLck:         0 kB
   VmHWM:       476 kB
   VmRSS:       476 kB
+  RssAnon:             352 kB
+  RssFile:             120 kB
+  RssShmem:              4 kB
   VmData:      156 kB
   VmStk:        88 kB
   VmExe:        68 kB
@@ -231,7 +234,12 @@ Table 1-2: Contents of the status files
  VmSize                      total program size
  VmLck                       locked memory size
  VmHWM                       peak resident set size ("high water mark")
- VmRSS                       size of memory portions
+ VmRSS                       size of memory portions. It contains the three
+                             following parts (VmRSS = RssAnon + RssFile + RssShmem)
+ RssAnon                     size of resident anonymous memory
+ RssFile                     size of resident file mappings
+ RssShmem                    size of resident shmem memory (includes SysV shm,
+                             mapping of tmpfs and shared anonymous mappings)
  VmData                      size of data, stack, and text segments
  VmStk                       size of data, stack, and text segments
  VmExe                       size of text segment
@@ -266,7 +274,8 @@ Table 1-3: Contents of the statm files (
  Field    Content
  size     total program size (pages)		(same as VmSize in status)
  resident size of memory portions (pages)	(same as VmRSS in status)
- shared   number of pages that are shared	(i.e. backed by a file)
+ shared   number of pages that are shared	(i.e. backed by a file, same
+						as RssFile+RssShmem in status)
  trs      number of pages that are 'code'	(not including libs; broken,
 							includes data segment)
  lrs      number of pages of library		(always 0 on 2.6)
diff -puN fs/proc/task_mmu.c~mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status
+++ a/fs/proc/task_mmu.c
@@ -23,9 +23,13 @@
 
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
-	unsigned long data, text, lib, swap, ptes, pmds;
+	unsigned long data, text, lib, swap, ptes, pmds, anon, file, shmem;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
+	anon = get_mm_counter(mm, MM_ANONPAGES);
+	file = get_mm_counter(mm, MM_FILEPAGES);
+	shmem = get_mm_counter(mm, MM_SHMEMPAGES);
+
 	/*
 	 * Note: to minimize their overhead, mm maintains hiwater_vm and
 	 * hiwater_rss only when about to *lower* total_vm or rss.  Any
@@ -36,7 +40,7 @@ void task_mem(struct seq_file *m, struct
 	hiwater_vm = total_vm = mm->total_vm;
 	if (hiwater_vm < mm->hiwater_vm)
 		hiwater_vm = mm->hiwater_vm;
-	hiwater_rss = total_rss = get_mm_rss(mm);
+	hiwater_rss = total_rss = anon + file + shmem;
 	if (hiwater_rss < mm->hiwater_rss)
 		hiwater_rss = mm->hiwater_rss;
 
@@ -53,6 +57,9 @@ void task_mem(struct seq_file *m, struct
 		"VmPin:\t%8lu kB\n"
 		"VmHWM:\t%8lu kB\n"
 		"VmRSS:\t%8lu kB\n"
+		"RssAnon:\t%8lu kB\n"
+		"RssFile:\t%8lu kB\n"
+		"RssShmem:\t%8lu kB\n"
 		"VmData:\t%8lu kB\n"
 		"VmStk:\t%8lu kB\n"
 		"VmExe:\t%8lu kB\n"
@@ -66,6 +73,9 @@ void task_mem(struct seq_file *m, struct
 		mm->pinned_vm << (PAGE_SHIFT-10),
 		hiwater_rss << (PAGE_SHIFT-10),
 		total_rss << (PAGE_SHIFT-10),
+		anon << (PAGE_SHIFT-10),
+		file << (PAGE_SHIFT-10),
+		shmem << (PAGE_SHIFT-10),
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
 		ptes >> 10,
_

Patches currently in -mm which might be from jmarchan@redhat.com are

mm-vmalloc-dont-remove-inexistent-guard-hole-in-remove_vm_area.patch
mm-shmem-add-internal-shmem-resident-memory-accounting.patch
mm-procfs-breakdown-rss-for-anon-shmem-and-file-in-proc-pid-status.patch

