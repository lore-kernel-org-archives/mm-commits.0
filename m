From: akpm@osdl.org
Subject: - ver_linux-additions.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:01 -0800
Message-ID: <200612072305.kB7N51vj030109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52297 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163876AbWLGXFE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valdis.kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     ver_linux additions
has been removed from the -mm tree.  Its filename was
     ver_linux-additions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ver_linux additions
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>

scripts/ver_linux needed some minor clean-ups, as follows:
1) Add reporting of actual oprofile release
2) Add reporting of actual wireless-tools release
3) Add reporting of actual pcmciautils release

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/ver_linux |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/ver_linux~ver_linux-additions scripts/ver_linux
--- a/scripts/ver_linux~ver_linux-additions
+++ a/scripts/ver_linux
@@ -48,6 +48,8 @@ fsck.reiser4 -V 2>&1 | grep ^fsck.reiser
 xfs_db -V 2>&1 | grep version | awk \
 'NR==1{print "xfsprogs              ", $3}'
 
+pccardctl -V 2>&1| grep pcmciautils | awk '{print "pcmciautils           ", $2}'
+
 cardmgr -V 2>&1| grep version | awk \
 'NR==1{print "pcmcia-cs             ", $3}'
 
@@ -87,10 +89,16 @@ loadkeys -h 2>&1 | awk \
 loadkeys -V 2>&1 | awk \
 '(NR==1 && ($2 ~ /console-tools/)) {print "Console-tools         ", $3}'
 
+oprofiled --version 2>&1 | awk \
+'(NR==1 && ($2 == "oprofile")) {print "oprofile              ", $3}'
+
 expr --v 2>&1 | awk 'NR==1{print "Sh-utils              ", $NF}'
 
 udevinfo -V 2>&1 | grep version | awk '{print "udev                  ", $3}'
 
+iwconfig --version 2>&1 | awk \
+'(NR==1 && ($3 == "version")) {print "wireless-tools        ",$4}'
+
 if [ -e /proc/modules ]; then
     X=`cat /proc/modules | sed -e "s/ .*$//"`
     echo "Modules Loaded         "$X
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are

origin.patch

