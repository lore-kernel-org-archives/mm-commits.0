Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AC5C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 02:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239208AbiBVC2X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:28:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiBVC2W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 21:28:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA3A25C5F
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 18:27:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 034B3B817F8
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 02:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D4CC340E9;
        Tue, 22 Feb 2022 02:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645496875;
        bh=NR/aHT2M3lClwC2tI7GAQIW+lZIP8Y6GwJ3ZQCmT0e0=;
        h=Date:To:From:Subject:From;
        b=FrNOElkCP/SMimc3aobgZzPtchY7Vmy9Bjj4sq5QZSNk5U4xzxkKej4mXCChIJRLu
         AbRKWcp4a0a4t53V866oxlUZvpbtP7Z50JuvR/mX00dm3K9GHrd/WmiQvhA+Z9qU1C
         jDAvj59OpaV0/R/thEWxQFPo0NiOUCKU5RwO1pys=
Date:   Mon, 21 Feb 2022 18:27:55 -0800
To:     mm-commits@vger.kernel.org, rkovhaev@gmail.com,
        masahiroy@kernel.org, gregkh@linuxfoundation.org, corbet@lwn.net,
        xujialu@vimux.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-tagssh-parse-dtstmp-for-compiled-sources.patch added to -mm tree
Message-Id: <20220222022755.96D4CC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: parse *.dts.tmp for compiled sources
has been added to the -mm tree.  Its filename is
     scripts-tagssh-parse-dtstmp-for-compiled-sources.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-parse-dtstmp-for-compiled-sources.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-parse-dtstmp-for-compiled-sources.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-tagssh-parse-dtstmp-for-compiled-sources.patch

