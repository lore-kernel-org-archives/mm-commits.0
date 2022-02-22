Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692C0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 20:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiBVUNP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 15:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiBVUNO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 15:13:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F57DC7924
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 12:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A6E7616B0
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 20:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFC8C340E8;
        Tue, 22 Feb 2022 20:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645560767;
        bh=Ppd4SxAKh91TBM3UnHrXQ5P6L5VxSY4zw4jq1uqWyG0=;
        h=Date:To:From:Subject:From;
        b=ihKuxlh63CEAt5P8IKWjeXCCpFah6Ea/4XO5I3ibesDLuZ5AbY3ibc0AxcLQeU5m5
         zq8LrJsLdOUiYCeR7fIO0wNxvnva70AkracUhvk0Wy84FD/Ht5kqo4wwBpotBHa9x3
         bwnZMQV2T9BK+LZznX4/ibHqFn1KE4l5AIyLJxYw=
Date:   Tue, 22 Feb 2022 12:12:46 -0800
To:     mm-commits@vger.kernel.org, rkovhaev@gmail.com,
        masahiroy@kernel.org, gregkh@linuxfoundation.org, corbet@lwn.net,
        xujialu@vimux.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] scripts-tagssh-parse-dtstmp-for-compiled-sources.patch removed from -mm tree
Message-Id: <20220222201247.4FFC8C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: parse *.dts.tmp for compiled sources
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-parse-dtstmp-for-compiled-sources.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Jialu Xu <xujialu@vimux.org>
Subject: scripts/tags.sh: parse *.dts.tmp for compiled sources

There are files listed in *.dts.tmp, parse them as *.cmd for compiled
sources.

Link: https://lkml.kernel.org/r/20220221084614.1682022-1-xujialu@vimux.org
Signed-off-by: Jialu Xu <xujialu@vimux.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rustam Kovhaev <rkovhaev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/tags.sh~scripts-tagssh-parse-dtstmp-for-compiled-sources
+++ a/scripts/tags.sh
@@ -97,8 +97,8 @@ all_compiled_sources()
 {
 	realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
 		include/generated/autoconf.h $(find $ignore -name "*.cmd" -exec \
-		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
-		awk '!a[$0]++') | sort -u
+		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ | awk '!a[$0]++') \
+		$(find -name "*.dts.tmp" -exec grep -Poh '(?(?=^# \d+ "\K).*(?="))' {} \+) | sort -u
 }
 
 all_target_sources()
_

Patches currently in -mm which might be from xujialu@vimux.org are


