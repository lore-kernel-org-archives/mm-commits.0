Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B85AC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F8E61424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhEHWy6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWy5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89E3F61402;
        Sat,  8 May 2021 22:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514435;
        bh=Aha95Ijrjh51ZBpQeKRrOwbCmRT2KRM7VUt/NLJjEH8=;
        h=Date:From:To:Subject:From;
        b=MFcu5jIixJnpPESRr2NA3S5Q5Izt/TuDbM+vtmuUaYYKl7boPGnlihW2ZQHNpVRdS
         EH03RCDWeCzGuuPPNYhArXzl8eEGN1YVGxDHT96sPbJjq954gaPG0W0T6UBTBoisU2
         KcDbxH5Aotu04VQfAQlATZixinY/zlYyaun9ONbc=
Date:   Sat, 08 May 2021 15:53:55 -0700
From:   akpm@linux-foundation.org
To:     jan.kiszka@siemens.com, johannes.berg@intel.com,
        kbingham@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged] gdb-lx-symbols-store-the-abspath.patch removed
 from -mm tree
Message-ID: <20210508225355.X-AQlREvi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gdb: lx-symbols: store the abspath()
has been removed from the -mm tree.  Its filename was
     gdb-lx-symbols-store-the-abspath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


