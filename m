Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E30FC77B6C
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 22:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbjDFWsS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 18:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236891AbjDFWsR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 18:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FDC2108
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 15:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E9D64CED
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 22:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FBAC433EF;
        Thu,  6 Apr 2023 22:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680821295;
        bh=Lm/2kSYKSs/3+byOfznOKv/A5ZkuRFQsaeJc1VMlmz8=;
        h=Date:To:From:Subject:From;
        b=XrD6Cr+OBER5ku5T9y1FR0ucBGLkZZ6jCBhle2jPiiRHZJ7zTOwh32OmyElDAbkjn
         PHSrmltE0WEa7bLJTpjAU1cSUszfSwLy3+vSM6nj2Nn7F+vatfxJ2t443GbexL/PjQ
         1kzO0svSV6xmAderUuvh4lKg47V2FSdQBZzp7Umg=
Date:   Thu, 06 Apr 2023 15:48:14 -0700
To:     mm-commits@vger.kernel.org, kieran.bingham@linaro.org,
        kbingham@kernel.org, jan.kiszka@siemens.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-a-radix-tree-parser-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20230406224815.09FBAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-gdb-add-a-radix-tree-parser-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-a-radix-tree-parser-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-a-radix-tree-parser-v2.patch

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
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: scripts-gdb-add-a-radix-tree-parser-v2
Date: Wed, 5 Apr 2023 15:27:43 -0700

guard against a NULL node in the while loop

Link: https://lkml.kernel.org/r/20230405222743.1191674-1-f.fainelli@gmail.com
Signed-off-by: Kieran Bingham <kieran.bingham@linaro.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/radixtree.py |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/gdb/linux/radixtree.py~scripts-gdb-add-a-radix-tree-parser-v2
+++ a/scripts/gdb/linux/radixtree.py
@@ -58,6 +58,9 @@ def lookup(root, index):
         offset = (index >> node['shift']) & constants.LX_RADIX_TREE_MAP_MASK
         slot = node['slots'][offset]
 
+        if slot == 0:
+            return None
+
         node = slot.cast(node.type.pointer()).dereference()
         if node == 0:
             return None
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

scripts-gdb-add-a-radix-tree-parser-v2.patch

