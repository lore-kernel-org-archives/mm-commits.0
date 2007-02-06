From: akpm@linux-foundation.org
Subject: - sed-s-gawk-awk-scripts-gen_init_ramfssh.patch removed from -mm tree
Date: Tue, 06 Feb 2007 15:13:52 -0800
Message-ID: <200702062313.l16NDrdw032226@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbXBFXOE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:14:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sed s/gawk/awk/ scripts/gen_init_ramfs.sh
has been removed from the -mm tree.  Its filename was
     sed-s-gawk-awk-scripts-gen_init_ramfssh.patch

This patch was dropped because Oleg Verych sent a new patch

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
documentation-rbtreetxt-updated.patch
