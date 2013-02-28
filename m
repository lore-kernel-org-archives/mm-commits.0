From: akpm@linux-foundation.org
Subject: [merged] get_maintainer-allow-keywords-to-match-filenames.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:53 -0800
Message-ID: <20130228201053.B8DB65A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:50283 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1UKy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:54 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so260937qah.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swarren@nvidia.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: allow keywords to match filenames
has been removed from the -mm tree.  Its filename was
     get_maintainer-allow-keywords-to-match-filenames.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: get_maintainer: allow keywords to match filenames

Allow K: entries in MAINTAINERS to match directly against filenames;
either those extracted from patch +++ or --- lines, or those specified on
the command-line using the -f option.

This potentially allows fewer lines in a MAINTAINERS entry, if all the
relevant files are scattered throughout the whole kernel tree, yet contain
some common keyword.  An example would be using an ARM SoC name as the
keyword to catch all related drivers.

I don't think setting exact_pattern_match_hash would be appropriate here;
at least for intended Tegra use case, this feature is to ensure that all
Tegra-related driver changes get Cc'd to the Tegra mailing list.  Setting
exact_pattern_match_hash would prevent git history parsing for e.g.  S-o-b
tags, which still seems like it would be useful.  Hence, this flag isn't
set.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS               |    9 +++++----
 scripts/get_maintainer.pl |    4 ++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~get_maintainer-allow-keywords-to-match-filenames MAINTAINERS
--- a/MAINTAINERS~get_maintainer-allow-keywords-to-match-filenames
+++ a/MAINTAINERS
@@ -97,12 +97,13 @@ Descriptions of section entries:
 	   X:	net/ipv6/
 	   matches all files in and below net excluding net/ipv6/
 	K: Keyword perl extended regex pattern to match content in a
-	   patch or file.  For instance:
+	   patch or file, or an affected filename.  For instance:
 	   K: of_get_profile
-	      matches patches or files that contain "of_get_profile"
+	      matches patch or file content, or filenames, that contain
+	      "of_get_profile"
 	   K: \b(printk|pr_(info|err))\b
-	      matches patches or files that contain one or more of the words
-	      printk, pr_info or pr_err
+	      matches patch or file content, or filenames, that contain one or
+	      more of the words printk, pr_info or pr_err
 	   One regex pattern per line.  Multiple K: lines acceptable.
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
diff -puN scripts/get_maintainer.pl~get_maintainer-allow-keywords-to-match-filenames scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-allow-keywords-to-match-filenames
+++ a/scripts/get_maintainer.pl
@@ -611,6 +611,10 @@ sub get_maintainers {
 				    $hash{$tvi} = $value_pd;
 				}
 			    }
+			} elsif ($type eq 'K') {
+			    if ($file =~ m/$value/x) {
+				$hash{$tvi} = 0;
+			    }
 			}
 		    }
 		}
_

Patches currently in -mm which might be from swarren@nvidia.com are

origin.patch
linux-next.patch

