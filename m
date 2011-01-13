From: akpm@linux-foundation.org
Subject: [merged] scripts-get_maintainerpl-make-rolestats-the-default.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:05:27 -0800
Message-ID: <201101132008.p0DK88Lf029843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933642Ab1AMUIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:08:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     scripts/get_maintainer.pl: make --rolestats the default
has been removed from the -mm tree.  Its filename was
     scripts-get_maintainerpl-make-rolestats-the-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/get_maintainer.pl: make --rolestats the default
From: Joe Perches <joe@perches.com>

This script now requires a user to add --norolestats to the command line
so it's harder to feed the output of this script to programs that send
mass emails.

Update --help to correct command line defaults.

Change version to 0.26.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-make-rolestats-the-default scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-make-rolestats-the-default
+++ a/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.26-beta6';
+my $V = '0.26';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -40,7 +40,7 @@ my $email_use_mailmap = 1;
 my $output_multiline = 1;
 my $output_separator = ", ";
 my $output_roles = 0;
-my $output_rolestats = 0;
+my $output_rolestats = 1;
 my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
@@ -720,7 +720,8 @@ Other options:
   --help => show this help information
 
 Default options:
-  [--email --git --m --n --l --multiline --pattern-depth=0 --remove-duplicates]
+  [--email --nogit --git-fallback --m --n --l --multiline -pattern-depth=0
+   --remove-duplicates --rolestats]
 
 Notes:
   Using "-f directory" may give unexpected results:
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch

