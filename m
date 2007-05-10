From: akpm@linux-foundation.org
Subject: + time-locale-in-gen_initramfs_listsh.patch added to -mm tree
Date: Wed, 09 May 2007 17:09:39 -0700
Message-ID: <200705100009.l4A09dCX006523@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760594AbXEJAKO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 20:10:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian.fainelli@int-evry.fr, sam@ravnborg.org


The patch titled
     time locale in gen_initramfs_list.sh
has been added to the -mm tree.  Its filename is
     time-locale-in-gen_initramfs_listsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: time locale in gen_initramfs_list.sh
From: Florian Fainelli <florian.fainelli@int-evry.fr>

I noticed that some zsh users who forced their ls formatting to something non
standard could not generate the initramfs file list.  Forcing the locale to C
while generating seems not to be enough.  Adding --time-style=locale will use
C locale ls output and will let them generate the initramfs list.  It has no
side effects for other users.

Signed-off-by: Florian Fainelli <florian.fainelli@int-evry.fr>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~time-locale-in-gen_initramfs_listsh scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~time-locale-in-gen_initramfs_listsh
+++ a/scripts/gen_initramfs_list.sh
@@ -125,7 +125,7 @@ parse() {
 			str="${ftype} ${name} ${location} ${str}"
 			;;
 		"nod")
-			local dev=`LC_ALL=C ls -l "${location}"`
+			local dev=`LC_ALL=C ls --time-style=locale -l "${location}"`
 			local maj=`field 5 ${dev}`
 			local min=`field 6 ${dev}`
 			maj=${maj%,}
@@ -135,7 +135,7 @@ parse() {
 			str="${ftype} ${name} ${str} ${dev} ${maj} ${min}"
 			;;
 		"slink")
-			local target=`field 11 $(LC_ALL=C ls -l "${location}")`
+			local target=`field 11 $(LC_ALL=C ls --time-style=locale -l "${location}")`
 			str="${ftype} ${name} ${target} ${str}"
 			;;
 		*)
_

Patches currently in -mm which might be from florian.fainelli@int-evry.fr are

time-locale-in-gen_initramfs_listsh.patch
git-watchdog.patch
