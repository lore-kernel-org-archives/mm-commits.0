Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6220C433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 925E8221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781065;
	bh=ghCvHaU0MhNYqjK58MzNNFkEn04Nm53tON39oKwbNH8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=W/UkGpXBJTqSDDA5PyZlUd/rFMg8PLAF2EyNkd/AIJpuPZyDqj4cT+hE3IgMdzWqM
	 nNijFzCJal8fFuS9XtWf7kjlTXBOIIIfdvdmeCsnTwXlpXkN6wAELxD5H/kkj7Hteu
	 Xmtk3HrOFPwV3XzJcP0HpqaWNhvkvJaIKppTrQww=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgHGGRp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668D22177B;
        Fri,  7 Aug 2020 06:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781064;
        bh=ghCvHaU0MhNYqjK58MzNNFkEn04Nm53tON39oKwbNH8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uHBlGl0ocHXyugJCbYfP/UhjwsqDuMhNcz7oAES/mnEG9pOfS9lIJeJ0+jyAV8FTI
         4fGBrLuB2IfucjC0edC7Jn2NV0hhcJ6p46DHXvAph47bMpa+CyDq6tf24WSWmCzIz3
         0mHd3WHrgSHIsrc+23ucdTadbRJySzr71lBRD0KA=
Date:   Thu, 06 Aug 2020 23:17:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, khlebnikov@yandex-team.ru,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, sashal@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 013/163] scripts/decode_stacktrace.sh: guess path
 to vmlinux by release name
Message-ID: <20200807061743.TkcOXWDd2%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
