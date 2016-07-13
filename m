From: akpm@linux-foundation.org
Subject: + checkpatch-allow-c99-style-comments.patch added to -mm tree
Date: Wed, 13 Jul 2016 15:09:31 -0700
Message-ID: <5786bc1b.XrpltN9zW/m5jsjm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbcGMWJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 18:09:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: allow c99 style // comments
has been added to the -mm tree.  Its filename is
     checkpatch-allow-c99-style-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-allow-c99-style-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-allow-c99-style-comments.patch

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
Subject: checkpatch: allow c99 style // comments

Sanitise the lines that contain c99 comments so that the error doesn't get
emitted.

Link: http://lkml.kernel.org/r/d4d22c34ad7bcc1bceb52f0742f76b7a6d585235.1468368420.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-allow-c99-style-comments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-c99-style-comments
+++ a/scripts/checkpatch.pl
@@ -55,6 +55,7 @@ my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
 my $codespellfile = "/usr/share/codespell/dictionary.txt";
 my $color = 1;
+my $allow_c99_comments = 1;
 
 sub help {
 	my ($exitcode) = @_;
@@ -1145,6 +1146,11 @@ sub sanitise_line {
 		$res =~ s@(\#\s*(?:error|warning)\s+).*@$1$clean@;
 	}
 
+	if ($allow_c99_comments && $res =~ m@(//.*$)@) {
+		my $match = $1;
+		$res =~ s/\Q$match\E/"$;" x length($match)/e;
+	}
+
 	return $res;
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

printk-create-pr_level-functions.patch
checkpatch-skip-long-lines-that-use-an-efi_guid-macro.patch
checkpatch-allow-c99-style-comments.patch

