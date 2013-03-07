From: akpm@linux-foundation.org
Subject: [obsolete] checkpatch-prevent-use-of-unitialized-variable.patch removed from -mm tree
Date: Wed, 06 Mar 2013 16:36:07 -0800
Message-ID: <20130307003607.C195A31C1B5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:63032 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab3CGAgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 19:36:09 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so355345vbb.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 16:36:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iveqy@iveqy.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prevent use of unitialized variable
has been removed from the -mm tree.  Its filename was
     checkpatch-prevent-use-of-unitialized-variable.patch

This patch was dropped because it is obsolete

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


