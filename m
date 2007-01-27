From: akpm@osdl.org
Subject: - core-dumping-unreadable-binaries-via-pt_interp.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:35 -0800
Message-ID: <200701270132.l0R1WZkG031941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35589 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbXA0Bcs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:32:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, mm-commits@vger.kernel.org


The patch titled
     core-dumping unreadable binaries via PT_INTERP
has been removed from the -mm tree.  Its filename was
     core-dumping-unreadable-binaries-via-pt_interp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: core-dumping unreadable binaries via PT_INTERP
From: Alexey Dobriyan <adobriyan@openvz.org>

Proposed patch to fix #5 in
http://www.isec.pl/vulnerabilities/isec-0017-binfmt_elf.txt
aka
http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2004-1073

To reproduce, do
* grab poc at the end of advisory.
* add line "eph.p_memsz = 4096;" after "eph.p_filesz = 4096;"
  where first "4096" is something equal to or greater than 4096.
* ./poc /usr/bin/sudo && ls -l

Here I get with 2.6.20-rc5:

 -rw------- 1 ad   ad   102400 2007-01-15 19:17 core
 ---s--x--x 2 root root 101820 2007-01-15 19:15 /usr/bin/sudo

Check for MAY_READ like binfmt_misc.c does.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/binfmt_elf.c       |    9 +++++++++
 fs/binfmt_elf_fdpic.c |    8 ++++++++
 2 files changed, 17 insertions(+)

diff -puN fs/binfmt_elf.c~core-dumping-unreadable-binaries-via-pt_interp fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~core-dumping-unreadable-binaries-via-pt_interp
+++ a/fs/binfmt_elf.c
@@ -682,6 +682,15 @@ static int load_elf_binary(struct linux_
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter))
 				goto out_free_interp;
+
+			/*
+			 * If the binary is not readable then enforce
+			 * mm->dumpable = 0 regardless of the interpreter's
+			 * permissions.
+			 */
+			if (file_permission(interpreter, MAY_READ) < 0)
+				bprm->interp_flags |= BINPRM_FLAGS_ENFORCE_NONDUMP;
+
 			retval = kernel_read(interpreter, 0, bprm->buf,
 					     BINPRM_BUF_SIZE);
 			if (retval != BINPRM_BUF_SIZE) {
diff -puN fs/binfmt_elf_fdpic.c~core-dumping-unreadable-binaries-via-pt_interp fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~core-dumping-unreadable-binaries-via-pt_interp
+++ a/fs/binfmt_elf_fdpic.c
@@ -234,6 +234,14 @@ static int load_elf_fdpic_binary(struct 
 				goto error;
 			}
 
+			/*
+			 * If the binary is not readable then enforce
+			 * mm->dumpable = 0 regardless of the interpreter's
+			 * permissions.
+			 */
+			if (file_permission(interpreter, MAY_READ) < 0)
+				bprm->interp_flags |= BINPRM_FLAGS_ENFORCE_NONDUMP;
+
 			retval = kernel_read(interpreter, 0, bprm->buf,
 					     BINPRM_BUF_SIZE);
 			if (retval < 0)
_

Patches currently in -mm which might be from adobriyan@openvz.org are

origin.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
introduce-and-use-get_task_mnt_ns.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
