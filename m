Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D89C4321E
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiKHX70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiKHX6d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B968513D2C
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54BC2617C6
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15BCC433C1;
        Tue,  8 Nov 2022 23:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951910;
        bh=ZGRLAxT9fKfND/2Kj2Gga7Dl9PkrM1I0vE7BaJSRyZY=;
        h=Date:To:From:Subject:From;
        b=c0feYzmVvBHf2LbDM47I7TPZh0coL2P6znPfpKeedsrgZP9o3zrghbG28UguD6LRt
         IbRd6qDyySFjqowdrOHrc5x+xjplySykuGOMda/pXnIgSRT1YdoBGE240E3aUQhA4h
         chnI5ENn/4aJywxvJVVAixAXs8ACOqmhwEx47HpE=
Date:   Tue, 08 Nov 2022 15:58:30 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, bagasdotme@gmail.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-kmsan-fix-formatting-of-example-report.patch removed from -mm tree
Message-Id: <20221108235830.B15BCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: docs: kmsan: fix formatting of "Example report"
has been removed from the -mm tree.  Its filename was
     docs-kmsan-fix-formatting-of-example-report.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: docs: kmsan: fix formatting of "Example report"
Date: Mon, 7 Nov 2022 15:22:55 +0100

Add a blank line to make the sentence before the list render as a separate
paragraph, not a definition.

Link: https://lkml.kernel.org/r/20221107142255.4038811-1-glider@google.com
Fixes: 93858ae70cf4 ("kmsan: add ReST documentation")
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmsan.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/dev-tools/kmsan.rst~docs-kmsan-fix-formatting-of-example-report
+++ a/Documentation/dev-tools/kmsan.rst
@@ -67,6 +67,7 @@ uninitialized in the local variable, as
 copied to another memory location before use.
 
 A use of uninitialized value ``v`` is reported by KMSAN in the following cases:
+
  - in a condition, e.g. ``if (v) { ... }``;
  - in an indexing or pointer dereferencing, e.g. ``array[v]`` or ``*v``;
  - when it is copied to userspace or hardware, e.g. ``copy_to_user(..., &v, ...)``;
_

Patches currently in -mm which might be from glider@google.com are


