From: akpm@linux-foundation.org
Subject: + netfilter-fix-xt_times-time_mts-use-of-do_div.patch added to -mm tree
Date: Sat, 12 Jul 2008 22:50:13 -0700
Message-ID: <200807130550.m6D5oDn6006663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbYGMFup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 01:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jengelh@computergmbh.de, kaber@trash.net


The patch titled
     netfilter: fix xt_time's time_mt()'s use of do_div()
has been added to the -mm tree.  Its filename is
     netfilter-fix-xt_times-time_mts-use-of-do_div.patch

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
Subject: netfilter: fix xt_time's time_mt()'s use of do_div()
From: David Howells <dhowells@redhat.com>

Fix netfilter xt_time's time_mt()'s use of do_div() on an s64 by using
div_s64() instead.

This was introduced by patch ee4411a1b1e0b679c99686629b5eab5a072ce49f.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/xt_time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/netfilter/xt_time.c~netfilter-fix-xt_times-time_mts-use-of-do_div net/netfilter/xt_time.c
--- a/net/netfilter/xt_time.c~netfilter-fix-xt_times-time_mts-use-of-do_div
+++ a/net/netfilter/xt_time.c
@@ -173,7 +173,7 @@ time_mt(const struct sk_buff *skb, const
 		__net_timestamp((struct sk_buff *)skb);
 
 	stamp = ktime_to_ns(skb->tstamp);
-	do_div(stamp, NSEC_PER_SEC);
+	stamp = div_s64(stamp, NSEC_PER_SEC);
 
 	if (info->flags & XT_TIME_LOCAL_TZ)
 		/* Adjust for local timezone */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-fix-irqs_disabled-to-return-an-int-not-an-unsigned-long.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
netfilter-fix-xt_times-time_mts-use-of-do_div.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

