Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0971C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 990A3616EC
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhEKBga (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhEKBg3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B8D617ED;
        Tue, 11 May 2021 01:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620696923;
        bh=hqeyGU+98SyQLftKmLjvS2ZbnU1hCnujZuG2oH8tiuY=;
        h=Date:From:To:Subject:From;
        b=A+N41tfYSzKOfr1eJD/BIPvNpKOn51efXg+mBcpDTzbNaUSHL37TvAmLEni5Pmxcr
         gPR58ctLbp84D8WBnegBCxCmV88pP93gloF3SZ+hVXrhp5HfHkJljeiL5FVjsllemP
         EotFlttCm59hZD6/EM/DWIWv19wYSNVrPI7oMfPQ=
Date:   Mon, 10 May 2021 18:35:22 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ast@kernel.org, bhe@redhat.com,
        bp@alien8.de, catalin.marinas@arm.com, dyoung@redhat.com,
        evgreen@chromium.org, hsinyi@chromium.org, jeyu@kernel.org,
        jolsa@kernel.org, khlebnikov@yandex-team.ru,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de, vgoyal@redhat.com,
        will@kernel.org, willy@infradead.org
Subject:  + scripts-decode_stacktracesh-support-debuginfod.patch
 added to -mm tree
Message-ID: <20210511013522.MF3KV0Pbl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace.sh: support debuginfod
has been added to the -mm tree.  Its filename is
     scripts-decode_stacktracesh-support-debuginfod.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-decode_stacktracesh-support-debuginfod.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-decode_stacktracesh-support-debuginfod.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: scripts/decode_stacktrace.sh: support debuginfod

Now that stacktraces contain the build ID information we can update this
script to use debuginfod-find to locate the debuginfo for the vmlinux and
modules automatically.  This can replace the existing code that requires
specifying a path to vmlinux or tries to find the vmlinux and modules
automatically by using the release number.  Work it into the script as a
fallback option if the vmlinux isn't specified on the commandline.

Link: https://lkml.kernel.org/r/20210511003845.2429846-9-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   81 ++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 11 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-support-debuginfod
+++ a/scripts/decode_stacktrace.sh
@@ -3,11 +3,10 @@
 # (c) 2014, Sasha Levin <sasha.levin@oracle.com>
 #set -x
 
-if [[ $# < 1 ]]; then
+usage() {
 	echo "Usage:"
 	echo "	$0 -r <release> | <vmlinux> [base path] [modules path]"
-	exit 1
-fi
+}
 
 if [[ $1 == "-r" ]] ; then
 	vmlinux=""
@@ -24,6 +23,7 @@ if [[ $1 == "-r" ]] ; then
 
 	if [[ $vmlinux == "" ]] ; then
 		echo "ERROR! vmlinux image for release $release is not found" >&2
+		usage
 		exit 2
 	fi
 else
@@ -31,12 +31,35 @@ else
 	basepath=${2-auto}
 	modpath=$3
 	release=""
+	debuginfod=
+
+	# Can we use debuginfod-find?
+	if type debuginfod-find >/dev/null 2>&1 ; then
+		debuginfod=${1-only}
+	fi
+
+	if [[ $vmlinux == "" && -z $debuginfod ]] ; then
+		echo "ERROR! vmlinux image must be specified" >&2
+		usage
+		exit 1
+	fi
 fi
 
 declare -A cache
 declare -A modcache
 
 find_module() {
+	if [[ -n $debuginfod ]] ; then
+		if [[ -n $modbuildid ]] ; then
+			debuginfod-find debuginfo $modbuildid && return
+		fi
+
+		# Only using debuginfod so don't try to find vmlinux module path
+		if [[ $debuginfod == "only" ]] ; then
+			return
+		fi
+	fi
+
 	if [[ "$modpath" != "" ]] ; then
 		for fn in $(find "$modpath" -name "${module//_/[-_]}.ko*") ; do
 			if readelf -WS "$fn" | grep -qwF .debug_line ; then
@@ -150,6 +173,27 @@ parse_symbol() {
 	symbol="$segment$name ($code)"
 }
 
+debuginfod_get_vmlinux() {
+	local vmlinux_buildid=${1##* }
+
+	if [[ $vmlinux != "" ]]; then
+		return
+	fi
+
+	if [[ $vmlinux_buildid =~ ^[0-9a-f]+ ]]; then
+		vmlinux=$(debuginfod-find debuginfo $vmlinux_buildid)
+		if [[ $? -ne 0 ]] ; then
+			echo "ERROR! vmlinux image not found via debuginfod-find" >&2
+			usage
+			exit 2
+		fi
+		return
+	fi
+	echo "ERROR! Build ID for vmlinux not found. Try passing -r or specifying vmlinux" >&2
+	usage
+	exit 2
+}
+
 decode_code() {
 	local scripts=`dirname "${BASH_SOURCE[0]}"`
 
@@ -157,6 +201,14 @@ decode_code() {
 }
 
 handle_line() {
+	if [[ $basepath == "auto" && $vmlinux != "" ]] ; then
+		module=""
+		symbol="kernel_init+0x0/0x0"
+		parse_symbol
+		basepath=${symbol#kernel_init (}
+		basepath=${basepath%/init/main.c:*)}
+	fi
+
 	local words
 
 	# Tokenize
@@ -182,16 +234,28 @@ handle_line() {
 		fi
 	done
 
+	if [[ ${words[$last]} =~ ^[0-9a-f]+\] ]]; then
+		words[$last-1]="${words[$last-1]} ${words[$last]}"
+		unset words[$last]
+		last=$(( $last - 1 ))
+	fi
+
 	if [[ ${words[$last]} =~ \[([^]]+)\] ]]; then
 		module=${words[$last]}
 		module=${module#\[}
 		module=${module%\]}
+		modbuildid=${module#* }
+		module=${module% *}
+		if [[ $modbuildid == $module ]]; then
+			modbuildid=
+		fi
 		symbol=${words[$last-1]}
 		unset words[$last-1]
 	else
 		# The symbol is the last element, process it
 		symbol=${words[$last]}
 		module=
+		modbuildid=
 	fi
 
 	unset words[$last]
@@ -201,14 +265,6 @@ handle_line() {
 	echo "${words[@]}" "$symbol $module"
 }
 
-if [[ $basepath == "auto" ]] ; then
-	module=""
-	symbol="kernel_init+0x0/0x0"
-	parse_symbol
-	basepath=${symbol#kernel_init (}
-	basepath=${basepath%/init/main.c:*)}
-fi
-
 while read line; do
 	# Let's see if we have an address in the line
 	if [[ $line =~ \[\<([^]]+)\>\] ]] ||
@@ -218,6 +274,9 @@ while read line; do
 	# Is it a code line?
 	elif [[ $line == *Code:* ]]; then
 		decode_code "$line"
+	# Is it a version line?
+	elif [[ -n $debuginfod && $line =~ PID:\ [0-9]+\ Comm: ]]; then
+		debuginfod_get_vmlinux "$line"
 	else
 		# Nothing special in this line, show it as is
 		echo "$line"
_

Patches currently in -mm which might be from swboyd@chromium.org are

buildid-only-consider-gnu-notes-for-build-id-parsing.patch
buildid-add-api-to-parse-build-id-out-of-buffer.patch
buildid-stash-away-kernels-build-id-on-init.patch
dump_stack-add-vmlinux-build-id-to-stack-traces.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
arm64-stacktrace-use-%psb-for-backtrace-printing.patch
x86-dumpstack-use-%psb-%pbb-for-backtrace-printing.patch
scripts-decode_stacktracesh-support-debuginfod.patch
scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch
scripts-decode_stacktracesh-indicate-auto-can-be-used-for-base-path.patch
buildid-mark-some-arguments-const.patch
buildid-fix-kernel-doc-notation.patch
kdump-use-vmlinux_build_id-to-simplify.patch

