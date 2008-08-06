From: akpm@linux-foundation.org
Subject: + make-ptrace_untrace-static.patch added to -mm tree
Date: Wed, 06 Aug 2008 15:53:05 -0700
Message-ID: <200808062253.m76Mr5if019817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbYHFWx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 18:53:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     make ptrace_untrace() static
has been added to the -mm tree.  Its filename is
     make-ptrace_untrace-static.patch

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
Subject: make ptrace_untrace() static
From: Adrian Bunk <bunk@kernel.org>

ptrace_untrace() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    1 -
 kernel/ptrace.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/ptrace.h~make-ptrace_untrace-static include/linux/ptrace.h
--- a/include/linux/ptrace.h~make-ptrace_untrace-static
+++ a/include/linux/ptrace.h
@@ -94,7 +94,6 @@ extern void ptrace_notify(int exit_code)
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
-extern void ptrace_untrace(struct task_struct *child);
 #define PTRACE_MODE_READ   1
 #define PTRACE_MODE_ATTACH 2
 /* Returns 0 on success, -errno on denial. */
diff -puN kernel/ptrace.c~make-ptrace_untrace-static kernel/ptrace.c
--- a/kernel/ptrace.c~make-ptrace_untrace-static
+++ a/kernel/ptrace.c
@@ -45,7 +45,7 @@ void __ptrace_link(struct task_struct *c
  * TASK_TRACED, resume it now.
  * Requires that irqs be disabled.
  */
-void ptrace_untrace(struct task_struct *child)
+static void ptrace_untrace(struct task_struct *child)
 {
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
reiser4.patch
fs-partitions-acornc-remove-dead-code.patch
the-overdue-eepro100-removal.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
parport-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
ntfs-update-homepage.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
binfmt_somc-add-module_license.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
the-scheduled-serial_coldfire-removal.patch

