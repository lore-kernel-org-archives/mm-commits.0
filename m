Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CBEC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81975613E6
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhGIVgS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhGIVgS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D419E613DF;
        Fri,  9 Jul 2021 21:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866414;
        bh=2KotMUQdSnr0KLvPD7YPZQjBZwvZdM++ikiakn4utEo=;
        h=Date:From:To:Subject:From;
        b=oMUY8lnXdFtGefv3z7k1+tuSuYNO9roLsicUrNd/Gehp2nt6274BvJME0eRbvJ+ts
         gAcxfyq+nOjUHH9Atq2gSW+74br3oHE8GUYFnBZcpE3drQQGwYJktPA4l05R3so/hR
         8u24bwinAT13P3nlN9K/wwGS1jSe6Fp6dq98uHYg=
Date:   Fri, 09 Jul 2021 14:33:33 -0700
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
Subject:  [merged]
 scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch
 removed from -mm tree
Message-ID: <20210709213333.EES9y_Sls%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace.sh: silence stderr messages from addr2line/nm
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: scripts/decode_stacktrace.sh: silence stderr messages from addr2line/nm

Sometimes if you're using tools that have linked things improperly or have
new features/sections that older tools don't expect you'll see warnings
printed to stderr.  We don't really care about these warnings, so let's
just silence these messages to cleanup output of this script.

Link: https://lkml.kernel.org/r/20210511003845.2429846-10-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm
+++ a/scripts/decode_stacktrace.sh
@@ -74,7 +74,7 @@ find_module() {
 	find_module && return
 
 	if [[ $release == "" ]] ; then
-		release=$(gdb -ex 'print init_uts_ns.name.release' -ex 'quit' -quiet -batch "$vmlinux" | sed -n 's/\$1 = "\(.*\)".*/\1/p')
+		release=$(gdb -ex 'print init_uts_ns.name.release' -ex 'quit' -quiet -batch "$vmlinux" 2>/dev/null | sed -n 's/\$1 = "\(.*\)".*/\1/p')
 	fi
 
 	for dn in {/usr/lib/debug,}/lib/modules/$release ; do
@@ -128,7 +128,7 @@ parse_symbol() {
 	if [[ "${cache[$module,$name]+isset}" == "isset" ]]; then
 		local base_addr=${cache[$module,$name]}
 	else
-		local base_addr=$(nm "$objfile" | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
+		local base_addr=$(nm "$objfile" 2>/dev/null | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
 		if [[ $base_addr == "" ]] ; then
 			# address not found
 			return
@@ -152,7 +152,7 @@ parse_symbol() {
 	if [[ "${cache[$module,$address]+isset}" == "isset" ]]; then
 		local code=${cache[$module,$address]}
 	else
-		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address")
+		local code=$(${CROSS_COMPILE}addr2line -i -e "$objfile" "$address" 2>/dev/null)
 		cache[$module,$address]=$code
 	fi
 
_

Patches currently in -mm which might be from swboyd@chromium.org are


