Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15ABC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  9 Apr 2022 21:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiDIV5k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 9 Apr 2022 17:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiDIV5j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 9 Apr 2022 17:57:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EC4B1A8C
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 14:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 522F96090A
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 21:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9225AC385A0;
        Sat,  9 Apr 2022 21:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649541328;
        bh=1QYotjoWc8j5c5CtWviLVUd8yQUOpzO9NYTMyTNIER8=;
        h=Date:To:From:Subject:From;
        b=onpCS67eUgzVDkRBeF+EZs5OYyrMCTqNqId+hqEm4/dYro1ZyOQR4nESB/SceaoAZ
         UDea8KuFV0NLXO5RFQ3O34ndKvQqIBBhrC49ItgXQ0SKmy1u3w9FkU0gFQoSVdJ4pn
         hgZe6wNNN9ETlSHgZCqsqJsNuH1CqTZY77vz+xys=
Date:   Sat, 09 Apr 2022 14:55:27 -0700
To:     mm-commits@vger.kernel.org, swboyd@chromium.org, schspa@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-support-old-bash-version.patch added to -mm tree
Message-Id: <20220409215528.9225AC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace.sh: support old bash version
has been added to the -mm tree.  Its filename is
     scripts-decode_stacktracesh-support-old-bash-version.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-decode_stacktracesh-support-old-bash-version.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-decode_stacktracesh-support-old-bash-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-decode_stacktracesh-support-old-bash-version.patch

