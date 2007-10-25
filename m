From: akpm@linux-foundation.org
Subject: + kernel-doc-init-kernel-version.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:18:26 -0700
Message-ID: <200710250418.l9P4IQWW031376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994AbXJYETy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:19:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, randy.dunlap@oracle.com, rpjday@mindspring.com, sam@ravnborg.org


The patch titled
     kernel-doc: init kernel version
has been added to the -mm tree.  Its filename is
     kernel-doc-init-kernel-version.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-wireless.patch
kernel-doc-fix-xml-output-mode.patch
kernel-doc-init-kernel-version.patch
kernel-doc-single-doc-selection.patch
kernel-doc-process-functions-not-doc.patch
kernel-doc-use-no-doc-option.patch
kernel-doc-new-p-directive-for-doc-sections.patch
