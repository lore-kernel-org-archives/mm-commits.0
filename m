From: akpm@linux-foundation.org
Subject: [patch 048/114] checkpatch: ignore some octal permissions
 of 0
Date: Tue, 06 Feb 2018 15:38:49 -0800
Message-ID: <20180206233849.N-agFRA-w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754126AbeBFXiu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:38:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, brgl@bgdev.pl, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: ignore some octal permissions of 0

module_param and create_proc uses with a permissions use of a single 0 are
"special" and should not emit any warning.

module_param uses with permission 0 are not visible in sysfs

create_proc uses with permission 0 use a default permission

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
@@ -6276,6 +6276,10 @@ sub process {
 
 # Mode permission misuses where it seems decimal should be octal
 # This uses a shortcut match to avoid unnecessary uses of a slow foreach loop
+# o Ignore module_param*(...) uses with a decimal 0 permission as that has a
+#   specific definition of not visible in sysfs.
+# o Ignore proc_create*(...) uses with a decimal 0 permission as that means
+#   use the default permissions
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
 		    $line =~ /$mode_perms_search/) {
@@ -6299,8 +6303,9 @@ sub process {
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
