From: akpm@linux-foundation.org
Subject: + checkpatch-fix-export_symbol-handling-following-a-function.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:19:59 -0800
Message-ID: <201111302220.pAUMJx7S006410@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:52387 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1K3WUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:20:02 -0500
Received: by vbbez10 with SMTP id ez10so134788vbb.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:20:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: fix EXPORT_SYMBOL handling following a function
has been added to the -mm tree.  Its filename is
     checkpatch-fix-export_symbol-handling-following-a-function.patch

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
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: fix EXPORT_SYMBOL handling following a function

The following fragment defeats the DEVICE_ATTR style handing, check for
and ignore the close brace '}' in this context:

    int foo()
    {
    }
    DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
                ata_scsi_lpm_show, ata_scsi_lpm_put);
    EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-export_symbol-handling-following-a-function scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-export_symbol-handling-following-a-function
+++ a/scripts/checkpatch.pl
@@ -2131,7 +2131,7 @@ sub process {
 			#   XXX(foo);
 			#   EXPORT_SYMBOL(something_foo);
 			my $name = $1;
-			if ($stat =~ /^.([A-Z_]+)\s*\(\s*($Ident)/ &&
+			if ($stat =~ /^(?:.\s*}\s*\n)?.([A-Z_]+)\s*\(\s*($Ident)/ &&
 			    $name =~ /^${Ident}_$2/) {
 #print "FOO C name<$name>\n";
 				$suppress_export{$realline_next} = 1;
_
Subject: Subject: checkpatch: fix EXPORT_SYMBOL handling following a function

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch
checkpatch-check-for-common-memset-parameter-issues-against-statments.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-is-not-a-valid-modifier.patch
checkpatch-optimise-statement-scanner-when-mid-statement.patch
checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch
checkpatch-fix-export_symbol-handling-following-a-function.patch
checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch
checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch
checkpatch-fix-complex-macros-handling-of-square-brackets.patch
checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch
checkpatch-typeof-may-have-more-complex-arguments.patch

