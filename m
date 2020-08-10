Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69DDC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28D5206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026851;
	bh=TQDZTtfh4+A/R7jO6YMElCZ6QsURqgO/reCUOSZt/wk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Zsg1B/lKP1oCXi2eR9uyaoMosB4dZt8A8bZul7MyMlNe9NNoIx7eR0ffGno+NM8eK
	 YkCpUzKN0P9PD0i29NkXaQT8yyEJNM9j9Nf6iyqLvwlsP04m2D1lWOPYPcrqO5NJQv
	 Oyy3wA9q66k4aev9CDFpNGS3zN43OBuDF9mJIDqE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHJCeL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:11 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAE5206C3;
        Mon, 10 Aug 2020 02:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026850;
        bh=TQDZTtfh4+A/R7jO6YMElCZ6QsURqgO/reCUOSZt/wk=;
        h=Date:From:To:Subject:From;
        b=OjCAPwOPTTMNl1JKoBH3MLluA3YcXWngCODixlt2mlfrrCe4IpBj7pnW5tIZ3Dd7U
         YpzKgK1arRbJKA5+w+rtAdgCsho24fJaYW2z+VmD++69fKZv20osc8I6ileygQxmPO
         ifO8rceRYIn69sdjlvVJv5nbxOZtQ9Nei3L+BP10=
Date:   Sun, 09 Aug 2020 19:34:10 -0700
From:   akpm@linux-foundation.org
To:     khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org,
        sashal@kernel.org
Subject:  [merged]
 scripts-decode_stacktrace-guess-path-to-modules.patch removed from -mm tree
Message-ID: <20200810023410.k0kmAD0Cd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace.sh: guess path to modules
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktrace-guess-path-to-modules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: scripts/decode_stacktrace.sh: guess path to modules

Try to find module in directory with vmlinux (for fresh build).  Then try
standard paths where debuginfo are usually placed.  Pick first file which
have elf section '.debug_line'.

Before:

$ echo 'tap_open+0x0/0x0 [tap]' |
  ./scripts/decode_stacktrace.sh /usr/lib/debug/boot/vmlinux-5.4.0-37-generic
WARNING! Modules path isn't set, but is needed to parse this symbol
tap_open+0x0/0x0 tap

After:

$ echo 'tap_open+0x0/0x0 [tap]' |
  ./scripts/decode_stacktrace.sh /usr/lib/debug/boot/vmlinux-5.4.0-37-generic
tap_open (drivers/net/tap.c:502) tap

Link: http://lkml.kernel.org/r/159282923068.248444.5461337458421616083.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   36 ++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-guess-path-to-modules
+++ a/scripts/decode_stacktrace.sh
@@ -12,9 +12,40 @@ fi
 vmlinux=$1
 basepath=${2-auto}
 modpath=$3
+release=""
+
 declare -A cache
 declare -A modcache
 
+find_module() {
+	if [[ "$modpath" != "" ]] ; then
+		for fn in $(find "$modpath" -name "${module//_/[-_]}.ko*") ; do
+			if readelf -WS "$fn" | grep -qwF .debug_line ; then
+				echo $fn
+				return
+			fi
+		done
+		return 1
+	fi
+
+	modpath=$(dirname "$vmlinux")
+	find_module && return
+
+	if [[ $release == "" ]] ; then
+		release=$(gdb -ex 'print init_uts_ns.name.release' -ex 'quit' -quiet -batch "$vmlinux" | sed -n 's/\$1 = "\(.*\)".*/\1/p')
+	fi
+
+	for dn in {/usr/lib/debug,}/lib/modules/$release ; do
+		if [ -e "$dn" ] ; then
+			modpath="$dn"
+			find_module && return
+		fi
+	done
+
+	modpath=""
+	return 1
+}
+
 parse_symbol() {
 	# The structure of symbol at this point is:
 	#   ([name]+[offset]/[total length])
@@ -27,12 +58,11 @@ parse_symbol() {
 	elif [[ "${modcache[$module]+isset}" == "isset" ]]; then
 		local objfile=${modcache[$module]}
 	else
-		if [[ $modpath == "" ]]; then
+		local objfile=$(find_module)
+		if [[ $objfile == "" ]] ; then
 			echo "WARNING! Modules path isn't set, but is needed to parse this symbol" >&2
 			return
 		fi
-		local objfile=$(find "$modpath" -name "${module//_/[-_]}.ko*" -print -quit)
-		[[ $objfile == "" ]] && return
 		modcache[$module]=$objfile
 	fi
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch

