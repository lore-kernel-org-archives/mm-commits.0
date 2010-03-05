From: akpm@linux-foundation.org
Subject: [failures] vsprintf-recursive-vsnprintf-add-%pv-struct-va_format.patch removed from -mm tree
Date: Thu, 04 Mar 2010 16:30:27 -0800
Message-ID: <201003050056.o250ubar007807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756561Ab0CEA4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 19:56:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, greg@kroah.com, kay.sievers@vrfy.org, nick@nick-andrew.net, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     vsprintf: recursive vsnprintf: add "%pV", struct va_format
has been removed from the -mm tree.  Its filename was
     vsprintf-recursive-vsnprintf-add-%pv-struct-va_format.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vsprintf: recursive vsnprintf: add "%pV", struct va_format
From: Joe Perches <joe@perches.com>

dev_<level> macros use a lot of repetitive string space.

Eliminate the string prefixes and function arguments from all the macro
uses and consolidate them in functions.

This patchset saves about 60K.

This implementation also adds the ability to use a struct va_format to
emit a format string along with va_list arguments.

This %pV implementation should not be used without a wrapper that does
printf argument verification like the dev_<level> functions.

Inspired a bit by Nick Andrew's patches and Linus' comments in December 2008
http://lkml.org/lkml/2008/12/6/15
http://lkml.org/lkml/2008/12/6/101


This patch:

Add the ability to print a format and va_list from a structure pointer

Allows __dev_printk to be implemented as a single printk while
minimizing string space duplication.

%pV should not be used without some mechanism to verify the
format and argument use ala __attribute__(format (printf(...))).

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Andrew <nick@nick-andrew.net>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 +++++
 lib/vsprintf.c         |    9 +++++++++
 2 files changed, 14 insertions(+)

diff -puN include/linux/kernel.h~vsprintf-recursive-vsnprintf-add-%pv-struct-va_format include/linux/kernel.h
--- a/include/linux/kernel.h~vsprintf-recursive-vsnprintf-add-%pv-struct-va_format
+++ a/include/linux/kernel.h
@@ -169,6 +169,11 @@ static inline void might_fault(void)
 }
 #endif
 
+struct va_format {
+	const char *fmt;
+	va_list *va;
+};
+
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
diff -puN lib/vsprintf.c~vsprintf-recursive-vsnprintf-add-%pv-struct-va_format lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-recursive-vsnprintf-add-%pv-struct-va_format
+++ a/lib/vsprintf.c
@@ -950,6 +950,11 @@ static char *uuid_string(char *buf, char
  *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
  *           little endian output byte order is:
  *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
+ * - 'V' For a struct va_format which contains a format string * and va_list *,
+ *       call vsnprintf(->format, *->va_list).
+ *       Implements a "recursive vsnprintf".
+ *       Do not use this feature without some mechanism to verify the
+ *       correctness of the format string and va_list arguments.
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -994,6 +999,10 @@ static char *pointer(const char *fmt, ch
 		break;
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
+	case 'V':
+		return buf + vsnprintf(buf, end - buf,
+				       ((struct va_format *)ptr)->fmt,
+				       *(((struct va_format *)ptr)->va));
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
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
vsprintf-recursive-vsnprintf-add-%pv-struct-va_format.patch
deviceh-drivers-base-corec-convert-dev_level-macros-to-functions.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
scripts-get_maintainerpl-add-ability-to-read-from-stdin.patch
get_maintainer-fix-perlcritic-warnings.patch
get_maintainer-quote-email-address-with-period.patch
scripts-get_maintainerpl-fix-possible-infinite-loop.patch
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

