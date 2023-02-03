Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BE4C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjBCGwL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjBCGv3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E318CA84
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BC0DB82984
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31754C433EF;
        Fri,  3 Feb 2023 06:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407073;
        bh=PzuWod4XsTlhiDfCUzBcbBzL3cR2hJK0SgPZ0JWvoxk=;
        h=Date:To:From:Subject:From;
        b=HoHyaAkH31fuoocoxjCMNe6waKFwmyCBwikxSYMQELvoQQH2zX80TsXOU3bR5pboU
         Ds0CB461zAnjvK0BEBdlC2jACXmqy7vhghiK7NeNpsw2VaB7nk8MBsTOyWDbR6cgFr
         RHqDAv+SY1hKMAVrZp49Aup9+Bv6fmmueZbNgOuc=
Date:   Thu, 02 Feb 2023 22:51:12 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        linux@leemhuis.info, joe@perches.com, dwaipayanray1@gmail.com,
        apw@canonical.com, kai@dev.carbon-project.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-warn-when-reported-by-is-not-followed-by-link.patch removed from -mm tree
Message-Id: <20230203065113.31754C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: warn when Reported-by: is not followed by Link:
has been removed from the -mm tree.  Its filename was
     checkpatch-warn-when-reported-by-is-not-followed-by-link.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kai Wasserbäch <kai@dev.carbon-project.org>
Subject: checkpatch: warn when Reported-by: is not followed by Link:
Date: Fri, 20 Jan 2023 13:35:19 +0100

Encourage patch authors to link to reports by issuing a warning, if a
Reported-by: is not accompanied by a link to the report.  Those links are
often extremely useful for any code archaeologist that wants to know more
about the backstory of a change than the commit message provides.  That
includes maintainers higher up in the patch-flow hierarchy, which is why
Linus asks developers to add such links [1, 2, 3].  To quote [1]:

> Again, the commit has a link to the patch *submission*, which is
> almost entirely useless. There's no link to the actual problem the
> patch fixes.
>
> [...]
>
> Put another way: I can see that
>
> Reported-by: Zhangfei Gao <zhangfei.gao@foxmail.com>
>
> in the commit, but I don't have a clue what the actual report was, and
> there really isn't enough information in the commit itself, except for
> a fairly handwavy "Device drivers might, for instance, still need to
> flush operations.."
>
> I don't want to know what device drivers _might_ do. I would want to
> have an actual pointer to what they do and where.

Another reason why these links are wanted: the ongoing regression tracking
efforts can only scale with them, as they allow the regression tracking
bot 'regzbot' to automatically connect tracked reports with patches that
are posted or committed to fix tracked regressions.

Link: https://lore.kernel.org/all/CAHk-=wjMmSZzMJ3Xnskdg4+GGz=5p5p+GSYyFBTh0f-DgvdBWg@mail.gmail.com/ [1]
Link: https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/ [2]
Link: https://lore.kernel.org/all/CAHk-=wjxzafG-=J8oT30s7upn4RhBs6TX-uVFZ5rME+L5_DoJA@mail.gmail.com/ [3]
Link: https://lkml.kernel.org/r/bb5dfd55ea2026303ab2296f4a6df3da7dd64006.1674217480.git.linux@leemhuis.info
Signed-off-by: Kai Wasserbäch <kai@dev.carbon-project.org>
Co-developed-by: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/checkpatch.pl~checkpatch-warn-when-reported-by-is-not-followed-by-link
+++ a/scripts/checkpatch.pl
@@ -3157,8 +3157,20 @@ sub process {
 					     "Co-developed-by and Signed-off-by: name/email do not match \n" . "$here\n" . $rawline . "\n" .$rawlines[$linenr]);
 				}
 			}
+
+# check if Reported-by: is followed by a Link:
+			if ($sign_off =~ /^reported(?:|-and-tested)-by:$/i) {
+				if (!defined $lines[$linenr]) {
+					WARN("BAD_REPORTED_BY_LINK",
+					     "Reported-by: should be immediately followed by Link: to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
+				} elsif ($rawlines[$linenr] !~ m{^link:\s*https?://}i) {
+					WARN("BAD_REPORTED_BY_LINK",
+					     "Reported-by: should be immediately followed by Link: with a URL to the report\n" . $herecurr . $rawlines[$linenr] . "\n");
+				}
+			}
 		}
 
+
 # Check Fixes: styles is correct
 		if (!$in_header_lines &&
 		    $line =~ /^\s*fixes:?\s*(?:commit\s*)?[0-9a-f]{5,}\b/i) {
_

Patches currently in -mm which might be from kai@dev.carbon-project.org are


