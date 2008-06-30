From: akpm@linux-foundation.org
Subject: + checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:19:04 -0700
Message-ID: <200806302219.m5UMJ5U8028552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932880AbYF3WTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, apw@shadowen.org


The patch titled
     checkpatch: add a checkpatch warning for new uses of __initcall().
has been added to the -mm tree.  Its filename is
     checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add a checkpatch warning for new uses of __initcall().
From: Michael Ellerman <michael@ellerman.id.au>

[apw@shadowen.org: generalise pattern and add tests]
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall
+++ a/scripts/checkpatch.pl
@@ -2108,6 +2108,10 @@ sub process {
 		if ($line =~ /\bsimple_(strto.*?)\s*\(/) {
 			WARN("consider using strict_$1 in preference to simple_$1\n" . $herecurr);
 		}
+# check for __initcall(), use device_initcall() explicitly please
+		if ($line =~ /^.\s*__initcall\s*\(/) {
+			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
+		}
 
 # use of NR_CPUS is usually wrong
 # ignore definitions of NR_CPUS and usage to define arrays as likely right
_

Patches currently in -mm which might be from michael@ellerman.id.au are

checkpatch-add-a-checkpatch-warning-for-new-uses-of-__initcall.patch

