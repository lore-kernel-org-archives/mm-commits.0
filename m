Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4092DC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E7C2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781063;
	bh=3lygZn61skO3nENgvbN9CEK39S+HwKM4TZIeg/IYHsI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dXZ7V+b+cJftJKoQa4rRJVJAXSDUlWckjQ5WRBjGe16m4ovC4470Lb/LoRYw9dR60
	 DfZFin2wy7noOw3IR6hnOuPg0GZ1h75AkKFtuDfOpPWKnopkyTWUhQEhq6BnTAamra
	 wymtTVEJXuFKWhPUWZjS/7Qs/XXnIWAzcPXhHAuc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgHGGRm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675BC221E5;
        Fri,  7 Aug 2020 06:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781061;
        bh=3lygZn61skO3nENgvbN9CEK39S+HwKM4TZIeg/IYHsI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fF4RKBA/Dw5gVi1GAWOD5pgAYZqucoU+6Vpnw7HdYzPup4RdNl5a6dj5/OqdSAvYH
         vqMS6HqM9PqRBXUf/wlUrBgJD9S46Q9uST0yfWFEb3Kewma0+p/hmmDee5QuNMLzc8
         8cmVwZDtrTjXRQh1jDDWpJhD08Zc2rLSmFUj7VMg=
Date:   Thu, 06 Aug 2020 23:17:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, khlebnikov@yandex-team.ru,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sashal@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 012/163] scripts/decode_stacktrace.sh: guess path
 to modules
Message-ID: <20200807061741.ZN18xMsId%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
