Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5CEC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB0620723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026853;
	bh=k6rYg6uAatvB+Xynt2dtrGFAhNlTLSKNz9jXfTT7l5o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=h1no5+aRh2GErz75pMwi8w8YUwqsXX5HMEEhZM2eMmHSyUUPGnvhJ9h5toMpcgEWn
	 /5Ad5HYD6GuwxKeScxcw3Iy4lNT5s45FCPjVOsmxfsm7JVYhu2SQQvpKNu322DeKnI
	 ZwY/0rZjE9abJPTWbPg2jVK/GlTd3gKAu7rG+jIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgHJCeN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73A68206CD;
        Mon, 10 Aug 2020 02:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026852;
        bh=k6rYg6uAatvB+Xynt2dtrGFAhNlTLSKNz9jXfTT7l5o=;
        h=Date:From:To:Subject:From;
        b=w/MMYqf8OAvSbidQWKWY2voslmzZj/DBGelqJm8y0hgMjUBftQjQsIMKMkIVVz71W
         wuJ+KrtOVxkGiuCnxN3ETY8chW2RB+UBVgr9xVBxdc5rCrRioPP3fQQ0z2bNfD+Gjz
         mGZomot03RR/rkaMDzOPYfJ5eWGXzom137Oi7Jn8=
Date:   Sun, 09 Aug 2020 19:34:12 -0700
From:   akpm@linux-foundation.org
To:     khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org,
        sashal@kernel.org
Subject:  [merged]
 scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch
 removed from -mm tree
Message-ID: <20200810023412.ivqYLYtB4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decode_stacktrace.sh: guess path to vmlinux by release name
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: scripts/decode_stacktrace.sh: guess path to vmlinux by release name

Add option decode_stacktrace -r <release> to specify only release name. 
This is enough to guess standard paths to vmlinux and modules:

$ echo -e 'schedule+0x0/0x0
tap_open+0x0/0x0 [tap]' |
	./scripts/decode_stacktrace.sh -r 5.4.0-37-generic
schedule (kernel/sched/core.c:4138)
tap_open (drivers/net/tap.c:502) tap

Link: http://lkml.kernel.org/r/159282923334.248444.2399153100007347838.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name
+++ a/scripts/decode_stacktrace.sh
@@ -5,14 +5,33 @@
 
 if [[ $# < 1 ]]; then
 	echo "Usage:"
-	echo "	$0 <vmlinux> [base path] [modules path]"
+	echo "	$0 -r <release> | <vmlinux> [base path] [modules path]"
 	exit 1
 fi
 
-vmlinux=$1
-basepath=${2-auto}
-modpath=$3
-release=""
+if [[ $1 == "-r" ]] ; then
+	vmlinux=""
+	basepath="auto"
+	modpath=""
+	release=$2
+
+	for fn in {,/usr/lib/debug}/boot/vmlinux-$release{,.debug} /lib/modules/$release{,/build}/vmlinux ; do
+		if [ -e "$fn" ] ; then
+			vmlinux=$fn
+			break
+		fi
+	done
+
+	if [[ $vmlinux == "" ]] ; then
+		echo "ERROR! vmlinux image for release $release is not found" >&2
+		exit 2
+	fi
+else
+	vmlinux=$1
+	basepath=${2-auto}
+	modpath=$3
+	release=""
+fi
 
 declare -A cache
 declare -A modcache
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch

