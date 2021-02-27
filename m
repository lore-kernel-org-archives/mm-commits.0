Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31EAC433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B342964F13
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhB0Cdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230194AbhB0Cde (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:33:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 768E964F2F;
        Sat, 27 Feb 2021 02:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393169;
        bh=M+Vr2vB2iMLqvIbSkyXYpi5T5GLTh0yLufkJIOdJisE=;
        h=Date:From:To:Subject:From;
        b=OPJSRtutyYA/rtxO6sYO/W7dFW0TaKe6SebLY7oMuup+zRNX9YICDvnbxuoTpCeNQ
         WlEopqCp5TxWwkPCbGWPEaAE60TNrQvasmP85OoqCLan5XA18bdkBrwRQx+8JKb8H/
         q5S9U66KlTNjwI8/xZs01IoPBj+Tw92yYMwexKbw=
Date:   Fri, 26 Feb 2021 18:32:49 -0800
From:   akpm@linux-foundation.org
To:     jan.kiszka@siemens.com, kbingham@kernel.org,
        mm-commits@vger.kernel.org, prekageo@amazon.com
Subject:  [merged] scripts-gdb-fix-list_for_each.patch removed from
 -mm tree
Message-ID: <20210227023249.TkWyrHdtM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix list_for_each
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: George Prekas <prekageo@amazon.com>
Subject: scripts/gdb: fix list_for_each

If the list is uninitialized (next pointer is NULL), list_for_each gets
stuck in an infinite loop. Print a message and treat list as empty.

Link: https://lkml.kernel.org/r/4ae23bb1-c333-f669-da2d-fa35c4f49018@amazon.com
Signed-off-by: George Prekas <prekageo@amazon.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/lists.py |    5 +++++
 1 file changed, 5 insertions(+)

--- a/scripts/gdb/linux/lists.py~scripts-gdb-fix-list_for_each
+++ a/scripts/gdb/linux/lists.py
@@ -27,6 +27,11 @@ def list_for_each(head):
         raise TypeError("Must be struct list_head not {}"
                            .format(head.type))
 
+    if head['next'] == 0:
+        gdb.write("list_for_each: Uninitialized list '{}' treated as empty\n"
+                     .format(head.address))
+        return
+
     node = head['next'].dereference()
     while node.address != head.address:
         yield node.address
_

Patches currently in -mm which might be from prekageo@amazon.com are


