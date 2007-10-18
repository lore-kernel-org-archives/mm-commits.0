From: akpm@linux-foundation.org
Subject: - add-stack-checking-for-blackfin.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:53 -0700
Message-ID: <200710180656.l9I6urES030738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763199AbXJRHQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     Add stack checking for Blackfin
has been removed from the -mm tree.  Its filename was
     add-stack-checking-for-blackfin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add stack checking for Blackfin
From: Mike Frysinger <vapier@gentoo.org>

Simply fill out the bits in checkstack.pl for Blackfin.  I thought I already
sent this, but I don't see it in -mm anywhere ...

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/checkstack.pl~add-stack-checking-for-blackfin scripts/checkstack.pl
--- a/scripts/checkstack.pl~add-stack-checking-for-blackfin
+++ a/scripts/checkstack.pl
@@ -78,6 +78,9 @@ my (@stack, $re, $x, $xs);
 		#     pair for larger users. -- PFM.
 		#a00048e0:       d4fc40f0        addi.l  r15,-240,r15
 		$re = qr/.*addi\.l.*r15,-(([0-9]{2}|[3-9])[0-9]{2}),r15/o;
+	} elsif ($arch =~ /^blackfin$/) {
+		#   0:   00 e8 38 01     LINK 0x4e0;
+		$re = qr/.*[[:space:]]LINK[[:space:]]*(0x$x{1,8})/o;
 	} else {
 		print("wrong or unknown architecture\n");
 		exit
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
