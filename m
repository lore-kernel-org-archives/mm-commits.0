Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3860BC3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 03:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjAFDMD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 22:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjAFDLz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 22:11:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C871460859
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 19:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63ECC61583
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 03:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87E8C433D2;
        Fri,  6 Jan 2023 03:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672974713;
        bh=wSkN5vXd7qLzED55gf7J1iUYlsXYjaCmlW1+qVD/U94=;
        h=Date:To:From:Subject:From;
        b=WeCYSsYSY8XdfexWZpiCPJ5GjpPT6xWXTuEMFONKwaNLt4BVYPKcJUZO9pse6V8bk
         jeQNEpLWVudVWhJk7jIEBryD6ibs3WcDTFqpp75GCdeSHNEaXF/eCRVso7bBpAq0yz
         w5xF4ktDo81xLBQ3MpUWOINZgCx2+/Sg6oqBDu3I=
Date:   Thu, 05 Jan 2023 19:11:52 -0800
To:     mm-commits@vger.kernel.org, ncardwell@google.com,
        edumazet@google.com, davem@davemloft.net, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-win_minmax-use-notation-for-regular-comments.patch added to mm-hotfixes-unstable branch
Message-Id: <20230106031153.B87E8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/win_minmax: use /afs /bin /boot /dev /etc /home /lib /lib64 /lost+found /media /mnt /opt /proc /root /run /sbin /srv /sys /tmp /usr /var notation for regular comments
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-win_minmax-use-notation-for-regular-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-win_minmax-use-notation-for-regular-comments.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/win_minmax: use /afs /bin /boot /dev /etc /home /lib /lib64 /lost+found /media /mnt /opt /proc /root /run /sbin /srv /sys /tmp /usr /var notation for regular comments
Date: Mon, 2 Jan 2023 13:16:14 -0800

Don't use kernel-doc "/**" notation for non-kernel-doc comments.
Prevents a kernel-doc warning:

lib/win_minmax.c:31: warning: expecting prototype for lib/minmax.c(). Prototype was for minmax_subwin_update() instead

Link: https://lkml.kernel.org/r/20230102211614.26343-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/win_minmax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/win_minmax.c~lib-win_minmax-use-notation-for-regular-comments
+++ a/lib/win_minmax.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * lib/minmax.c: windowed min/max tracker
  *
  * Kathleen Nichols' algorithm for tracking the minimum (or maximum)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-win_minmax-use-notation-for-regular-comments.patch

