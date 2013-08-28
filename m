From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-test-for-positional-misuse-of-section-specifiers-like-__initdata.patch added to -mm tree
Date: Wed, 28 Aug 2013 15:01:51 -0700
Message-ID: <521e734f.nkn3UydXY5ZniZRy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab3H1WBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Aug 2013 18:01:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@roeck-us.net, khali@linux-fr.org, joe@perches.com

Subject: + checkpatch-add-test-for-positional-misuse-of-section-specifiers-like-__initdata.patch added to -mm tree
To: joe@perches.com,khali@linux-fr.org,linux@roeck-us.net
From: akpm@linux-foundation.org
Date: Wed, 28 Aug 2013 15:01:51 -0700


The patch titled
     Subject: checkpatch: add test for positional misuse of section specifiers like __initdata
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-positional-misuse-of-section-specifiers-like-__initdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-positional-misuse-of-section-specifiers-like-__initdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-positional-misuse-of-section-specifiers-like-__initdata.patch

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
Subject: checkpatch: add test for positional misuse of section specifiers like __initdata

As discussed recently on the arm [1] and lm-sensors [2] lists, it is
possible to use section markers on variables in a way which gcc doesn't
understand (or at least not the way the developer intended):

static struct __initdata samsung_pll_clock exynos4_plls[nr_plls] = {

does NOT put exynos4_plls in the .initdata section.  The __initdata marker
can be virtually anywhere on the line, EXCEPT right after "struct".  The
preferred location is before the "=" sign if there is one, or before the
trailing ";" otherwise.

[1] http://permalink.gmane.org/gmane.linux.ports.arm.kernel/258149
[2] http://lists.lm-sensors.org/pipermail/lm-sensors/2013-August/039836.html

So, update checkpatch to find these misuses and report an error when it's
immediately after struct or union, and a warning when it's otherwise not
immediately before the ; or =.

A similar patch was suggested by Andi Kleen
https://lkml.org/lkml/2013/8/5/648

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   47 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-positional-misuse-of-section-specifiers-like-__initdata scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-positional-misuse-of-section-specifiers-like-__initdata
+++ a/scripts/checkpatch.pl
@@ -242,6 +242,8 @@ our $Sparse	= qr{
 			__rcu
 		}x;
 
+our $InitAttribute = qr{__(?:mem|cpu|dev|net_|)(?:initdata|initconst|init\b)};
+
 # Notes to $Attribute:
 # We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
 our $Attribute	= qr{
@@ -262,7 +264,7 @@ our $Attribute	= qr{
 			__deprecated|
 			__read_mostly|
 			__kprobes|
-			__(?:mem|cpu|dev|)(?:initdata|initconst|init\b)|
+			$InitAttribute|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
@@ -292,6 +294,7 @@ our $Operators	= qr{
 		  }x;
 
 our $NonptrType;
+our $NonptrTypeWithAttr;
 our $Type;
 our $Declare;
 
@@ -354,6 +357,12 @@ our @typeList = (
 	qr{${Ident}_handler},
 	qr{${Ident}_handler_fn},
 );
+our @typeListWithAttr = (
+	@typeList,
+	qr{struct\s+$InitAttribute\s+$Ident},
+	qr{union\s+$InitAttribute\s+$Ident},
+);
+
 our @modifierList = (
 	qr{fastcall},
 );
@@ -367,6 +376,7 @@ our $allowed_asm_includes = qr{(?x:
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
+	my $allWithAttr = "(?x:  \n" . join("|\n  ", @typeListWithAttr) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$NonptrType	= qr{
 			(?:$Modifier\s+|const\s+)*
@@ -377,6 +387,15 @@ sub build_types {
 			)
 			(?:\s+$Modifier|\s+const)*
 		  }x;
+	$NonptrTypeWithAttr	= qr{
+			(?:$Modifier\s+|const\s+)*
+			(?:
+				(?:typeof|__typeof__)\s*\([^\)]*\)|
+				(?:$typeTypedefs\b)|
+				(?:${allWithAttr}\b)
+			)
+			(?:\s+$Modifier|\s+const)*
+		  }x;
 	$Type	= qr{
 			$NonptrType
 			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
@@ -3706,6 +3725,32 @@ sub process {
 			}
 		}
 
+sub string_find_replace {
+	my ($string, $find, $replace) = @_;
+
+	$string =~ s/$find/$replace/g;
+
+	return $string;
+}
+
+# check for bad placement of section $InitAttribute (e.g.: __initdata)
+		if ($line =~ /(\b$InitAttribute\b)/) {
+			my $attr = $1;
+			if ($line =~ /^\+\s*static\s+(?:const\s+)?(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*[=;]/) {
+				my $ptr = $1;
+				my $var = $2;
+				if ((($ptr =~ /\b(union|struct)\s+$attr\b/ &&
+				      ERROR("MISPLACED_INIT",
+					    "$attr should be placed after $var\n" . $herecurr)) ||
+				     ($ptr !~ /\b(union|struct)\s+$attr\b/ &&
+				      WARN("MISPLACED_INIT",
+					   "$attr should be placed after $var\n" . $herecurr))) &&
+				    $fix) {
+					$fixed[$linenr - 1] =~ s/(\bstatic\s+(?:const\s+)?)(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*([=;])\s*/"$1" . trim(string_find_replace($2, "\\s*$attr\\s*", " ")) . " " . trim(string_find_replace($3, "\\s*$attr\\s*", "")) . " $attr" . ("$4" eq ";" ? ";" : " = ")/e;
+				}
+			}
+		}
+
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			# ignore udelay's < 10, however
_

Patches currently in -mm which might be from joe@perches.com are

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

