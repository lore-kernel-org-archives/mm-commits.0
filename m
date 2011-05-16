From: akpm@linux-foundation.org
Subject: [merged] scripts-gen_initramfs_listsh-convert-to-a-bin-sh-script.patch removed from -mm tree
Date: Mon, 16 May 2011 12:37:09 -0700
Message-ID: <201105161936.p4GJasUb014250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276Ab1EPThG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 May 2011 15:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jamey@minilop.net, josh@joshtriplett.org, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     scripts/gen_initramfs_list.sh: convert to a /bin/sh script
has been removed from the -mm tree.  Its filename was
     scripts-gen_initramfs_listsh-convert-to-a-bin-sh-script.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/gen_initramfs_list.sh: convert to a /bin/sh script
From: Jamey Sharp <jamey@minilop.net>

Replace bashisms with POSIX-compatible shell scripting.

Notably, de-duplicate '/' using a sed command from elsewhere in the same
script rather than "${name//\/\///}".

Commit by Jamey Sharp and Josh Triplett.

Signed-off-by: Jamey Sharp <jamey@minilop.net>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~scripts-gen_initramfs_listsh-convert-to-a-bin-sh-script scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~scripts-gen_initramfs_listsh-convert-to-a-bin-sh-script
+++ a/scripts/gen_initramfs_list.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 # Copyright (C) Martin Schlemmer <azarah@nosferatu.za.org>
 # Copyright (C) 2006 Sam Ravnborg <sam@ravnborg.org>
 #
@@ -105,9 +105,9 @@ list_parse() {
 # for links, devices etc the format differs. See gen_init_cpio for details
 parse() {
 	local location="$1"
-	local name="${location/${srcdir}//}"
+	local name="/${location#${srcdir}}"
 	# change '//' into '/'
-	name="${name//\/\///}"
+	name=$(echo "$name" | sed -e 's://*:/:g')
 	local mode="$2"
 	local uid="$3"
 	local gid="$4"
@@ -117,8 +117,8 @@ parse() {
 	[ "$root_gid" = "squash" ] && gid=0 || [ "$gid" -eq "$root_gid" ] && gid=0
 	local str="${mode} ${uid} ${gid}"
 
-	[ "${ftype}" == "invalid" ] && return 0
-	[ "${location}" == "${srcdir}" ] && return 0
+	[ "${ftype}" = "invalid" ] && return 0
+	[ "${location}" = "${srcdir}" ] && return 0
 
 	case "${ftype}" in
 		"file")
@@ -192,7 +192,7 @@ input_file() {
 	if [ -f "$1" ]; then
 		${dep_list}header "$1"
 		is_cpio="$(echo "$1" | sed 's/^.*\.cpio\(\..*\)\?/cpio/')"
-		if [ $2 -eq 0 -a ${is_cpio} == "cpio" ]; then
+		if [ $2 -eq 0 -a ${is_cpio} = "cpio" ]; then
 			cpio_file=$1
 			echo "$1" | grep -q '^.*\.cpio\..*' && is_cpio_compressed="compressed"
 			[ ! -z ${dep_list} ] && echo "$1"
@@ -204,7 +204,7 @@ input_file() {
 		else
 		        echo "$1 \\"
 			cat "$1" | while read type dir file perm ; do
-				if [ "$type" == "file" ]; then
+				if [ "$type" = "file" ]; then
 					echo "$file \\";
 				fi
 			done
_

Patches currently in -mm which might be from jamey@minilop.net are

linux-next.patch

