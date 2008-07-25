From: akpm@linux-foundation.org
Subject: - asm-generic-int-ll64h-always-provide-__su64.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:36 -0700
Message-ID: <200807252254.m6PMsaRq002837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYGYWzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, harvey.harrison@gmail.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     asm-generic/int-ll64.h: always provide __{s,u}64
has been removed from the -mm tree.  Its filename was
     asm-generic-int-ll64h-always-provide-__su64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/int-ll64.h: always provide __{s,u}64
From: Adrian Bunk <bunk@kernel.org>

Several compilers offer "long long" without claiming to support C99.

Considering how frequent __s64/__u64 are used our userspace headers are
anyway unusable without __s64/__u64 available.

Always offer __s64/__u64 to non-gcc non-C99 compilers - if they provide
"long long" that makes the headers compiling and if they don't they are
anyway screwed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/int-ll64.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/int-ll64.h~asm-generic-int-ll64h-always-provide-__su64 include/asm-generic/int-ll64.h
--- a/include/asm-generic/int-ll64.h~asm-generic-int-ll64h-always-provide-__su64
+++ a/include/asm-generic/int-ll64.h
@@ -26,7 +26,7 @@ typedef unsigned int __u32;
 #ifdef __GNUC__
 __extension__ typedef __signed__ long long __s64;
 __extension__ typedef unsigned long long __u64;
-#elif defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
+#else
 typedef __signed__ long long __s64;
 typedef unsigned long long __u64;
 #endif
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
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

