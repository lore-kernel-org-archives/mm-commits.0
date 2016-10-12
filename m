From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:00 -0700
Message-ID: <57fe8d94.60WstnlWFiUsAeQx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33197 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755973AbcJLTYa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, elfring@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: see if modified files are marked obsolete in MAINTAINERS
has been removed from the -mm tree.  Its filename was
     checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: see if modified files are marked obsolete in MAINTAINERS

Use get_maintainer to check the status of individual files.  If
"obsolete", suggest leaving the files alone.

Link: http://lkml.kernel.org/r/7ceaa510dc9d2df05ec4b456baed7bb1415550b3.1471889575.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers
+++ a/scripts/checkpatch.pl
@@ -704,6 +704,16 @@ sub seed_camelcase_file {
 	}
 }
 
+sub is_maintained_obsolete {
+	my ($filename) = @_;
+
+	return 0 if (!(-e "$root/scripts/get_maintainer.pl"));
+
+	my $status = `perl $root/scripts/get_maintainer.pl --status --nom --nol --nogit --nogit-fallback $filename 2>&1`;
+
+	return $status =~ /obsolete/i;
+}
+
 my $camelcase_seeded = 0;
 sub seed_camelcase_includes {
 	return if ($camelcase_seeded);
@@ -2289,6 +2299,10 @@ sub process {
 		}
 
 		if ($found_file) {
+			if (is_maintained_obsolete($realfile)) {
+				WARN("OBSOLETE",
+				     "$realfile is marked as 'obsolete' in the MAINTAINERS hierarchy.  No unnecessary modifications please.\n");
+			}
 			if ($realfile =~ m@^(?:drivers/net/|net/|drivers/staging/)@) {
 				$check = 1;
 			} else {
_

Patches currently in -mm which might be from joe@perches.com are


