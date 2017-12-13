From: akpm@linux-foundation.org
Subject: + checkpatch-ignore-some-octal-permissions-of-0.patch added to
 -mm tree
Date: Wed, 13 Dec 2017 15:45:24 -0800
Message-ID: <5a31bb94.DPNk6w6OxaG41vjT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdLMXpZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 18:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, brgl@bgdev.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: ignore some octal permissions of 0
has been added to the -mm tree.  Its filename is
     checkpatch-ignore-some-octal-permissions-of-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-ignore-some-octal-permissions-of-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-ignore-some-octal-permissions-of-0.patch

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
Subject: checkpatch: ignore some octal permissions of 0

module_param and create_proc uses with a permissions use of a single 0 are
"special" and should not emit any warning.

module_param uses with permission 0 is not visible in sysfs create_proc
uses with permission 0 uses a default permission

Link: http://lkml.kernel.org/r/b6583611bb529ea6f6d43786827fddbabbab0a71.1513190059.git.joe@perches.com
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-ignore-some-octal-permissions-of-0 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-ignore-some-octal-permissions-of-0
+++ a/scripts/checkpatch.pl
@@ -6285,6 +6285,10 @@ sub process {
 
 # Mode permission misuses where it seems decimal should be octal
 # This uses a shortcut match to avoid unnecessary uses of a slow foreach loop
+# o Ignore module_param*(...) uses with a decimal 0 permission as that has a
+#   specific definition of not visible in sysfs.
+# o Ignore proc_create*(...) uses with a decimal 0 permission as that means
+#   use the default permissions
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
 		    $line =~ /$mode_perms_search/) {
@@ -6308,8 +6312,9 @@ sub process {
 				if ($stat =~ /$test/) {
 					my $val = $1;
 					$val = $6 if ($skip_args ne "");
-					if (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
-					    ($val =~ /^$Octal$/ && length($val) ne 4)) {
+					if (!($func =~ /^(?:module_param|proc_create)/ && $val eq "0") &&
+					    (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
+					     ($val =~ /^$Octal$/ && length($val) ne 4))) {
 						ERROR("NON_OCTAL_PERMISSIONS",
 						      "Use 4 digit octal (0777) not decimal permissions\n" . "$here\n" . $stat_real);
 					}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-ignore-some-octal-permissions-of-0.patch

