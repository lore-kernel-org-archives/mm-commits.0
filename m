Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09751C4160E
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C514064F4C
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbhCDA7Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1452108AbhCDAir (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:38:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA7764E28;
        Thu,  4 Mar 2021 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614818286;
        bh=vQxN5JJQ2GNiKC6kKtUtO6Jh20tc7NKQY+vz1fBjHD0=;
        h=Date:From:To:Subject:From;
        b=uNmorIV3lT+pxc5XyHrxRLT1tfs2CuKgC0h58DADTsHhimXOnQtk3SBU1EB5gOHvR
         takimiXXOu4fLSTYW7c0LjRyPBC27J+e8RATrwWi7D3BBA5L8b//wp6WkJpuv0mABv
         KI8qcEjCIK0CJevTv7qEyrBZnZNgeqFuW+sxbnJk=
Date:   Wed, 03 Mar 2021 16:38:06 -0800
From:   akpm@linux-foundation.org
To:     jan.kiszka@siemens.com, johannes.berg@intel.com,
        kbingham@kernel.org, mm-commits@vger.kernel.org
Subject:  + gdb-lx-symbols-store-the-abspath.patch added to -mm
 tree
Message-ID: <20210304003806.V91rCoxcE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gdb: lx-symbols: store the abspath()
has been added to the -mm tree.  Its filename is
     gdb-lx-symbols-store-the-abspath.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gdb-lx-symbols-store-the-abspath.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gdb-lx-symbols-store-the-abspath.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: gdb: lx-symbols: store the abspath()

If we store the relative path, the user might later cd to a different
directory, and that would break the automatic symbol resolving that
happens when a module is loaded into the target kernel.  Fix this by
storing the abspath() of each path given, just like we already do for the
cwd (os.getcwd() is absolute.)

Link: https://lkml.kernel.org/r/20201217091747.bf4332cf2b35.I10ebbdb7e9b80ab1a5cddebf53d073be8232d656@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~gdb-lx-symbols-store-the-abspath
+++ a/scripts/gdb/linux/symbols.py
@@ -164,7 +164,8 @@ lx-symbols command."""
             saved_state['breakpoint'].enabled = saved_state['enabled']
 
     def invoke(self, arg, from_tty):
-        self.module_paths = [os.path.expanduser(p) for p in arg.split()]
+        self.module_paths = [os.path.abspath(os.path.expanduser(p))
+                             for p in arg.split()]
         self.module_paths.append(os.getcwd())
 
         # enforce update
_

Patches currently in -mm which might be from johannes.berg@intel.com are

gdb-lx-symbols-store-the-abspath.patch

