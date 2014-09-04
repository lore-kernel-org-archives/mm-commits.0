From: akpm@linux-foundation.org
Subject: + checkpatch-allow-optional-shorter-config-descriptions.patch
 added to -mm tree
Date: Thu, 04 Sep 2014 14:06:56 -0700
Message-ID: <5408d470.1eKu2/OokK4Zt4/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaIDVG5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2014 17:06:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbendeb@chromium.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow optional shorter config descriptions
has been added to the -mm tree.  Its filename is
     checkpatch-allow-optional-shorter-config-descriptions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-optional-shorter-config-descriptions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-optional-shorter-config-descriptions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vadim Bendebury <vbendeb@chromium.org>
Subject: checkpatch: allow optional shorter config descriptions

This script is used by many other projects, and in some of them the
requirement of at least 4 line long description for all Kconfig items is
excessive.  This patch adds a command line option to control the required
minimum length.

Tested running this script over a patch including a two line config
description.  The script generated a warning when invoked as is, and did
not generate it when invoked with --min-conf-desc-length=2.

Signed-off-by: Vadim Bendebury <vbendeb@chromium.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-optional-shorter-config-descriptions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-optional-shorter-config-descriptions
+++ a/scripts/checkpatch.pl
@@ -43,6 +43,7 @@ my $configuration_file = ".checkpatch.co
 my $max_line_length = 80;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
+my $min_conf_desc_length = 4;
 
 sub help {
 	my ($exitcode) = @_;
@@ -63,6 +64,7 @@ Options:
   --types TYPE(,TYPE2...)    show only these comma separated message types
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
   --max-line-length=n        set the maximum line length, if exceeded, warn
+  --min-conf-desc-length=n   set the min description length, if shorter, warn
   --show-types               show the message "types" in the output
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
@@ -131,6 +133,7 @@ GetOptions(
 	'types=s'	=> \@use,
 	'show-types!'	=> \$show_types,
 	'max-line-length=i' => \$max_line_length,
+	'min-conf-desc-length=i' => \$min_conf_desc_length,
 	'root=s'	=> \$root,
 	'summary!'	=> \$summary,
 	'mailback!'	=> \$mailback,
@@ -2285,8 +2288,10 @@ sub process {
 				}
 				$length++;
 			}
-			WARN("CONFIG_DESCRIPTION",
-			     "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);
+			if ($is_start && $is_end && $length < $min_conf_desc_length) {
+				WARN("CONFIG_DESCRIPTION",
+				     "please write a paragraph that describes the config symbol fully\n" . $herecurr)
+			}
 			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
_

Patches currently in -mm which might be from vbendeb@chromium.org are

checkpatch-allow-optional-shorter-config-descriptions.patch

