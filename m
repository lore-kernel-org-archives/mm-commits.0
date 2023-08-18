Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCA6EE498D
	for <mm-commits@archiver.kernel.org>; Fri, 18 Aug 2023 18:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379440AbjHRSby (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Aug 2023 14:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379448AbjHRSbh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2023 14:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E66BF
        for <mm-commits@vger.kernel.org>; Fri, 18 Aug 2023 11:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96267619D7
        for <mm-commits@vger.kernel.org>; Fri, 18 Aug 2023 18:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA486C433C8;
        Fri, 18 Aug 2023 18:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692383495;
        bh=sjb53glh5OuwOKTheUSAe0M18oIqoee76CeFQbbWND0=;
        h=Date:To:From:Subject:From;
        b=EABy8Z8tB/6FZnIxwfD3YO76+2vpS6dGNonsyqHmkkyR6y1C23WsfgEKF9GXEpNOm
         scPwMUKDonrMekwxJdzIepNZIHA7nDX2h+L/4FHCBmoqxhSTAMNXwvcirbKpZPJ7jx
         Fl8BQxznkeitwiPbheGM2TFWzReSlKANakQNjEDs=
Date:   Fri, 18 Aug 2023 11:31:34 -0700
To:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kstrtox-consistently-use-_tolower.patch added to mm-nonmm-unstable branch
Message-Id: <20230818183134.EA486C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kstrtox: consistently use _tolower()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kstrtox-consistently-use-_tolower.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kstrtox-consistently-use-_tolower.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kstrtox: consistently use _tolower()
Date: Thu, 17 Aug 2023 17:59:19 +0300

We already use _tolower() in other places, so convert the one which open
codes it.

Link: https://lkml.kernel.org/r/20230817145919.543251-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kstrtox.c~kstrtox-consistently-use-_tolower
+++ a/lib/kstrtox.c
@@ -59,7 +59,7 @@ unsigned int _parse_integer_limit(const
 	rv = 0;
 	while (max_chars--) {
 		unsigned int c = *s;
-		unsigned int lc = c | 0x20; /* don't tolower() this line */
+		unsigned int lc = _tolower(c);
 		unsigned int val;
 
 		if ('0' <= c && c <= '9')
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-vsprintf-split-out-sprintf-and-friends.patch
lib-vsprintf-declare-no_hash_pointers-in-sprintfh.patch
kstrtox-consistently-use-_tolower.patch

