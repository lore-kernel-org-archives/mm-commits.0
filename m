From: akpm@linux-foundation.org
Subject: + pm-fix-try_to_freeze_taskss-use-of-do_div.patch added to -mm tree
Date: Sat, 12 Jul 2008 22:31:31 -0700
Message-ID: <200807130531.m6D5VVMC006068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbYGMFcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 01:32:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     pm: fix try_to_freeze_tasks()'s use of do_div()
has been added to the -mm tree.  Its filename is
     pm-fix-try_to_freeze_taskss-use-of-do_div.patch

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
Subject: pm: fix try_to_freeze_tasks()'s use of do_div()
From: David Howells <dhowells@redhat.com>

Fix try_to_freeze_tasks()'s use of do_div() on an s64 by making
elapsed_csecs64 a u64 instead and dividing that.

Possibly this should be guarded lest the interval calculation turn up
negative, but the possible negativity of the result of the division is
cast away anyway.

This was introduced by patch 438e2ce68dfd4af4cfcec2f873564fb921db4bb5.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/process.c~pm-fix-try_to_freeze_taskss-use-of-do_div kernel/power/process.c
--- a/kernel/power/process.c~pm-fix-try_to_freeze_taskss-use-of-do_div
+++ a/kernel/power/process.c
@@ -149,7 +149,7 @@ static int try_to_freeze_tasks(bool sig_
 	unsigned long end_time;
 	unsigned int todo;
 	struct timeval start, end;
-	s64 elapsed_csecs64;
+	u64 elapsed_csecs64;
 	unsigned int elapsed_csecs;
 
 	do_gettimeofday(&start);
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
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
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
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

