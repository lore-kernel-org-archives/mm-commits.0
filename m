From: akpm@linux-foundation.org
Subject: [merged] coredump-add-support-for-%d=__get_dumpable-in-core-name.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:27 -0700
Message-ID: <20121005201928.3DA555C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:44439 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:31 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so139632eek.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, alan@lxorguk.ukuu.org.uk, alex.page.kelly@gmail.com, amwang@redhat.com, andi@firstfloor.org, jmoskovc@redhat.com, nhorman@tuxdriver.com, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: add support for %d=__get_dumpable() in core name
has been removed from the -mm tree.  Its filename was
     coredump-add-support-for-%d=__get_dumpable-in-core-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: add support for %d=__get_dumpable() in core name

Some coredump handlers want to create a core file in a way compatible with
standard behavior.  Standard behavior with fs.suid_dumpable = 2 is to
create core file with uid=gid=0.  However, there was no way for coredump
handler to know that the process being dumped was suid'ed.

This patch adds the new %d specifier for format_corename() which simply
reports __get_dumpable(mm->flags), this is compatible with
/proc/sys/fs/suid_dumpable we already have.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=787135

Developed during a discussion with Denys Vlasenko.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Alex Kelly <alex.page.kelly@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Cong Wang <amwang@redhat.com>
Cc: Jiri Moskovcak <jmoskovc@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 ++
 fs/coredump.c                   |   10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~coredump-add-support-for-%d=__get_dumpable-in-core-name Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~coredump-add-support-for-%d=__get_dumpable-in-core-name
+++ a/Documentation/sysctl/kernel.txt
@@ -181,6 +181,8 @@ core_pattern is used to specify a core d
 	%p	pid
 	%u	uid
 	%g	gid
+	%d	dump mode, matches PR_SET_DUMPABLE and
+		/proc/sys/fs/suid_dumpable
 	%s	signal number
 	%t	UNIX time of dump
 	%h	hostname
diff -puN fs/coredump.c~coredump-add-support-for-%d=__get_dumpable-in-core-name fs/coredump.c
--- a/fs/coredump.c~coredump-add-support-for-%d=__get_dumpable-in-core-name
+++ a/fs/coredump.c
@@ -149,7 +149,7 @@ put_exe_file:
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(struct core_name *cn, long signr)
+static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 {
 	const struct cred *cred = current_cred();
 	const char *pat_ptr = core_pattern;
@@ -194,9 +194,13 @@ static int format_corename(struct core_n
 			case 'g':
 				err = cn_printf(cn, "%d", cred->gid);
 				break;
+			case 'd':
+				err = cn_printf(cn, "%d",
+					__get_dumpable(cprm->mm_flags));
+				break;
 			/* signal that caused the coredump */
 			case 's':
-				err = cn_printf(cn, "%ld", signr);
+				err = cn_printf(cn, "%ld", cprm->signr);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
@@ -515,7 +519,7 @@ void do_coredump(long signr, int exit_co
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	ispipe = format_corename(&cn, signr);
+	ispipe = format_corename(&cn, &cprm);
 
  	if (ispipe) {
 		int dump_count;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch

