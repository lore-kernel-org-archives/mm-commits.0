From: akpm@linux-foundation.org
Subject: [merged] arch-ia64-fix-continuation-line-formats.patch removed from -mm tree
Date: Thu, 11 Feb 2010 13:07:10 -0800
Message-ID: <201002112107.o1BL7BFb028693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756986Ab0BKVHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 16:07:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/ia64: fix continuation line formats
has been removed from the -mm tree.  Its filename was
     arch-ia64-fix-continuation-line-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/ia64: fix continuation line formats
From: Joe Perches <joe@perches.com>

String constants that are continued on subsequent lines with \ will cause
spurious whitespace in the resulting output.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kvm/mmio.c |    4 ++--
 arch/ia64/kvm/vcpu.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kvm/mmio.c~arch-ia64-fix-continuation-line-formats arch/ia64/kvm/mmio.c
--- a/arch/ia64/kvm/mmio.c~arch-ia64-fix-continuation-line-formats
+++ a/arch/ia64/kvm/mmio.c
@@ -316,8 +316,8 @@ void emulate_io_inst(struct kvm_vcpu *vc
 		return;
 	} else {
 		inst_type = -1;
-		panic_vm(vcpu, "Unsupported MMIO access instruction! \
-				Bunld[0]=0x%lx, Bundle[1]=0x%lx\n",
+		panic_vm(vcpu, "Unsupported MMIO access instruction! "
+				"Bunld[0]=0x%lx, Bundle[1]=0x%lx\n",
 				bundle.i64[0], bundle.i64[1]);
 	}
 
diff -puN arch/ia64/kvm/vcpu.c~arch-ia64-fix-continuation-line-formats arch/ia64/kvm/vcpu.c
--- a/arch/ia64/kvm/vcpu.c~arch-ia64-fix-continuation-line-formats
+++ a/arch/ia64/kvm/vcpu.c
@@ -1639,8 +1639,8 @@ void vcpu_set_psr(struct kvm_vcpu *vcpu,
 	 * Otherwise panic
 	 */
 	if (val & (IA64_PSR_PK | IA64_PSR_IS | IA64_PSR_VM))
-		panic_vm(vcpu, "Only support guests with vpsr.pk =0 \
-				& vpsr.is=0\n");
+		panic_vm(vcpu, "Only support guests with vpsr.pk =0 "
+				"& vpsr.is=0\n");
 
 	/*
 	 * For those IA64_PSR bits: id/da/dd/ss/ed/ia
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-staging-fix-continuation-line-formats.patch
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
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
maintainers-document-and-add-q-patchwork-queue-entries.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
checkpatch-warn-on-unnecessary-spaces-before-quoted-newlines.patch
drivers-hwmon-vt8231c-fix-continuation-line-formats.patch
drivers-video-via-fix-continuation-line-formats.patch

