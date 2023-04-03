Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131C3C76188
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 20:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbjDCUjL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 16:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233424AbjDCUjI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 16:39:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81CF2110
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 13:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7473262AC5
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 20:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E77C433EF;
        Mon,  3 Apr 2023 20:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680554345;
        bh=WuZg7vN2AAAK5fgHRWfl3v3ebfpVv6oJ8IZijHQ3pBY=;
        h=Date:To:From:Subject:From;
        b=gnUB9oY3uS8i1+mfEtVhQDIw8Qv1eFUxjdmxlTv9cqL5tsYvytbm+UdqDUnKQzYQo
         r6kX0mTP5Cne72mGHhfkbcr/GIDbSf8s+JDaMP5+YYKKpvdiePD7oMd306jYLclhsG
         e5wnY4SA/gdsqNe0cbfPqnINHM/JREqQuUZ5b8Ac=
Date:   Mon, 03 Apr 2023 13:39:05 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        lukas.bulwahn@gmail.com, linux@leemhuis.info,
        konstantin@linuxfoundation.org, kai@dev.carbon-project.org,
        joe@perches.com, dwaipayanray1@gmail.com, daniel@ffwll.ch,
        corbet@lwn.net, bagasdotme@gmail.com, apw@canonical.com,
        airlied@gmail.com, matthieu.baerts@tessares.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-use-a-list-of-link-tags.patch added to mm-nonmm-unstable branch
Message-Id: <20230403203905.C7E77C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: use a list of "link" tags
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-use-a-list-of-link-tags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-use-a-list-of-link-tags.patch

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
Subject: checkpatch: use a list of "link" tags
Date: Mon, 03 Apr 2023 18:23:48 +0200

The following commit will allow the use of a similar "link" tag.

Because there is a possibility that other similar tags will be added in
the future and to reduce the number of places where the code will be
modified to allow this new tag, a list with all these "link" tags is now
used.

Two variables are created from it: one to search for such tags and one to
print all tags in a warning message.

Link: https://lkml.kernel.org/r/20230314-doc-checkpatch-closes-tag-v4-3-d26d1fa66f9f@tessares.net
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Joe Perches <joe@perches.com>
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

 scripts/checkpatch.pl |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-use-a-list-of-link-tags
+++ a/scripts/checkpatch.pl
@@ -620,6 +620,22 @@ our $signature_tags = qr{(?xi:
 	Cc:
 )};
 
+our @link_tags = qw(Link);
+
+#Create a search and print patterns for all these strings to be used directly below
+our $link_tags_search = "";
+our $link_tags_print = "";
+foreach my $entry (@link_tags) {
+	if ($link_tags_search ne "") {
+		$link_tags_search .= '|';
+		$link_tags_print .= ' or ';
+	}
+	$entry .= ':';
+	$link_tags_search .= $entry;
+	$link_tags_print .= "'$entry'";
+}
+$link_tags_search = "(?:${link_tags_search})";
+
 our $tracing_logging_tags = qr{(?xi:
 	[=-]*> |
 	<[=-]* |
@@ -3250,8 +3266,8 @@ sub process {
 					# file delta changes
 		      $line =~ /^\s*(?:[\w\.\-\+]*\/)++[\w\.\-\+]+:/ ||
 					# filename then :
-		      $line =~ /^\s*(?:Fixes:|Link:|$signature_tags)/i ||
-					# A Fixes: or Link: line or signature tag line
+		      $line =~ /^\s*(?:Fixes:|$link_tags_search|$signature_tags)/i ||
+					# A Fixes:, link or signature tag line
 		      $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
 			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
@@ -3266,13 +3282,13 @@ sub process {
 
 # Check for odd tags before a URI/URL
 		if ($in_commit_log &&
-		    $line =~ /^\s*(\w+):\s*http/ && $1 ne 'Link') {
+		    $line =~ /^\s*(\w+:)\s*http/ && $1 !~ /^$link_tags_search$/) {
 			if ($1 =~ /^v(?:ersion)?\d+/i) {
 				WARN("COMMIT_LOG_VERSIONING",
 				     "Patch version information should be after the --- line\n" . $herecurr);
 			} else {
 				WARN("COMMIT_LOG_USE_LINK",
-				     "Unknown link reference '$1:', use 'Link:' instead\n" . $herecurr);
+				     "Unknown link reference '$1', use $link_tags_print instead\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from matthieu.baerts@tessares.net are

docs-process-allow-closes-tags-with-links.patch
checkpatch-dont-print-the-next-line-if-not-defined.patch
checkpatch-use-a-list-of-link-tags.patch
checkpatch-allow-closes-tags-with-links.patch
checkpatch-check-for-misuse-of-the-link-tags.patch

