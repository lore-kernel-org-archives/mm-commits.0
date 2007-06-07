From: akpm@linux-foundation.org
Subject: + schedstats-fix-printk-format.patch added to -mm tree
Date: Wed, 06 Jun 2007 19:04:01 -0700
Message-ID: <200706070204.l57241N8018448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934919AbXFGCEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 22:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu


The patch titled
     schedstats: fix printk format
has been added to the -mm tree.  Its filename is
     schedstats-fix-printk-format.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: schedstats: fix printk format
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings for schedstats:

fs/proc/base.c:309: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'
fs/proc/base.c:309: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'long long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~schedstats-fix-printk-format fs/proc/base.c
--- a/fs/proc/base.c~schedstats-fix-printk-format
+++ a/fs/proc/base.c
@@ -301,7 +301,7 @@ static int proc_pid_wchan(struct task_st
  */
 static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 {
-	return sprintf(buffer, "%lu %lu %lu\n",
+	return sprintf(buffer, "%llu %llu %lu\n",
 			task->sched_info.cpu_time,
 			task->sched_info.run_delay,
 			task->sched_info.pcnt);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
isdn-diva-fix-section-mismatch.patch
git-acpi.patch
toshica_acpi-fix-section-mismatch-in-allyesconfig.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
mac80211-fix-1-bit-bitfield-to-unsigned.patch
git-ipwireless_cs.patch
x86_64-use-null-for-pointer.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
hexdump-more-output-formatting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
