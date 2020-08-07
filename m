Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53824C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30619221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781060;
	bh=BzNFnikdwUm2ueekbCaXzR1+hwYi6tFIhMeqZpbBYv4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tuDZo1cvChX7vLaKBx0DBNjpkweiXb7fjbC1EgCJyj2q4NocgEZkcgzbLtVdHziSI
	 nkSRXfiWy2ZxKYGQbybf7sc1F3DJvYPYHb6EhSDZukXE0A8Mj4muk414kDXLuJgTEl
	 GskqyTEjibyPJYJevOPlDlvI6qOrZS6CXO3Usazw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGGRj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73F1C2177B;
        Fri,  7 Aug 2020 06:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781058;
        bh=BzNFnikdwUm2ueekbCaXzR1+hwYi6tFIhMeqZpbBYv4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=K5fzZ13D+CFYGWqhZ+oV1ehQKNTRTD1UDrz7a8S5CgAVu5ENDffsNDAx7xZum1HxE
         dLWemmuT8z9iDUqjCZG50QtKtR2GD8x3q3LZDOkEQX+4luVC+vpFsfsziF3EvgK8g5
         6kTupA0Cn6b6kuG8D5uKrl9umrCruX5S9Z8AWB8s=
Date:   Thu, 06 Aug 2020 23:17:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, khlebnikov@yandex-team.ru,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sashal@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 011/163] scripts/decode_stacktrace.sh: guess
 basepath if not specified
Message-ID: <20200807061738.5uS4tlDwj%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
