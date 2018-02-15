From: akpm@linux-foundation.org
Subject: + checkpatch-improve-parse_email-signature-checking.patch added
 to -mm tree
Date: Wed, 14 Feb 2018 16:03:29 -0800
Message-ID: <5a84ce51.0wuyhi9/ij+AiR2f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031901AbeBOADb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Feb 2018 19:03:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve parse_email signature checking
has been added to the -mm tree.  Its filename is
     checkpatch-improve-parse_email-signature-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-parse_email-signature-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-parse_email-signature-checking.patch

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
Subject: checkpatch: improve parse_email signature checking

Bare email addresses with non alphanumeric characters require escape
quoting before being substituted in the parse_email routine.

e.g. Reported-by: syzbot+bbd8e9a06452cc48059b@syzkaller.appspotmail.com

Do so.

Link: http://lkml.kernel.org/r/1518631805.3678.12.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-parse_email-signature-checking scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-parse_email-signature-checking
+++ a/scripts/checkpatch.pl
@@ -1075,7 +1075,7 @@ sub parse_email {
 	} elsif ($formatted_email =~ /(\S+\@\S+)(.*)$/) {
 		$address = $1;
 		$comment = $2 if defined $2;
-		$formatted_email =~ s/$address.*$//;
+		$formatted_email =~ s/\Q$address\E.*$//;
 		$name = $formatted_email;
 		$name = trim($name);
 		$name =~ s/^\"|\"$//g;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-parse_email-signature-checking.patch

