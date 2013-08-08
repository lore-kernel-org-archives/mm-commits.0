From: akpm@linux-foundation.org
Subject: + checkpatch-ignore-define-trace_foo-macros.patch added to -mm
 tree
Date: Thu, 08 Aug 2013 12:45:45 -0700
Message-ID: <5203f569.sMhwrWhhqdX2WnWH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965984Ab3HHTpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 15:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sarah.a.sharp@linux.intel.com, lizefan@huawei.com, apw@canonical.com, joe@perches.com

Subject: + checkpatch-ignore-define-trace_foo-macros.patch added to -mm tree
To: joe@perches.com,apw@canonical.com,lizefan@huawei.com,sarah.a.sharp@linux.intel.com
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 12:45:45 -0700


The patch titled
     From: Joe Perches <joe@perches.com>
has been added to the -mm tree.  Its filename is
     checkpatch-ignore-define-trace_foo-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-ignore-define-trace_foo-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-ignore-define-trace_foo-macros.patch

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
Subject: checkpatch: Ignore #define TRACE_<foo> macros

The tracing subsystem uses slightly odd #defines
to set path/directory locations for include files.

These #defines can cause false positives for the
complex macro tests so add exclusions for these
specific #defines (TRACE_SYSTEM, TRACE_INCLUDE_FILE,
TRACE_INCLUDE_PATH).

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-ignore-define-trace_foo-macros scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ignore-define-trace_foo-macros
+++ a/scripts/checkpatch.pl
@@ -3451,7 +3451,8 @@ sub process {
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
 			    $dstat !~ /^do\s*{/ &&					# do {...
-			    $dstat !~ /^\({/)						# ({...
+			    $dstat !~ /^\({/ &&						# ({...
+			    $ctx !~ /^.\s*#\s*define\s+TRACE_(?:SYSTEM|INCLUDE_FILE|INCLUDE_PATH)\b/)
 			{
 				$ctx =~ s/\n*$//;
 				my $herectx = $here . "\n";
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
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
maintainers-update-sirf-patterns.patch
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

