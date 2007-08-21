From: akpm@linux-foundation.org
Subject: + add-stack-checking-for-blackfin.patch added to -mm tree
Date: Tue, 21 Aug 2007 15:30:48 -0700
Message-ID: <200708212230.l7LMUmnI014746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbXHUWbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 18:31:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, bryan.wu@analog.com


The patch titled
     Add stack checking for Blackfin
has been added to the -mm tree.  Its filename is
     add-stack-checking-for-blackfin.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+)

diff -puN scripts/checkstack.pl~add-stack-checking-for-blackfin scripts/checkstack.pl
--- a/scripts/checkstack.pl~add-stack-checking-for-blackfin
+++ a/scripts/checkstack.pl
@@ -73,6 +73,9 @@ my (@stack, $re, $x, $xs);
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

clean-modulessymvers-in-external-module-dirs.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
add-stack-checking-for-blackfin.patch
