From: akpm@linux-foundation.org
Subject: + asm-generic-int-ll64h-always-provide-__su64.patch added to -mm tree
Date: Tue, 20 May 2008 02:07:43 -0700
Message-ID: <200805200907.m4K97hsr014700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764527AbYETJIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 05:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, harvey.harrison@gmail.com, hpa@zytor.com


The patch titled
     asm-generic/int-ll64.h: always provide __{s,u}64
has been added to the -mm tree.  Its filename is
     asm-generic-int-ll64h-always-provide-__su64.patch

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

linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
git-input.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
git-xtensa.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch
md-proper-extern-for-mdp_major.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-the-oss-trident-driver.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

