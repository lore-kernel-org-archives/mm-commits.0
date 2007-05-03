From: akpm@linux-foundation.org
Subject: - kbuild-handle-compressed-cpio-initramfs-es.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:11 -0700
Message-ID: <200705031931.l43JVBFj018243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767845AbXECTdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: landau.alex@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: handle compressed cpio initramfs-es
has been removed from the -mm tree.  Its filename was
     kbuild-handle-compressed-cpio-initramfs-es.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kbuild: handle compressed cpio initramfs-es
From: "Alex Landau" <landau.alex@gmail.com>

Make kbuild handle compressed cpio initramfs-es.  An already compressed
cpio is copied directly to usr/, while a non-compressed cpio is filtered
through gzip (no changes here) on its way to usr/.

If the user has created a compressed cpio by other means, this saves him
from uncompressing it, just to be compressed again by kbuild.

Signed-off-by: Alex Landau <landau.alex@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~kbuild-handle-compressed-cpio-initramfs-es scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~kbuild-handle-compressed-cpio-initramfs-es
+++ a/scripts/gen_initramfs_list.sh
@@ -191,9 +191,10 @@ input_file() {
 	source="$1"
 	if [ -f "$1" ]; then
 		${dep_list}header "$1"
-		is_cpio="$(echo "$1" | sed 's/^.*\.cpio/cpio/')"
+		is_cpio="$(echo "$1" | sed 's/^.*\.cpio\(\..*\)\?/cpio/')"
 		if [ $2 -eq 0 -a ${is_cpio} == "cpio" ]; then
 			cpio_file=$1
+			echo "$1" | grep -q '^.*\.cpio\..*' && is_cpio_compressed="compressed"
 			[ ! -z ${dep_list} ] && echo "$1"
 			return 0
 		fi
@@ -223,6 +224,7 @@ cpio_file=
 cpio_list=
 output="/dev/stdout"
 output_file=""
+is_cpio_compressed=
 
 arg="$1"
 case "$arg" in
@@ -282,7 +284,11 @@ if [ ! -z ${output_file} ]; then
 		cpio_tfile=${cpio_file}
 	fi
 	rm ${cpio_list}
-	cat ${cpio_tfile} | gzip -f -9 - > ${output_file}
+	if [ "${is_cpio_compressed}" = "compressed" ]; then
+		cat ${cpio_tfile} > ${output_file}
+	else
+		cat ${cpio_tfile} | gzip -f -9 - > ${output_file}
+	fi
 	[ -z ${cpio_file} ] && rm ${cpio_tfile}
 fi
 exit 0
_

Patches currently in -mm which might be from landau.alex@gmail.com are

git-kbuild.patch
