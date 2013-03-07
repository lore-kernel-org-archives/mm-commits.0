From: akpm@linux-foundation.org
Subject: + checkpatch-prevent-use-of-unitialized-variable.patch added to -mm tree
Date: Wed, 06 Mar 2013 16:21:49 -0800
Message-ID: <20130307002149.6FECB5A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:41722 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3CGAVu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 19:21:50 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so937163vea.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 16:21:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iveqy@iveqy.com, joe@perches.com


The patch titled
     Subject: checkpatch: prevent use of unitialized variable
has been added to the -mm tree.  Its filename is
     checkpatch-prevent-use-of-unitialized-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fredrik Gustafsson <iveqy@iveqy.com>
Subject: checkpatch: prevent use of unitialized variable

Run checkpatch.pl -f kernel/fork.c in commit ecf02a607bd801e7 and
checkpatch.pl will try to use an uninitialized variable.  This patch fixes
that.

Signed-off-by: Fredrik Gustafsson <iveqy@iveqy.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-prevent-use-of-unitialized-variable scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prevent-use-of-unitialized-variable
+++ a/scripts/checkpatch.pl
@@ -3379,14 +3379,17 @@ sub process {
 
 			my $ms_addr = $2;
 			my $ms_val = $7;
-			my $ms_size = $12;
 
-			if ($ms_size =~ /^(0x|)0$/i) {
-				ERROR("MEMSET",
-				      "memset to 0's uses 0 as the 2nd argument, not the 3rd\n" . "$here\n$stat\n");
-			} elsif ($ms_size =~ /^(0x|)1$/i) {
-				WARN("MEMSET",
-				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . "$here\n$stat\n");
+			if (defined $12) {
+				my $ms_size = $12;
+
+				if ($ms_size =~ /^(0x|)0$/i) {
+					ERROR("MEMSET",
+						  "memset to 0's uses 0 as the 2nd argument, not the 3rd\n" . "$here\n$stat\n");
+				} elsif ($ms_size =~ /^(0x|)1$/i) {
+					WARN("MEMSET",
+						 "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . "$here\n$stat\n");
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from iveqy@iveqy.com are

checkpatch-prevent-use-of-unitialized-variable.patch

