Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CCCC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50EF261D03
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhF2CgP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2CgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B5561CCA;
        Tue, 29 Jun 2021 02:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934027;
        bh=9nzyH5Oxbad/MzNfKOxt/uRRiO1ogz7zT2Bddh9B1iI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OQ55sWtIjbYAND4h6WS3BoEBJIo8QYa2KthoiwH9iXotSHUfGwor50vdYMZ/KtP+T
         mHvhIUdhNV4bQ1fAcjqwj5rgfxLOXWhSxG0Kau2rOxqPBPkEpthzTZVQj5pHmrhBb3
         2QkeKYqXJNhUI0fyFY4FQEKceq5mGjJm7KUXw5KU=
Date:   Mon, 28 Jun 2021 19:33:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        masahiroy@kernel.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        warthog9@kernel.org
Subject:  [patch 009/192] streamline_config.pl: add softtabstop=4
 for vim users
Message-ID: <20210629023347.Twj8YzaH6%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
