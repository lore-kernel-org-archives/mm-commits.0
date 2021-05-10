Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F322C433B4
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 05:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE33261432
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 05:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhEJF0L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 01:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhEJF0L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 01:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE62E61430;
        Mon, 10 May 2021 05:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620624307;
        bh=0TipWS/Cw/7gbP90Zylu6V5nRXr83mQ1rdVy1iFo5Ok=;
        h=Date:From:To:Subject:From;
        b=r0Ir5h1dryz2QX67374cwynQtgQAmggdbK/y1ge+skidjZ6xGSLSvxpZgCebPrziw
         h1/W23xCbI46+FhsJiNSU5s762X+8spfs8rSPM0DatxhJ6IuzJapdwWkgQUj0FJpU1
         v5Thia4aOQTzXJzOeFK9NTmIazGXLxG6PNXgYLfc=
Date:   Sun, 09 May 2021 22:25:06 -0700
From:   akpm@linux-foundation.org
To:     masahiroy@kernel.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, warthog9@kernel.org
Subject:  +
 streamline_configpl-add-softtabstop=4-for-vim-users.patch added to -mm tree
Message-ID: <20210510052506.Dt6gY4Y27%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: streamline_config.pl: add softtabstop=4 for vim users
has been added to the -mm tree.  Its filename is
     streamline_configpl-add-softtabstop=4-for-vim-users.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/streamline_configpl-add-softtabstop%3D4-for-vim-users.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/streamline_configpl-add-softtabstop%3D4-for-vim-users.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: streamline_config.pl: add softtabstop=4 for vim users

The tab stop for Perl files is by default (at least in emacs) to be 4
spaces, where a tab is used for all 8 spaces.  Add a local variable
comment to make vim do the same by default, and this will help keep the
file consistent in the future when others edit it via vim and not emacs.

Link: https://lkml.kernel.org/r/20210322214032.293992979@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: "John (Warthog9) Hawley" <warthog9@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/streamline_config.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/kconfig/streamline_config.pl~streamline_configpl-add-softtabstop=4-for-vim-users
+++ a/scripts/kconfig/streamline_config.pl
@@ -702,3 +702,5 @@ foreach my $module (keys(%modules)) {
 	print STDERR "\n";
     }
 }
+
+# vim: softtabstop=4
_

Patches currently in -mm which might be from rostedt@goodmis.org are

streamline_configpl-make-spacing-consistent.patch
streamline_configpl-add-softtabstop=4-for-vim-users.patch

