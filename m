From: akpm@linux-foundation.org
Subject: +
 get_maintainer-look-for-arbitrary-letter-prefixes-in-sections.patch added
 to -mm tree
Date: Tue, 25 Oct 2016 12:45:33 -0700
Message-ID: <580fb65d.JFtYflwyE1dOBXVT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36511 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751404AbcJYTpe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 15:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, airlied@gmail.com, daniel@ffwll.ch, jani.nikula@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: look for arbitrary letter prefixes in sections
has been added to the -mm tree.  Its filename is
     get_maintainer-look-for-arbitrary-letter-prefixes-in-sections.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-look-for-arbitrary-letter-prefixes-in-sections.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-look-for-arbitrary-letter-prefixes-in-sections.patch

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
Subject: get_maintainer: look for arbitrary letter prefixes in sections

Jani Nikula proposes patches to add a few new letter prefixes for "B:" bug
reporting and "C:" maintainer chatting to the various sections of
MAINTAINERS.

Add a generic mechanism to get_maintainer.pl to find sections that have
any combination of "[A-Z]" letter prefix types in a section.

Link: http://lkml.kernel.org/r/1477332323.1984.8.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-look-for-arbitrary-letter-prefixes-in-sections scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-look-for-arbitrary-letter-prefixes-in-sections
+++ a/scripts/get_maintainer.pl
@@ -49,6 +49,7 @@ my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
 my $status = 0;
+my $letters = "";
 my $keywords = 1;
 my $sections = 0;
 my $file_emails = 0;
@@ -241,6 +242,7 @@ if (!GetOptions(
 		'status!' => \$status,
 		'scm!' => \$scm,
 		'web!' => \$web,
+		'letters=s' => \$letters,
 		'pattern-depth=i' => \$pattern_depth,
 		'k|keywords!' => \$keywords,
 		'sections!' => \$sections,
@@ -271,7 +273,8 @@ $output_multiline = 0 if ($output_separa
 $output_rolestats = 1 if ($interactive);
 $output_roles = 1 if ($output_rolestats);
 
-if ($sections) {
+if ($sections || $letters ne "") {
+    $sections = 1;
     $email = 0;
     $email_list = 0;
     $scm = 0;
@@ -682,8 +685,10 @@ sub get_maintainers {
 			$line =~ s/\\\./\./g;       	##Convert \. to .
 			$line =~ s/\.\*/\*/g;       	##Convert .* to *
 		    }
-		    $line =~ s/^([A-Z]):/$1:\t/g;
-		    print("$line\n");
+		    my $count = $line =~ s/^([A-Z]):/$1:\t/g;
+		    if ($letters eq "" || (!$count || $letters =~ /$1/i)) {
+			print("$line\n");
+		    }
 		}
 		print("\n");
 	    }
@@ -814,6 +819,7 @@ Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --keywords => scan patch for keywords (default: $keywords)
   --sections => print all of the subsystem sections with pattern matches
+  --letters => print all matching 'letter' types from all matching sections
   --mailmap => use .mailmap file (default: $email_use_mailmap)
   --version => show version
   --help => show this help information
_

Patches currently in -mm which might be from joe@perches.com are

mm-page_alloc-use-kern_cont-where-appropriate.patch
get_maintainer-look-for-arbitrary-letter-prefixes-in-sections.patch
checkpatch-dont-check-pl-files-improve-absolute-path-commit-log-test.patch

