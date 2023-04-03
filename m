Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A26C76188
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 20:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjDCUjQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjDCUjL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 16:39:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7FC139
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 13:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ACE061E62
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 20:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84263C433EF;
        Mon,  3 Apr 2023 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680554349;
        bh=JuxusXYfIQf6ruc3KGjknkqaI9AQohDbd/tod5s9BZ0=;
        h=Date:To:From:Subject:From;
        b=K1edrFKse+l5NyQXEmh/QQ4HOLvlASyVZwz8CSUAWopVW1Fp4UD8OqKqWB/mObPlm
         Uob9qL2dle3vp1uLUBIogbOyt8mZKQqDIzq7j9XYAXR0PQ8g+fzkAykiMhfpqgjT7r
         Td9JeBXJro/5c8mlY5rA1Fw7RPANuqZUgZYVgv1M=
Date:   Mon, 03 Apr 2023 13:39:08 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        lukas.bulwahn@gmail.com, linux@leemhuis.info,
        konstantin@linuxfoundation.org, kai@dev.carbon-project.org,
        joe@perches.com, dwaipayanray1@gmail.com, daniel@ffwll.ch,
        corbet@lwn.net, bagasdotme@gmail.com, apw@canonical.com,
        airlied@gmail.com, matthieu.baerts@tessares.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-check-for-misuse-of-the-link-tags.patch added to mm-nonmm-unstable branch
Message-Id: <20230403203909.84263C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check for misuse of the link tags
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-check-for-misuse-of-the-link-tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-check-for-misuse-of-the-link-tags.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: checkpatch: check for misuse of the link tags
Date: Mon, 03 Apr 2023 18:23:50 +0200

"Link:" and "Closes:" tags have to be used with public URLs.

It is difficult to make sure the link is public but at least we can verify
the tag is followed by 'http(s)://'.

With that, we avoid such a tag that is not allowed [1]:

  Closes: <number>

Now that we check the "link" tags are followed by a URL, we can relax the
check linked to "Reported-by being followed by a link tag" to only verify
if a "link" tag is present after the "Reported-by" one.

Link: https://lore.kernel.org/linux-doc/CAHk-=wh0v1EeDV3v8TzK81nDC40=XuTdY2MCr0xy3m3FiBV3+Q@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20230314-doc-checkpatch-closes-tag-v4-5-d26d1fa66f9f@tessares.net
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kai Wasserbäch <kai@dev.carbon-project.org>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-check-for-misuse-of-the-link-tags
+++ a/scripts/checkpatch.pl
@@ -3179,7 +3179,7 @@ sub process {
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_REPORTED_BY_LINK",
 					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . "\n");
-				} elsif ($rawlines[$linenr] !~ m{^closes:\s*https?://}i) {
+				} elsif ($rawlines[$linenr] !~ /^closes:\s*/i) {
 					WARN("BAD_REPORTED_BY_LINK",
 					     "Reported-by: should be immediately followed by Closes: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
 				}
@@ -3292,6 +3292,17 @@ sub process {
 			}
 		}
 
+# Check for misuse of the link tags
+		if ($in_commit_log &&
+		    $line =~ /^\s*(\w+:)\s*(\S+)/) {
+			my $tag = $1;
+			my $value = $2;
+			if ($tag =~ /^$link_tags_search$/ && $value !~ m{^https?://}) {
+				WARN("COMMIT_LOG_WRONG_LINK",
+				     "'$tag' should be followed by a public http(s) link\n" . $herecurr);
+			}
+		}
+
 # Check for lines starting with a #
 		if ($in_commit_log && $line =~ /^#/) {
 			if (WARN("COMMIT_COMMENT_SYMBOL",
_

Patches currently in -mm which might be from matthieu.baerts@tessares.net are

docs-process-allow-closes-tags-with-links.patch
checkpatch-dont-print-the-next-line-if-not-defined.patch
checkpatch-use-a-list-of-link-tags.patch
checkpatch-allow-closes-tags-with-links.patch
checkpatch-check-for-misuse-of-the-link-tags.patch

