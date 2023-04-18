Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF806C77B7E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjDRXkQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjDRXkA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:40:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D32A1386C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0B4F628C2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222F9C433EF;
        Tue, 18 Apr 2023 23:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861037;
        bh=KEBOWR6iqAnB+2vEmY546zj+FwWt7kV4mij5c17ZTz0=;
        h=Date:To:From:Subject:From;
        b=yrivE/MdenVFeOeeq24ycmZ/1lrkEDEKqFzIMzLW3LrsQ6vQ4XuPCI/AQr9KEjaY4
         VQzqjfzpU/UkugfXyPTypUTJGNTmKePZT0y4QqjV5hfyx+kiZ6EqWIRkIUTO76ANcn
         6XazScgMzBWSMdrogDoRZGu7SXaRErgUcpyvt5LM=
Date:   Tue, 18 Apr 2023 16:37:16 -0700
To:     mm-commits@vger.kernel.org, kieran.bingham@linaro.org,
        kbingham@kernel.org, jan.kiszka@siemens.com, f.fainelli@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] scripts-gdb-add-a-radix-tree-parser-v2.patch removed from -mm tree
Message-Id: <20230418233717.222F9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts-gdb-add-a-radix-tree-parser-v2
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-a-radix-tree-parser-v2.patch

This patch was dropped because it was folded into scripts-gdb-add-a-radix-tree-parser.patch

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

scripts-gdb-add-a-radix-tree-parser.patch
scripts-gdb-raise-error-with-reduced-debugging-information.patch
scripts-gdb-print-interrupts.patch

