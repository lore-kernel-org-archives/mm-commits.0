Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86525C7EE20
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjDRXl1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjDRXlH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:41:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376E5C179
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81D662EE4
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DEDC433EF;
        Tue, 18 Apr 2023 23:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861218;
        bh=eARRDyuMW3wwmgJvPVThs1MdNTjSR1CLBmBoJjY7hZw=;
        h=Date:To:From:Subject:From;
        b=yEqdVeyOaL15uiGJ+iuWvB3WxhJjSznDXhJnVVjZtahqFJB+uqqNXwgakJM9R9d8q
         hu534mpiwLu8GlSlyzPVji1RM/VgaVTtQWxgMSmwrih3nAZecyghWWV5j3BOdESlOC
         aNT0AoUWV++Nw4zfeO4moeDKVuGpzdUPM5nX2Vt0=
Date:   Tue, 18 Apr 2023 16:40:17 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        lukas.bulwahn@gmail.com, linux@leemhuis.info,
        konstantin@linuxfoundation.org, kai@dev.carbon-project.org,
        joe@perches.com, dwaipayanray1@gmail.com, daniel@ffwll.ch,
        corbet@lwn.net, bagasdotme@gmail.com, apw@canonical.com,
        airlied@gmail.com, matthieu.baerts@tessares.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-check-for-misuse-of-the-link-tags.patch removed from -mm tree
Message-Id: <20230418234018.27DEDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: check for misuse of the link tags
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-misuse-of-the-link-tags.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


