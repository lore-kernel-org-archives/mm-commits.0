From: akpm@linux-foundation.org
Subject: [folded] coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:31:16 -0700
Message-ID: <20120323213116.64B31A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:65523 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2CWVbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:31:17 -0400
Received: by ggnd2 with SMTP id d2so565813ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:31:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, avi@redhat.com, cmetcalf@tilera.com, jbaron@redhat.com, roland@hack.frob.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix
has been removed from the -mm tree.  Its filename was
     coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch

This patch was dropped because it was folded into coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix

s/MADV_NODUMP/MADV_DONTDUMP/, s/MADV_CLEAR_NODUMP/MADV_DODUMP/, per Roland

Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/mman-common.h |    4 ++--
 mm/madvise.c                      |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/mman-common.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix
+++ a/include/asm-generic/mman-common.h
@@ -48,9 +48,9 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
-#define MADV_NODUMP 16			/* Explicity exclude from the core dump,
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
 					   overrides the coredump filter bits */
-#define MADV_CLEAR_NODUMP 17		/* Clear the MADV_NODUMP flag */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
 /* compatibility flags */
 #define MAP_FILE	0
diff -puN mm/madvise.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix mm/madvise.c
--- a/mm/madvise.c~coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix
+++ a/mm/madvise.c
@@ -65,10 +65,10 @@ static long madvise_behavior(struct vm_a
 		}
 		new_flags &= ~VM_DONTCOPY;
 		break;
-	case MADV_NODUMP:
+	case MADV_DONTDUMP:
 		new_flags |= VM_NODUMP;
 		break;
-	case MADV_CLEAR_NODUMP:
+	case MADV_DODUMP:
 		new_flags &= ~VM_NODUMP;
 		break;
 	case MADV_MERGEABLE:
@@ -299,8 +299,8 @@ madvise_behavior_valid(int behavior)
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 #endif
-	case MADV_NODUMP:
-	case MADV_CLEAR_NODUMP:
+	case MADV_DONTDUMP:
+	case MADV_DODUMP:
 		return 1;
 
 	default:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
rtc-rtc-driver-for-da9052-53-pmic-v1.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

