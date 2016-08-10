From: akpm@linux-foundation.org
Subject: +
 get_maintainer-dont-check-if-stdin-exists-in-a-vcs-repository.patch added
 to -mm tree
Date: Wed, 10 Aug 2016 15:17:15 -0700
Message-ID: <57aba7eb.DYKZtTSOzNWSWSuu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949AbcHJWRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cov@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: Don't check if STDIN exists in a VCS repository
has been added to the -mm tree.  Its filename is
     get_maintainer-dont-check-if-stdin-exists-in-a-vcs-repository.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-dont-check-if-stdin-exists-in-a-vcs-repository.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-dont-check-if-stdin-exists-in-a-vcs-repository.patch

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
Subject: get_maintainer: Don't check if STDIN exists in a VCS repository

If get_maintainer is not given any filename arguments on the command line,
the standard input is read for a patch.

But checking if a VCS has a file named &STDIN is not a good idea and fails.

Verify the nominal input file is not &STDIN before checking the VCS.

Fixes: 4cad35a7ca69 ("get_maintainer.pl: reduce need for command-line option -f")
Link: http://lkml.kernel.org/r/f8910b64c4987753a642b0200f5509ea7d8bd818.1470843485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Christopher Covington <cov@codeaurora.org>
Tested-by: Christopher Covington <cov@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-dont-check-if-stdin-exists-in-a-vcs-repository scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-dont-check-if-stdin-exists-in-a-vcs-repository
+++ a/scripts/get_maintainer.pl
@@ -432,7 +432,7 @@ foreach my $file (@ARGV) {
 	    die "$P: file '${file}' not found\n";
 	}
     }
-    if ($from_filename || vcs_file_exists($file)) {
+    if ($from_filename || ($file ne "&STDIN" && vcs_file_exists($file))) {
 	$file =~ s/^\Q${cur_path}\E//;	#strip any absolute path
 	$file =~ s/^\Q${lk_path}\E//;	#or the path to the lk tree
 	push(@files, $file);
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-dont-check-if-stdin-exists-in-a-vcs-repository.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch

