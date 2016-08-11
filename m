From: akpm@linux-foundation.org
Subject: +
 get_maintainer-quiet-noisy-implicit-f-vcs_file_exists-checking.patch added
 to -mm tree
Date: Thu, 11 Aug 2016 15:47:49 -0700
Message-ID: <57ad0095.Au0ReS00BldEBGTZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbcHKWru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 18:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, wsa@the-dreams.de, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: quiet noisy implicit -f vcs_file_exists checking
has been added to the -mm tree.  Its filename is
     get_maintainer-quiet-noisy-implicit-f-vcs_file_exists-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-quiet-noisy-implicit-f-vcs_file_exists-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-quiet-noisy-implicit-f-vcs_file_exists-checking.patch

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
Subject: get_maintainer: quiet noisy implicit -f vcs_file_exists checking

Checking command line filenames that are outside the git tree can emit a
noisy and confusing message.

Quiet that message by redirecting stderr.
Verify that the command was executed successfully.

Fixes: 4cad35a7ca69 ("get_maintainer.pl: reduce need for command-line option -f")
Link: http://lkml.kernel.org/r/1970a1d2fecb258e384e2e4fdaacdc9ccf3e30a4.1470955439.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/get_maintainer.pl~get_maintainer-quiet-noisy-implicit-f-vcs_file_exists-checking scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-quiet-noisy-implicit-f-vcs_file_exists-checking
+++ a/scripts/get_maintainer.pl
@@ -2136,9 +2136,11 @@ sub vcs_file_exists {
 
     my $cmd = $VCS_cmds{"file_exists_cmd"};
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
