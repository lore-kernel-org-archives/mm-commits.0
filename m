From: akpm@linux-foundation.org
Subject: + get_maintainer-use-filename-only-regex-match-for-tegra.patch added to -mm tree
Date: Mon, 11 Mar 2013 13:57:31 -0700
Message-ID: <20130311205731.7947F5A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:50844 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3CKU5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:57:32 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so428965vea.0
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:57:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swarren@nvidia.com, joe@perches.com, marcin.slusarz@gmail.com


The patch titled
     Subject: get_maintainer: use filename-only regex match for Tegra
has been added to the -mm tree.  Its filename is
     get_maintainer-use-filename-only-regex-match-for-tegra.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: get_maintainer: use filename-only regex match for Tegra

Create a new N: entry type in MAINTAINERS which performs a regex match
against filenames; either those extracted from patch +++ or --- lines, or
those specified on the command-line using the -f option.

This provides the same benefits as using a K: regex option to match a set
of filenames (see commit eb90d08 "get_maintainer: allow keywords to match
filenames"), but without the disadvantage that "random" file content, such
as comments, will ever match the regex.  Hence, revert most of that
commit.

Switch the Tegra entry from using K: to N:

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS               |   14 ++++++++------
 scripts/get_maintainer.pl |    2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN MAINTAINERS~get_maintainer-use-filename-only-regex-match-for-tegra MAINTAINERS
--- a/MAINTAINERS~get_maintainer-use-filename-only-regex-match-for-tegra
+++ a/MAINTAINERS
@@ -90,6 +90,9 @@ Descriptions of section entries:
 	   F:	drivers/net/*	all files in drivers/net, but not below
 	   F:	*/net/*		all files in "any top level directory"/net
 	   One pattern per line.  Multiple F: lines acceptable.
+	N: Files and directories with regex patterns.
+	   N:	[^a-z]tegra	all files whose patch contains the word tegra
+	   One pattern per line.  Multiple N: lines acceptable.
 	X: Files and directories that are NOT maintained, same rules as F:
 	   Files exclusions are tested before file matches.
 	   Can be useful for excluding a specific subdirectory, for instance:
@@ -97,13 +100,12 @@ Descriptions of section entries:
 	   X:	net/ipv6/
 	   matches all files in and below net excluding net/ipv6/
 	K: Keyword perl extended regex pattern to match content in a
-	   patch or file, or an affected filename.  For instance:
+	   patch or file.  For instance:
 	   K: of_get_profile
-	      matches patch or file content, or filenames, that contain
-	      "of_get_profile"
+	      matches patches or files that contain "of_get_profile"
 	   K: \b(printk|pr_(info|err))\b
-	      matches patch or file content, or filenames, that contain one or
-	      more of the words printk, pr_info or pr_err
+	      matches patches or files that contain one or more of the words
+	      printk, pr_info or pr_err
 	   One regex pattern per line.  Multiple K: lines acceptable.
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
@@ -7850,7 +7852,7 @@ L:	linux-tegra@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
 S:	Supported
-K:	(?i)[^a-z]tegra
+N:	[^a-z]tegra
 
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
diff -puN scripts/get_maintainer.pl~get_maintainer-use-filename-only-regex-match-for-tegra scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-use-filename-only-regex-match-for-tegra
+++ a/scripts/get_maintainer.pl
@@ -611,7 +611,7 @@ sub get_maintainers {
 				    $hash{$tvi} = $value_pd;
 				}
 			    }
-			} elsif ($type eq 'K') {
+			} elsif ($type eq 'N') {
 			    if ($file =~ m/$value/x) {
 				$hash{$tvi} = 0;
 			    }
_

Patches currently in -mm which might be from swarren@nvidia.com are

linux-next.patch
get_maintainer-use-filename-only-regex-match-for-tegra.patch
rtc-tegra-protect-suspend-resume-callbacks-with-config_pm_sleep.patch
rtc-tegra-use-struct-dev_pm_ops-for-power-management.patch
rtc-tegra-set-irq-name-as-device-name.patch
rtc-tegra-use-managed-rtc_device_register.patch

