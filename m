From: akpm@linux-foundation.org
Subject: + coredump-add-support-for-%d=__get_dumpable-in-core-name.patch added to -mm tree
Date: Thu, 13 Sep 2012 15:26:20 -0700
Message-ID: <20120913222621.33EB75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42420 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab2IMW0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 18:26:24 -0400
Received: by weyr1 with SMTP id r1so219197wey.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 15:26:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, alan@lxorguk.ukuu.org.uk, alex.page.kelly@gmail.com, amwang@redhat.com, andi@firstfloor.org, jmoskovc@redhat.com, nhorman@tuxdriver.com, vda.linux@googlemail.com


The patch titled
     Subject: coredump: add support for %d=__get_dumpable() in core name
has been added to the -mm tree.  Its filename is
     coredump-add-support-for-%d=__get_dumpable-in-core-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/coredump.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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
@@ -524,7 +528,7 @@ void do_coredump(long signr, int exit_co
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	ispipe = format_corename(&cn, signr);
+	ispipe = format_corename(&cn, &cprm);
 
  	if (ispipe) {
 		int dump_count;
_

Patches currently in -mm which might be from oleg@redhat.com are

pid-namespace-limit-value-of-ns_last_pid-to-0-max_pid.patch
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
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch

