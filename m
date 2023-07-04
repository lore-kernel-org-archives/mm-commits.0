Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F0EEB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 17:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjGDRJW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 13:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjGDRJW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 13:09:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FBA10D7
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 10:09:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D681561316
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 17:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36020C433C9;
        Tue,  4 Jul 2023 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688490559;
        bh=bUE8ujfflK/7dzp+/S7yjgTY/3w4q9JrlxVQ2UUdw8s=;
        h=Date:To:From:Subject:From;
        b=OeAPAPOMdl1sSAjZHJJ3NNazYQXaM0keA8J2iboQQpumR/iq9gvQSlNVdQ+xYT/1O
         lahjN5N9VRhNPp3sWI1Pvk4HNYcslH6yMFnEPBYYESOgyJ/V0MgvcZo9RKd8h7kBOt
         acUY2xR8HmBIxNjS40Z3TrVSUgANRJPEmhqSew+U=
Date:   Tue, 04 Jul 2023 10:09:18 -0700
To:     mm-commits@vger.kernel.org, heiko.stuebner@vrull.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-manpage-link.patch added to mm-hotfixes-unstable branch
Message-Id: <20230704170919.36020C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update manpage link
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-manpage-link.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-manpage-link.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mailmap-update-manpage-link.patch
mailmap-add-entries-for-heiko-stuebner.patch

