From: akpm@linux-foundation.org
Subject: [folded-merged]
 clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch removed from -mm
 tree
Date: Wed, 03 Jul 2013 14:37:17 -0700
Message-ID: <51d4998d.8GligiWiyKiYXsTa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab3GCVhS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ursula.braun@de.ibm.com, schwidefsky@de.ibm.com, richard@nod.at, rafael.j.wysocki@intel.com, keescook@chromium.org, heiko.carstens@de.ibm.com, gregkh@linuxfoundation.org, blaschka@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: [folded-merged] clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,blaschka@linux.vnet.ibm.com,gregkh@linuxfoundation.org,heiko.carstens@de.ibm.com,keescook@chromium.org,rafael.j.wysocki@intel.com,richard@nod.at,schwidefsky@de.ibm.com,ursula.braun@de.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:37:17 -0700


The patch titled
     Subject: clean-up-scary-strncpydst-src-strlensrc-uses-fix
has been removed from the -mm tree.  Its filename was
     clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch

This patch was dropped because it was folded into clean-up-scary-strncpydst-src-strlensrc-uses.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: clean-up-scary-strncpydst-src-strlensrc-uses-fix

revert getdelays.c part due to missing bsd/string.h

Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>	[staging]
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>	[acpi]
Cc: Richard Weinberger <richard@nod.at>
Acked-by: Ursula Braun <ursula.braun@de.ibm.com>	[s390]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN Documentation/accounting/getdelays.c~clean-up-scary-strncpydst-src-strlensrc-uses-fix Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~clean-up-scary-strncpydst-src-strlensrc-uses-fix
+++ a/Documentation/accounting/getdelays.c
@@ -23,7 +23,6 @@
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <signal.h>
-#include <bsd/string.h>
 
 #include <linux/genetlink.h>
 #include <linux/taskstats.h>
@@ -300,7 +299,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			containerset = 1;
-			strlcpy(containerpath, optarg, sizeof(containerpath));
+			strncpy(containerpath, optarg, strlen(optarg) + 1);
 			break;
 		case 'w':
 			logfile = strdup(optarg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-support-mmap-on-proc-vmcore.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
rtc-add-nxp-pcf2127-support-i2c-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

