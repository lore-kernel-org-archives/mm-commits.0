From: akpm@linux-foundation.org
Subject: +
 kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch added to
 -mm tree
Date: Thu, 29 Aug 2013 16:12:03 -0700
Message-ID: <521fd543.hk3XDsy0EInBVpr3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3H2XME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 19:12:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 16:12:03 -0700


The patch titled
     Subject: kernel/timer.c: convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)
has been added to the -mm tree.  Its filename is
     kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: kernel/timer.c: convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)

Use the helper function instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/timer.c~kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node kernel/timer.c
--- a/kernel/timer.c~kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node
+++ a/kernel/timer.c
@@ -1518,9 +1518,8 @@ static int init_timers_cpu(int cpu)
 			/*
 			 * The APs use this path later in boot
 			 */
-			base = kmalloc_node(sizeof(*base),
-						GFP_KERNEL | __GFP_ZERO,
-						cpu_to_node(cpu));
+			base = kzalloc_node(sizeof(*base), GFP_KERNEL,
+					    cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
 
_

Patches currently in -mm which might be from joe@perches.com are

kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
lib-genallocc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
mm-mempoolc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
maintainers-append-to-directory-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
checkpatch-add-types-option-to-report-only-specific-message-types.patch
checkpatch-ignore-define-trace_foo-macros.patch
checkpatch-better-fix-of-spacing-errors.patch
checkpatch-reduce-runtime-cpu-time-used.patch
checkpatch-fix-perl-version-512-and-earlier-incompatibility.patch
checkpatch-add-test-for-positional-misuse-of-section-specifiers-like-__initdata.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch
pktcdvd-fix-defective-misuses-of-pkt_level.patch
linux-next.patch

