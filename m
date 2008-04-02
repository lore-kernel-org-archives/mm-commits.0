From: akpm@linux-foundation.org
Subject: + gen_initramfs_listsh-fix-unportability.patch added to -mm tree
Date: Wed, 02 Apr 2008 14:44:07 -0700
Message-ID: <200804022144.m32Li7RC003828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763144AbYDBVoq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 17:44:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nbd@openwrt.org, sam@ravnborg.org


The patch titled
     gen_initramfs_list.sh: fix unportability
has been added to the -mm tree.  Its filename is
     gen_initramfs_listsh-fix-unportability.patch

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

git-net.patch
gen_initramfs_listsh-fix-unportability.patch

