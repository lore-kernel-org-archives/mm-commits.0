From: akpm@linux-foundation.org
Subject: + cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch added to -mm tree
Date: Thu, 17 Feb 2011 14:47:51 -0800
Message-ID: <201102172247.p1HMlpHG020477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271Ab1BQWsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 17:48:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com


The patch titled
     cpuset-fix-unchecked-calls-to-nodemask_alloc-fix
has been added to the -mm tree.  Its filename is
     cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch

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
Subject: cpuset-fix-unchecked-calls-to-nodemask_alloc-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment spelling, strengthen cgroup_lock comment

Cc: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc-fix
+++ a/kernel/cpuset.c
@@ -80,11 +80,11 @@ struct cgroup_subsys cpuset_subsys;
 struct cpuset;
 
 /*
- * In functions that can't propogate errno to users, to avoid declaring a
+ * In functions that can't propagate errno to users, to avoid declaring a
  * nodemask_t variable, and avoid using NODEMASK_ALLOC that can return
  * -ENOMEM, we use this global cpuset_mems.
  *
- * It should be used with cgroup_lock held.
+ * It must called under cgroup_lock().
  */
 static nodemask_t cpuset_mems;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig.patch
drivers-platform-x86-makefile-drivers-platform-x86-intel_mid_thermalc-doesnt-exist.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

