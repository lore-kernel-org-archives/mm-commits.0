From: akpm@linux-foundation.org
Subject: + drivers-media-dvb-frontends-s5h1420c-printk-fix.patch added to -mm tree
Date: Mon, 28 Apr 2008 01:54:56 -0700
Message-ID: <200804280854.m3S8suBQ017209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbYD1IzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 04:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mchehab@infradead.org


The patch titled
     drivers/media/dvb/frontends/s5h1420.c: printk fix
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-frontends-s5h1420c-printk-fix.patch

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
Subject: drivers/media/dvb/frontends/s5h1420.c: printk fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/dvb/frontends/s5h1420.c: In function `s5h1420_setsymbolrate':
drivers/media/dvb/frontends/s5h1420.c:484: warning: long long unsigned int format, u64 arg (arg 2)

We do not know what type the architecture uses for u64.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/s5h1420.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/frontends/s5h1420.c~drivers-media-dvb-frontends-s5h1420c-printk-fix drivers/media/dvb/frontends/s5h1420.c
--- a/drivers/media/dvb/frontends/s5h1420.c~drivers-media-dvb-frontends-s5h1420c-printk-fix
+++ a/drivers/media/dvb/frontends/s5h1420.c
@@ -481,7 +481,7 @@ static void s5h1420_setsymbolrate(struct
 		val *= 2;
 	do_div(val, (state->fclk / 1000));
 
-	dprintk("symbol rate register: %06llx\n", val);
+	dprintk("symbol rate register: %06llx\n", (unsigned long long)val);
 
 	v = s5h1420_readreg(state, Loop01);
 	s5h1420_writereg(state, Loop01, v & 0x7f);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-x1205-new-style-conversion.patch
hotplug-memory-make-online_page-common.patch
remove-sparse-warning-for-mmzoneh.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo.patch
vmallocinfo-add-caller-information.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries.patch
mm-introduce-pte_special-pte-bit.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info.patch
capabilities-implement-per-process-securebits.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
uart_get_baud_rate-stop-mangling-termios.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
vt-notifier-extension-for-accessibility.patch
kprobes-prevent-probing-of-preempt_schedule.patch
quota-various-style-cleanups.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
gpiochip_reserve.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
lxfb-add-power-management-functionality.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
drivers-md-use-time_before-time_before_eq-etc.patch
pnp-use-dev_printk-for-quirk-messages.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone.patch
fat_valid_media-remove-pointless-test.patch
drivers-media-dvb-frontends-s5h1420c-printk-fix.patch

