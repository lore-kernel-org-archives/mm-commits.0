Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EDDC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF1F9207DE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597866794;
	bh=mfpLkuT+Q1tdkJlWfBZ6+2jSUef2fZ0ewhsgIrvMrEc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=J14EyHxYyq/UtWFd0a/gKENnl1Y0WYsa53I7QLVfurSfr8m4sNhUHlBntwKNTXIoH
	 8jXYyQ3thctGVifEOlLBXYPEw4l8kw1YQ70BpiG66m94GYFBgsnbRMjn/Q9Oy/Z5ck
	 jbd5cX92mIfYoArUWVoTEiF6/0RPTVssX1OkIiIk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHSTxO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgHSTxN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:53:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFCBC207DA;
        Wed, 19 Aug 2020 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597866792;
        bh=mfpLkuT+Q1tdkJlWfBZ6+2jSUef2fZ0ewhsgIrvMrEc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qBBIVmGF0iD3C2P9k6IhHU8GfSfRLobiyGjiXkTA015O2Jehh58xppUHSwCQEQ3dG
         aFtiRYZbn6JWu99gtPtVZSZGU0YZGXzJ0P4cZAYR7/ZIqZBGqJwdVNZMwWikXpho7C
         UPYqPRPVArnj+nL7iv4VmYvvrM3xj+8BbylKib2E=
Date:   Wed, 19 Aug 2020 12:53:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     corbet@lwn.net, gregkh@linuxfoundation.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, rkovhaev@gmail.com, xujialu@vimux.org
Subject:  +
 scripts-tagssh-exclude-tools-directory-from-tags-generation.patch added to
 -mm tree
Message-ID: <20200819195311.WiLrkJugU%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: exclude tools directory from tags generation
has been added to the -mm tree.  Its filename is
     scripts-tagssh-exclude-tools-directory-from-tags-generation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-exclude-tools-directory-from-tags-generation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-exclude-tools-directory-from-tags-generation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rustam Kovhaev <rkovhaev@gmail.com>
Subject: scripts/tags.sh: exclude tools directory from tags generation

When COMPILED_SOURCE is set, running 'make ARCH=x86_64 COMPILED_SOURCE=1
cscope tags' in KBUILD_OUTPUT directory produces lots of "No such file or
directory" warnings:

...
realpath: sigchain.h: No such file or directory
realpath: orc_gen.c: No such file or directory
realpath: objtool.c: No such file or directory
...

Let's exclude tools directory from tags generation

Link: https://lkml.kernel.org/r/20200810153650.1822316-1-rkovhaev@gmail.com
Link: https://lore.kernel.org/lkml/20200809210056.GA1344537@thinkpad
Fixes: 4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely")
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jialu Xu <xujialu@vimux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/scripts/tags.sh~scripts-tagssh-exclude-tools-directory-from-tags-generation
+++ a/scripts/tags.sh
@@ -26,7 +26,11 @@ else
 fi
 
 # ignore userspace tools
-ignore="$ignore ( -path ${tree}tools ) -prune -o"
+if [ -n "$COMPILED_SOURCE" ]; then
+	ignore="$ignore ( -path ./tools ) -prune -o"
+else
+	ignore="$ignore ( -path ${tree}tools ) -prune -o"
+fi
 
 # Detect if ALLSOURCE_ARCHS is set. If not, we assume SRCARCH
 if [ "${ALLSOURCE_ARCHS}" = "" ]; then
@@ -92,7 +96,7 @@ all_sources()
 all_compiled_sources()
 {
 	realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
-		include/generated/autoconf.h $(find -name "*.cmd" -exec \
+		include/generated/autoconf.h $(find $ignore -name "*.cmd" -exec \
 		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
 		awk '!a[$0]++') | sort -u
 }
_

Patches currently in -mm which might be from rkovhaev@gmail.com are

scripts-tagssh-exclude-tools-directory-from-tags-generation.patch

