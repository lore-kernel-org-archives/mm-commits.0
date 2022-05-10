Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F69C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbiEJEXf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiEJEVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566B61B090C
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B53AB81AFB
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3299C385A6;
        Tue, 10 May 2022 04:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156243;
        bh=j4K2XGTdifH6Lknsy+QvlN95mTAvOdOgwsWErcNe8Jk=;
        h=Date:To:From:Subject:From;
        b=EkzxrG+IzO+/7p52SCaQicMz/DnNiRVdtEcrK/VIeLqPxT8bdM89El/MgBl4TQQ4i
         TG4OP93GWQwkrnD9xWm/+IaEfLlS5ZwERhHbv1KnrIPS9BHE+jCw4m7lVEXb9V3tUS
         y1JD6zb9MeORZP5t7rg/yTMcD4qCf88tWG454tTw=
Date:   Mon, 09 May 2022 21:17:23 -0700
To:     mm-commits@vger.kernel.org, swboyd@chromium.org, schspa@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decode_stacktracesh-support-old-bash-version.patch removed from -mm tree
Message-Id: <20220510041723.B3299C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: support old bash version
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-support-old-bash-version.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Schspa Shi <schspa@gmail.com>
Subject: scripts/decode_stacktrace.sh: support old bash version

Old bash version don't support associative array variables.  Avoid to use
associative array variables to avoid error.

Without this, old bash version will report error as fellowing
[   15.954042] Kernel panic - not syncing: sysrq triggered crash
[   15.955252] CPU: 1 PID: 167 Comm: sh Not tainted 5.18.0-rc1-00208-gb7d075db2fd5 #4
[   15.956472] Hardware name: Hobot J5 Virtual development board (DT)
[   15.957856] Call trace:
./scripts/decode_stacktrace.sh: line 128: ,dump_backtrace: syntax error: operand expected (error token is ",dump_backtrace")

Link: https://lkml.kernel.org/r/20220409180331.24047-1-schspa@gmail.com
Signed-off-by: Schspa Shi <schspa@gmail.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-support-old-bash-version
+++ a/scripts/decode_stacktrace.sh
@@ -45,8 +45,13 @@ else
 	fi
 fi
 
-declare -A cache
-declare -A modcache
+declare aarray_support=true
+declare -A cache 2>/dev/null
+if [[ $? != 0 ]]; then
+	aarray_support=false
+else
+	declare -A modcache
+fi
 
 find_module() {
 	if [[ -n $debuginfod ]] ; then
@@ -97,7 +102,7 @@ parse_symbol() {
 
 	if [[ $module == "" ]] ; then
 		local objfile=$vmlinux
-	elif [[ "${modcache[$module]+isset}" == "isset" ]]; then
+	elif [[ $aarray_support == true && "${modcache[$module]+isset}" == "isset" ]]; then
 		local objfile=${modcache[$module]}
 	else
 		local objfile=$(find_module)
@@ -105,7 +110,9 @@ parse_symbol() {
 			echo "WARNING! Modules path isn't set, but is needed to parse this symbol" >&2
 			return
 		fi
-		modcache[$module]=$objfile
+		if [[ $aarray_support == true ]]; then
+			modcache[$module]=$objfile
+		fi
 	fi
 
 	# Remove the englobing parenthesis
@@ -125,7 +132,7 @@ parse_symbol() {
 	# Use 'nm vmlinux' to figure out the base address of said symbol.
 	# It's actually faster to call it every time than to load it
 	# all into bash.
-	if [[ "${cache[$module,$name]+isset}" == "isset" ]]; then
+	if [[ $aarray_support == true && "${cache[$module,$name]+isset}" == "isset" ]]; then
 		local base_addr=${cache[$module,$name]}
 	else
 		local base_addr=$(nm "$objfile" 2>/dev/null | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
@@ -133,7 +140,9 @@ parse_symbol() {
 			# address not found
 			return
 		fi
-		cache[$module,$name]="$base_addr"
+		if [[ $aarray_support == true ]]; then
+			cache[$module,$name]="$base_addr"
+		fi
 	fi
 	# Let's start doing the math to get the exact address into the
 	# symbol. First, strip out the symbol total length.
@@ -149,11 +158,13 @@ parse_symbol() {
 
 	# Pass it to addr2line to get filename and line number
 	# Could get more than one result
-	if [[ "${cache[$module,$address]+isset}" == "isset" ]]; then
+	if [[ $aarray_support == true && "${cache[$module,$address]+isset}" == "isset" ]]; then
 		local code=${cache[$module,$address]}
 	else
 		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address" 2>/dev/null)
-		cache[$module,$address]=$code
+		if [[ $aarray_support == true ]]; then
+			cache[$module,$address]=$code
+		fi
 	fi
 
 	# addr2line doesn't return a proper error code if it fails, so
_

Patches currently in -mm which might be from schspa@gmail.com are


