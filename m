Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E273C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbiCVVuv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbiCVVup (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A77F51E43
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07A556149C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAA9C340EE;
        Tue, 22 Mar 2022 21:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985756;
        bh=ZPovejT+mS4ShXN/nfO853TOrgfFMjd8KIsrmY37H88=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=VQ+FPq88EYuoYlE4CD6Gb4EagG+YE9N176cXUfB1eWQrJJP+2z/Pk+JqnUqov6ReR
         nFIt7jrfF/WlWPA1hPlnITFGn8WxXhmrkAlOHGVuEX/xKsXCXfnDof9eS0CutGwUUr
         G5YEZswwJevnFuBv6345j6oMKgVjI4SC2PMdAmEg=
Date:   Tue, 22 Mar 2022 14:49:15 -0700
To:     corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 212/227] Docs/vm/damon/design: update DAMON-Idle Page Tracking interference handling
Message-Id: <20220322214916.5BAA9C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: Docs/vm/damon/design: update DAMON-Idle Page Tracking interference handling

In DAMON's early development stage before it be merged in the mainline, it
was first designed to work exclusively with Idle page tracking to avoid
any interference between each other.  Later, but still before be merged in
the mainline, because Idle page tracking is fully under the control of
sysadmins, we made the resolving of conflict as the responsibility of
sysadmins.  The document is not updated for the change, though.  This
commit updates the document for that.

Link: https://lkml.kernel.org/r/20220222170100.17068-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/damon/design.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/vm/damon/design.rst~docs-vm-damon-design-update-damon-idle-page-tracking-interference-handling
+++ a/Documentation/vm/damon/design.rst
@@ -84,9 +84,10 @@ table having a mapping to the address.
 and clear the bit(s) for next sampling target address and checks whether the
 bit(s) set again after one sampling period.  This could disturb other kernel
 subsystems using the Accessed bits, namely Idle page tracking and the reclaim
-logic.  To avoid such disturbances, DAMON makes it mutually exclusive with Idle
-page tracking and uses ``PG_idle`` and ``PG_young`` page flags to solve the
-conflict with the reclaim logic, as Idle page tracking does.
+logic.  DAMON does nothing to avoid disturbing Idle page tracking, so handling
+the interference is the responsibility of sysadmins.  However, it solves the
+conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
+as Idle page tracking does.
 
 
 Address Space Independent Core Mechanisms
_
