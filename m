From: akpm@linux-foundation.org
Subject: + include-video-atmel_lcdch-must-include-linux-workqueueh.patch added to -mm tree
Date: Fri, 25 Jul 2008 14:46:44 -0700
Message-ID: <200807252146.m6PLkijR032763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbYGYVrV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 17:47:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     include/video/atmel_lcdc.h must #include <linux/workqueue.h>
has been added to the -mm tree.  Its filename is
     include-video-atmel_lcdch-must-include-linux-workqueueh.patch

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
Subject: include/video/atmel_lcdc.h must #include <linux/workqueue.h>
From: Adrian Bunk <bunk@kernel.org>

This patch fixes the following compile error caused by
commit d22579b837358cbef12ccca5adaf7e93ae09ab7a
(atmel_lcdfb: FIFO underflow management):

In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/avr32/boards/atstk1000/atstk1004.c:21:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/video/atmel_lcdc.h:40: error: field 'task' has incomplete type

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/atmel_lcdc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/video/atmel_lcdc.h~include-video-atmel_lcdch-must-include-linux-workqueueh include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~include-video-atmel_lcdch-must-include-linux-workqueueh
+++ a/include/video/atmel_lcdc.h
@@ -22,6 +22,7 @@
 #ifndef __ATMEL_LCDC_H__
 #define __ATMEL_LCDC_H__
 
+#include <linux/workqueue.h>
 
 /* Way LCD wires are connected to the chip:
  * Some Atmel chips use BGR color mode (instead of standard RGB)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

