From: akpm@linux-foundation.org
Subject: - kernel-doc-init-kernel-version.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:36 -0700
Message-ID: <200710292031.l9TKVaZa021863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbXJ2Ug5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, randy.dunlap@oracle.com, rpjday@mindspring.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: init kernel version
has been removed from the -mm tree.  Its filename was
     kernel-doc-init-kernel-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: init kernel version
From: Johannes Berg <johannes@sipsolutions.net>

The kernel-doc script triggers a perl warning when invoked without
KERNELVERSION in the environment, rather make it use the string "unknown
kernel version" instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-init-kernel-version scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-init-kernel-version
+++ a/scripts/kernel-doc
@@ -334,7 +334,7 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 
 # get kernel version from env
 sub get_kernel_version() {
-    my $version;
+    my $version = 'unknown kernel version';
 
     if (defined($ENV{'KERNELVERSION'})) {
 	$version = $ENV{'KERNELVERSION'};
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-input.patch
fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kbuild.patch
git-wireless.patch
