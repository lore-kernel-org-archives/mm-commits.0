From: akpm@linux-foundation.org
Subject: + alpha-dont-implement-per_cpu_attributes.patch added to -mm tree
Date: Fri, 26 Jun 2009 12:00:25 -0700
Message-ID: <200906261900.n5QJ0PMt021658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbZFZTBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 15:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ink@jurassic.park.msu.ru, max@stro.at, rth@twiddle.net, stable@kernel.org, tj@kernel.org


The patch titled
     alpha: don't implement PER_CPU_ATTRIBUTES
has been added to the -mm tree.  Its filename is
     alpha-dont-implement-per_cpu_attributes.patch

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
Subject: alpha: don't implement PER_CPU_ATTRIBUTES
From: Andrew Morton <akpm@linux-foundation.org>

The build fails due to -Werror:

cc1: warnings being treated as errors
In file included from include/linux/sched.h:89,
                 from /usr/src/devel/arch/alpha/include/asm/uaccess.h:5,
                 from arch/alpha/kernel/srm_env.c:37:
include/linux/hrtimer.h:314: warning: '__used__' attribute ignored
In file included from /usr/src/devel/arch/alpha/include/asm/uaccess.h:5,
                 from arch/alpha/kernel/srm_env.c:37:
include/linux/sched.h:138: warning: '__used__' attribute ignored

Fixed by removing the __used from PER_CPU_ATTRIBUTES

Ivan said:

  It was intended for suppressing the compiler warnings about "unused"
  static per-cpu variables, as they were only referenced inside the asm
  code.

  Now it seems to be broken with DECLARE_PER_CPU thing, so I think your
  patch that kills __used attribute should go in as a compile fix ASAP -
  we can live with a few compile warnings until the rest of percpu
  patchset gets merged.

Cc: maximilian attems <max@stro.at>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/percpu.h~alpha-dont-implement-per_cpu_attributes arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h~alpha-dont-implement-per_cpu_attributes
+++ a/arch/alpha/include/asm/percpu.h
@@ -49,7 +49,7 @@ extern unsigned long __per_cpu_offset[NR
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
 
-#define PER_CPU_ATTRIBUTES	__used
+#define PER_CPU_ATTRIBUTES
 
 #endif /* MODULE */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
alpha-dont-implement-per_cpu_attributes.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

