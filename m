From: akpm@linux-foundation.org
Subject: [merged] acpi-remove-superfluous-null-pointer-check-from-acpi_processor_get_throttling_info.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:33 -0800
Message-ID: <201002182045.o1IKjXh7002748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:46:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bzolnier@gmail.com, corbet@lwn.net, error27@gmail.com, eteo@redhat.com, lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: remove superfluous NULL pointer check from acpi_processor_get_throttling_info()
has been removed from the -mm tree.  Its filename was
     acpi-remove-superfluous-null-pointer-check-from-acpi_processor_get_throttling_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: remove superfluous NULL pointer check from acpi_processor_get_throttling_info()
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Dan's list contains:

drivers/acpi/processor_throttling.c +1139 acpi_processor_get_throttling_info(11) warning: variable derefenced before check 'pr'

acpi_processor_get_throttling_info() is never called with pr == NULL.

[ bart: the potential NULL pointer dereference was finally fixed in
  (much later than mine) commit 5cfa245 but my patch is still valid ]

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-remove-superfluous-null-pointer-check-from-acpi_processor_get_throttling_info drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-remove-superfluous-null-pointer-check-from-acpi_processor_get_throttling_info
+++ a/drivers/acpi/processor_throttling.c
@@ -1133,9 +1133,6 @@ int acpi_processor_get_throttling_info(s
 	int result = 0;
 	struct acpi_processor_throttling *pthrottling;
 
-	if (!pr)
-		return -EINVAL;
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			  "pblk_address[0x%08x] duty_offset[%d] duty_width[%d]\n",
 			  pr->throttling.address,
_

Patches currently in -mm which might be from bzolnier@gmail.com are

linux-next.patch
acpica-fix-acpi_ex_release_mutex-comment.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
staging-rt2860-correct-onstack-wait_queue_head-declaration.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch

