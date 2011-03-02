From: akpm@linux-foundation.org
Subject: + userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch added to -mm tree
Date: Wed, 02 Mar 2011 13:23:36 -0800
Message-ID: <201103022158.p22LwLqn003277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757341Ab1CBV7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2011 16:59:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, serge@hallyn.com


The patch titled
     userns-security-make-capabilities-relative-to-the-user-namespace-fix
has been added to the -mm tree.  Its filename is
     userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns-security-make-capabilities-relative-to-the-user-namespace-fix
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 linux-next allmodconfig:

security/selinux/hooks.c: In function 'selinux_file_ioctl':
security/selinux/hooks.c:2890: warning: passing argument 3 of 'task_has_capability' makes pointer from integer without a cast
security/selinux/hooks.c:1420: note: expected 'struct user_namespace *' but argument is of type 'int'
security/selinux/hooks.c:2890: error: too few arguments to function 'task_has_capability'

This patch is surely wrong?

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN security/selinux/hooks.c~userns-security-make-capabilities-relative-to-the-user-namespace-fix security/selinux/hooks.c
--- a/security/selinux/hooks.c~userns-security-make-capabilities-relative-to-the-user-namespace-fix
+++ a/security/selinux/hooks.c
@@ -2886,8 +2886,8 @@ static int selinux_file_ioctl(struct fil
 
 	case KDSKBENT:
 	case KDSKBSENT:
-		error = task_has_capability(current, cred, CAP_SYS_TTY_CONFIG,
-					    SECURITY_CAP_AUDIT);
+		error = task_has_capability(current, cred, &init_user_ns,
+					CAP_SYS_TTY_CONFIG, SECURITY_CAP_AUDIT);
 		break;
 
 	/* default case assumes that the command will go
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

cpuset-add-a-missing-unlock-in-cpuset_write_resmask-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-usb-serial-usb_wwanc-unbork.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
lib-vsprintf-optimised-put_dec-function-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

