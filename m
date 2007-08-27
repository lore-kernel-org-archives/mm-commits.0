From: akpm@linux-foundation.org
Subject: + export_reportpl-fix-perl-coding-errors.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:28:26 -0700
Message-ID: <200708272128.l7RLSQLX029045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45708 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932417AbXH0V3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linuxram@us.ibm.com, bunk@kernel.org, jengelh@computergmbh.de, sam@ravnborg.org


The patch titled
     export_report.pl: fix perl coding errors
has been added to the -mm tree.  Its filename is
     export_reportpl-fix-perl-coding-errors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: export_report.pl: fix perl coding errors
From: Ram Pai <linuxram@us.ibm.com>

Fixes some subtle perl coding bug observed by Jan Engelhardt
<jengelh@computergmbh.de>

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/export_report.pl |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/export_report.pl~export_reportpl-fix-perl-coding-errors scripts/export_report.pl
--- a/scripts/export_report.pl~export_reportpl-fix-perl-coding-errors
+++ a/scripts/export_report.pl
@@ -103,15 +103,15 @@ foreach my $thismod (@allcfiles) {
 	my $state=0;
 	while ( <MODULE_MODULE> ) {
 		chomp;
-		if ($state eq 0) {
+		if ($state == 0) {
 			$state = 1 if ($_ =~ /static const struct modversion_info/);
 			next;
 		}
-		if ($state eq 1) {
+		if ($state == 1) {
 			$state = 2 if ($_ =~ /__attribute__\(\(section\("__versions"\)\)\)/);
 			next;
 		}
-		if ($state eq 2) {
+		if ($state == 2) {
 			if ( $_ !~ /0x[0-9a-f]+,/ ) {
 				next;
 			}
@@ -121,7 +121,7 @@ foreach my $thismod (@allcfiles) {
 			push(@{$MODULE{$thismod}} , $sym);
 		}
 	}
-	if ($state ne 2) {
+	if ($state != 2) {
 		print "WARNING:$thismod is not built with CONFIG_MODVERSION enabled\n";
 	}
 	close(MODULE_MODULE);
_

Patches currently in -mm which might be from linuxram@us.ibm.com are

export_reportpl-fix-perl-coding-errors.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
