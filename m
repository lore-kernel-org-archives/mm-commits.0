Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F30C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B69C206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026849;
	bh=RXlMe9sdVvN3hLfKk7LX9HmuMMp3z/75VYPIXYr7c3I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0grb4F0e00HCAwwWRVgxFc9nlqdRxyPxCGwvXUhKxwRsrqE0QkT8qFCcpG7jZ8fXX
	 TOH5MP7Gk1IQ7jKUpFhve9WfgYEeZw8jMeej7qxJQ2CkClwHvpL2DO1V8tY4igqMmR
	 H6pIbtT3c/ERMNv81WkPM5qycB7mJ8zMUPgxd1Yk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHJCeJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:09 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617A9206CD;
        Mon, 10 Aug 2020 02:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026848;
        bh=RXlMe9sdVvN3hLfKk7LX9HmuMMp3z/75VYPIXYr7c3I=;
        h=Date:From:To:Subject:From;
        b=fmAWtXb34B3oj66iDHRLPEZAnYTSybuQL71hgcbU4Ow+xZc3+J/RCsIjqnletHXqq
         UNkPEZXN0noSJmNthssw25M1yHDmxee/zV63w21bSgpfr9X02FQJH1DI8fRTkRV4TD
         eCvj3DcTAS1vGoY8wBcp4p53qkbk6v6QIYs/mCa4=
Date:   Sun, 09 Aug 2020 19:34:08 -0700
From:   akpm@linux-foundation.org
To:     khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org,
        sashal@kernel.org
Subject:  [merged]
 scripts-decode_stacktrace-guess-basepath-if-not-specified.patch removed
 from -mm tree
Message-ID: <20200810023408.Ito7GCH5c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace.sh: guess basepath if not specified
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktrace-guess-basepath-if-not-specified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: scripts/decode_stacktrace.sh: guess basepath if not specified

Guess path to kernel sources using known location of symbol "kernel_init".
Make basepath argument optional.

Before:

$ echo 'vfs_open+0x0/0x0' | ./scripts/decode_stacktrace.sh vmlinux ""
vfs_open (home/khlebnikov/src/linux/fs/open.c:912)

After:

$ echo 'vfs_open+0x0/0x0' | ./scripts/decode_stacktrace.sh vmlinux
vfs_open (fs/open.c:912)

Link: http://lkml.kernel.org/r/159282922803.248444.2379229451667913634.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-guess-basepath-if-not-specified
+++ a/scripts/decode_stacktrace.sh
@@ -3,14 +3,14 @@
 # (c) 2014, Sasha Levin <sasha.levin@oracle.com>
 #set -x
 
-if [[ $# < 2 ]]; then
+if [[ $# < 1 ]]; then
 	echo "Usage:"
-	echo "	$0 [vmlinux] [base path] [modules path]"
+	echo "	$0 <vmlinux> [base path] [modules path]"
 	exit 1
 fi
 
 vmlinux=$1
-basepath=$2
+basepath=${2-auto}
 modpath=$3
 declare -A cache
 declare -A modcache
@@ -152,6 +152,14 @@ handle_line() {
 	echo "${words[@]}" "$symbol $module"
 }
 
+if [[ $basepath == "auto" ]] ; then
+	module=""
+	symbol="kernel_init+0x0/0x0"
+	parse_symbol
+	basepath=${symbol#kernel_init (}
+	basepath=${basepath%/init/main.c:*)}
+fi
+
 while read line; do
 	# Let's see if we have an address in the line
 	if [[ $line =~ \[\<([^]]+)\>\] ]] ||
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch

