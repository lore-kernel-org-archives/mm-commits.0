Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A030C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 350A061C72
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhGFTK6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231804AbhGFTK5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:10:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 844B061C6D;
        Tue,  6 Jul 2021 19:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598498;
        bh=AvLOa0lbmVKHbhoA0Tt+yYBdWaPapGtYrkdPl+/dM9s=;
        h=Date:From:To:Subject:From;
        b=ep0hp36MaU/gh/BmbFc/f5szn5r3PCzDZz4AS+Wd2G0PMffoP5eHRQhC0shM6xu2a
         B5S38YjdeblObdSkD5vLDjMp4FLQrdS5z0h+wdIyUgQRq62LU5hi4ByKVSD0dSZlR0
         Sm2sjNxhQaVcSHXevwG80lDiWQUVEjWma6N7LFqs=
Date:   Tue, 06 Jul 2021 12:08:18 -0700
From:   akpm@linux-foundation.org
To:     masahiroy@kernel.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, warthog9@kernel.org
Subject:  [merged]
 streamline_configpl-add-softtabstop=4-for-vim-users.patch removed from -mm
 tree
Message-ID: <20210706190818.juSt0S8Py%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: streamline_config.pl: add softtabstop=4 for vim users
has been removed from the -mm tree.  Its filename was
     streamline_configpl-add-softtabstop=4-for-vim-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


