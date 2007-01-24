From: akpm@osdl.org
Subject: + sed-s-gawk-awk-scripts-gen_init_ramfssh.patch added to -mm tree
Date: Tue, 23 Jan 2007 16:47:00 -0800
Message-ID: <200701240047.l0O0l0AS004165@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965471AbXAXArH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 19:47:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, sam@ravnborg.org


The patch titled
     sed s/gawk/awk/ scripts/gen_init_ramfs.sh
has been added to the -mm tree.  Its filename is
     sed-s-gawk-awk-scripts-gen_init_ramfssh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sed s/gawk/awk/ scripts/gen_init_ramfs.sh
From: Rob Landley <rob@landley.net>

There's a symlink from awk to gawk if you're using the gnu tools, but no
symlink from gawk to awk if you're using BusyBox or some such.  (There's a
reason for the existence of standard names.  Can we use them please?)

Signed-off-by: Rob Landley <rob@landley.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/gen_initramfs_list.sh |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~sed-s-gawk-awk-scripts-gen_init_ramfssh scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~sed-s-gawk-awk-scripts-gen_init_ramfssh
+++ a/scripts/gen_initramfs_list.sh
@@ -121,9 +121,9 @@ parse() {
 		"nod")
 			local dev_type=
 			local maj=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{sub(/,/, "", $5); print $5}')
+					awk '{sub(/,/, "", $5); print $5}')
 			local min=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{print $6}')
+					awk '{print $6}')
 
 			if [ -b "${location}" ]; then
 				dev_type="b"
@@ -134,7 +134,7 @@ parse() {
 			;;
 		"slink")
 			local target=$(LC_ALL=C ls -l "${location}" | \
-					gawk '{print $11}')
+					awk '{print $11}')
 			str="${ftype} ${name} ${target} ${str}"
 			;;
 		*)
_

Patches currently in -mm which might be from rob@landley.net are

sed-s-gawk-awk-scripts-gen_init_ramfssh.patch
