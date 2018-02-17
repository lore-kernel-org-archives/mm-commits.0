From: akpm@linux-foundation.org
Subject: + checkpatchpl-add-spdx-license-tag-check.patch added to -mm tree
Date: Fri, 16 Feb 2018 16:33:40 -0800
Message-ID: <5a877864.BpK0VgI23JrKxlop%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48290 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbeBQAdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robh@kernel.org, apw@canonical.com, corbet@lwn.net, gregkh@linuxfoundation.org, igor.stoppa@huawei.com, joe@perches.com, pombredanne@nexb.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch.pl: add SPDX license tag check
has been added to the -mm tree.  Its filename is
     checkpatchpl-add-spdx-license-tag-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatchpl-add-spdx-license-tag-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatchpl-add-spdx-license-tag-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Herring <robh@kernel.org>
Subject: checkpatch.pl: add SPDX license tag check

Add SPDX license tag check based on the rules defined in
Documentation/process/license-rules.rst.  To summarize, SPDX license tags
should be on the 1st line (or 2nd line in scripts) using the appropriate
comment style for the file type.

Link: http://lkml.kernel.org/r/20180202154026.15298-1-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatchpl-add-spdx-license-tag-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-add-spdx-license-tag-check
+++ a/scripts/checkpatch.pl
@@ -2257,6 +2257,8 @@ sub process {
 
 	my $camelcase_file_seeded = 0;
 
+	my $checklicenseline = 1;
+
 	sanitise_line_reset();
 	my $line;
 	foreach my $rawline (@rawlines) {
@@ -2448,6 +2450,7 @@ sub process {
 			} else {
 				$check = $check_orig;
 			}
+			$checklicenseline = 1;
 			next;
 		}
 
@@ -2897,6 +2900,30 @@ sub process {
 				}
 			}
 		}
+
+# check for using SPDX license tag at beginning of files
+		if ($realline == $checklicenseline) {
+			if ($rawline =~ /^[ \+]\s*\#\!\s*\//) {
+				$checklicenseline = 2;
+			} elsif ($rawline =~ /^\+/) {
+				my $comment = "";
+				if ($realfile =~ /\.(h|s|S)$/) {
+					$comment = '/*';
+				} elsif ($realfile =~ /\.(c|dts|dtsi)$/) {
+					$comment = '//';
+				} elsif (($checklicenseline == 2) || $realfile =~ /\.(sh|pl|py|awk|tc)$/) {
+					$comment = '#';
+				} elsif ($realfile =~ /\.rst$/) {
+					$comment = '..';
+				}
+
+				if ($comment !~ /^$/ &&
+				    $rawline !~ /^\+\Q$comment\E SPDX-License-Identifier: /) {
+					WARN("SPDX_LICENSE_TAG",
+					     "Missing or malformed SPDX-License-Identifier tag in line $checklicenseline\n" . $herecurr);
+				}
+			}
+		}
 
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|sh|dtsi|dts)$/);
_

Patches currently in -mm which might be from robh@kernel.org are

checkpatchpl-add-spdx-license-tag-check.patch

