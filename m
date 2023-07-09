Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8EAC001E0
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjGIAaj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjGIAa2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D23E51
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D103660B65
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF75C433C9;
        Sun,  9 Jul 2023 00:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862627;
        bh=9fZhDCGxvVCSK6rIW4WTCpOisBhVU2kcwka5EXF0ifo=;
        h=Date:To:From:Subject:From;
        b=pbwn6T2OXjgRKX8fWWCDRDi0JwkMCXDyj4GiECLSttE+PFoga8znhUqQ2mfldnkDO
         WQXiALZefUnw5dWXd1n5og1S6gxS87QtTkBdMLRm2m7TQaFLGl4uk6ErfPDhVSTuI9
         lqw6yqUy8pkGV+Pcx3fgbW6AYuAeh6W5Q62YZsdY=
Date:   Sat, 08 Jul 2023 17:30:26 -0700
To:     mm-commits@vger.kernel.org, heiko.stuebner@vrull.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-manpage-link.patch removed from -mm tree
Message-Id: <20230709003027.2FF75C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update manpage link
has been removed from the -mm tree.  Its filename was
     mailmap-update-manpage-link.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: mailmap: update manpage link
Date: Tue, 4 Jul 2023 18:39:18 +0200

Patch series "Update .mailmap for my work address and fix manpage".

While updating mailmap for the going-away address, I also found that on
current systems the manpage linked from the header comment changed.

And in fact it looks like the git mailmap feature got its own manpage.


This patch (of 2):

On recent systems the git-shortlog manpage only tells people to
    See gitmailmap(5)

So instead of sending people on a scavenger hunt, put that info into the
header directly.  Though keep the old reference around for older systems.

Link: https://lkml.kernel.org/r/20230704163919.1136784-1-heiko@sntech.de
Link: https://lkml.kernel.org/r/20230704163919.1136784-2-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-manpage-link
+++ a/.mailmap
@@ -5,7 +5,8 @@
 # same person appearing not to be so or badly displayed. Also allows for
 # old email addresses to map to new email addresses.
 #
-# For format details, see "MAPPING AUTHORS" in "man git-shortlog".
+# For format details, see "man gitmailmap" or "MAPPING AUTHORS" in
+# "man git-shortlog" on older systems.
 #
 # Please keep this list dictionary sorted.
 #
_

Patches currently in -mm which might be from heiko.stuebner@vrull.eu are


