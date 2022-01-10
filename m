Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5FBC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jan 2022 20:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiAJUay (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jan 2022 15:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbiAJUaw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jan 2022 15:30:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5BFC06173F
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 12:30:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DDFDB81785
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 20:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADBAC36AE9;
        Mon, 10 Jan 2022 20:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641846649;
        bh=IqWvErLyb5s5f6QNKKrobPRlg7AIwad/dXOx6A7ggsk=;
        h=Date:From:To:Subject:From;
        b=LG+xW763byEeDIDpsBhJQFUHnvpGJ5eazrTBOQN7bhJ0IX/ZtDZm9aDTJrn0GwSK3
         QsRdPzTdAIr5TnnuHhXCIltLefzkZqJjSdPTYjT5/tgqXy3R/23b3p0Dv/lLEoh8Rb
         b+ve0tqip4898XB5QxoNC3mEs58cuioUn5OKlvws=
Date:   Mon, 10 Jan 2022 12:30:48 -0800
From:   akpm@linux-foundation.org
To:     gpiccoli@igalia.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au
Subject:  + sysctl-documentation-fix-table-format-warning.patch
 added to -mm tree
Message-ID: <20220110203048.uyNlNwDRH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: documentation: fix table format warning
has been added to the -mm tree.  Its filename is
     sysctl-documentation-fix-table-format-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-documentation-fix-table-format-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-documentation-fix-table-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: sysctl: documentation: fix table format warning

Fix malformed table warning in sysctl documentation:
(don't use ':'s)

Documentation/admin-guide/sysctl/kernel.rst:798: WARNING: Malformed table.
Text in column margin in table line 7.

=====  ============================================
bit 0  print all tasks info
bit 1  print system memory info
bit 2  print timer info
bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
bit 4  print ftrace buffer
bit 5: print all printk messages in buffer
bit 6: print all CPUs backtrace (if available in the arch)

Link: https://lkml.kernel.org/r/20220109055635.6999-1-rdunlap@infradead.org
Fixes: 934d51cad60c ("docs: sysctl/kernel: add missing bit to panic_print")
Fixes: addc64999934 ("panic: add option to dump all CPUs backtraces in panic_print")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~sysctl-documentation-fix-table-format-warning
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -795,8 +795,8 @@ bit 1  print system memory info
 bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
-bit 5: print all printk messages in buffer
-bit 6: print all CPUs backtrace (if available in the arch)
+bit 5  print all printk messages in buffer
+bit 6  print all CPUs backtrace (if available in the arch)
 =====  ============================================
 
 So for example to print tasks and memory info on panic, user can::
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-mempolicy-fix-all-kernel-doc-warnings.patch
get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used.patch
sysctl-documentation-fix-table-format-warning.patch

