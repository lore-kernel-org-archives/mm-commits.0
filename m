From: akpm@linux-foundation.org
Subject: - gen_initramfs_listsh-fix-unportability.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:58 -0700
Message-ID: <200804282201.m3SM1wLK018912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965333AbYD1WCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nbd@openwrt.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     gen_initramfs_list.sh: fix unportability
has been removed from the -mm tree.  Its filename was
     gen_initramfs_listsh-fix-unportability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gen_initramfs_list.sh: fix unportability
From: Felix Fietkau <nbd@openwrt.org>

On a Mac OS X machine the output of ls -l is different from a standard Linux
machine.  Use readlink instead of parsing a hardcoded field number from the ls
output.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gen_initramfs_list.sh~gen_initramfs_listsh-fix-unportability scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~gen_initramfs_listsh-fix-unportability
+++ a/scripts/gen_initramfs_list.sh
@@ -135,7 +135,7 @@ parse() {
 			str="${ftype} ${name} ${str} ${dev} ${maj} ${min}"
 			;;
 		"slink")
-			local target=`field 11 $(LC_ALL=C ls -l "${location}")`
+			local target=`readlink "${location}"`
 			str="${ftype} ${name} ${target} ${str}"
 			;;
 		*)
_

Patches currently in -mm which might be from nbd@openwrt.org are

origin.patch
git-kbuild.patch

