From: akpm@linux-foundation.org
Subject: [patch 015/102] checkpatch: see if modified files are marked
 obsolete in MAINTAINERS
Date: Tue, 11 Oct 2016 13:51:44 -0700
Message-ID: <57fd50e0.lkj/kxhLJEE8MPE6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37916 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752266AbcJKUxE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, elfring@users.sourceforge.net

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
