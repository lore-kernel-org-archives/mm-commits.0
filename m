From: akpm@linux-foundation.org
Subject: + checkpatch-handle-export_symbol-for-device_attr-and-similar.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:38 -0700
Message-ID: <201008182025.o7IKPc1Q010365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab0HRUbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: handle EXPORT_SYMBOL for DEVICE_ATTR and similar
has been added to the -mm tree.  Its filename is
     checkpatch-handle-export_symbol-for-device_attr-and-similar.patch

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
Subject: checkpatch: handle EXPORT_SYMBOL for DEVICE_ATTR and similar
From: Andy Whitcroft <apw@canonical.com>

Handly definitions similar to below.  The definition macro spits out a
symbol with a prefix.  Add matching of any identifier prefix:

    DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
            ata_scsi_lpm_show, ata_scsi_lpm_put);
    EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-handle-export_symbol-for-device_attr-and-similar scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-export_symbol-for-device_attr-and-similar
+++ a/scripts/checkpatch.pl
@@ -1822,8 +1822,17 @@ sub process {
 		    !defined $suppress_export{$realline_next} &&
 		    ($lines[$realline_next - 1] =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
 		     $lines[$realline_next - 1] =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
+			# Handle definitions which produce identifiers with
+			# a prefix:
+			#   XXX(foo);
+			#   EXPORT_SYMBOL(something_foo);
 			my $name = $1;
-			if ($stat !~ /(?:
+			if ($stat =~ /^.([A-Z_]+)\s*\(\s*($Ident)/ &&
+			    $name =~ /^${Ident}_$2/) {
+#print "FOO C name<$name>\n";
+				$suppress_export{$realline_next} = 1;
+
+			} elsif ($stat !~ /(?:
 				\n.}\s*$|
 				^.DEFINE_$Ident\(\Q$name\E\)|
 				^.DECLARE_$Ident\(\Q$name\E\)|
_

Patches currently in -mm which might be from apw@canonical.com are

checkpatch-fix-regressions-in-fix-handling-of-leading-spaces.patch
checkpatch-types-may-sit-on-a-line-on-their-own.patch
checkpatch-suggest-cleanpatch-and-cleanfile-when-appropriate.patch
checkpatch-ensure-we-do-not-collapse-bracketed-sections-into-constants.patch
checkpatch-handle-casts-better-fixing-false-categorisation-of-as-binary.patch
checkpatch-returning-errno-typically-should-be-negative.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-simplify-and-consolidate-missing-space-after-checks.patch
checkpatch-ensure-kconfig-help-checks-only-apply-when-we-are-adding-help.patch
checkpatch-check-for-incorrect-permissions.patch
checkpatch-add-additional-attribute-defines.patch
checkpatch-update-copyright-dates.patch
checkpatch-clean-up-structure-definition-macro-handline.patch
checkpatch-handle-export_symbol-for-device_attr-and-similar.patch
checkpatch-statement-block-context-analyser-should-look-at-sanitised-lines.patch
checkpatch-version-031.patch

