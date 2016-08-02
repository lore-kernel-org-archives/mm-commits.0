From: akpm@linux-foundation.org
Subject: [patch 051/111] checkpatch: allow c99 style // comments
Date: Tue, 02 Aug 2016 14:04:33 -0700
Message-ID: <57a10ae1.6U3MsHpHQa8SzbvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbcHBVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

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
@@ -1144,6 +1145,11 @@ sub sanitise_line {
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
