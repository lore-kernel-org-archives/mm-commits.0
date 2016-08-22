From: akpm@linux-foundation.org
Subject: +
 checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
 added to -mm tree
Date: Mon, 22 Aug 2016 15:27:52 -0700
Message-ID: <57bb7c68.0PoPscLhazO37+hM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54972 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756227AbcHVW22 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2016 18:28:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: see if modified files are marked obsolete in MAINTAINERS
has been added to the -mm tree.  Its filename is
     checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: see if modified files are marked obsolete in MAINTAINERS

Use get_maintainer to check the status of individual files.  If
"obsolete", suggest leaving the files alone.

Link: http://lkml.kernel.org/r/7ceaa510dc9d2df05ec4b456baed7bb1415550b3.1471889575.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
 SF Markus Elfring <elfring@users.sourceforge.net>
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

get_maintainer-quiet-noisy-implicit-f-vcs_file_exists-checking.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch

