Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71016C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 20:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbjHKUlP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 16:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjHKUlO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 16:41:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7B8FD
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 13:41:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E41C0645C8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 20:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47341C433C8;
        Fri, 11 Aug 2023 20:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691786473;
        bh=CLgCoqT3HP4lm6UmXB11Kne+VS8BYTraYY19j3zKTUM=;
        h=Date:To:From:Subject:From;
        b=WvE82RK9vTb8w5tTz0aA/KHcV8wnys8dVUx87H8ytUjJntwEr5IhVd/Mc2YoHcDZF
         efq1VgvmmS/0LmrGx5U7srsRGQdL2zVnamr4mplrAwjlYYfB1MT57Pb6OPJMU9D7+w
         CrWa53cCTMyGX0sJqOmy9wmrCrZXJtUb3Kltrs+Q=
Date:   Fri, 11 Aug 2023 13:41:12 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, corbet@lwn.net,
        mawupeng1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] doc-update-params-of-memhp_default_state=.patch removed from -mm tree
Message-Id: <20230811204113.47341C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: doc: update params of memhp_default_state=
has been removed from the -mm tree.  Its filename was
     doc-update-params-of-memhp_default_state=.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: doc: update params of memhp_default_state=
Date: Wed, 2 Aug 2023 15:43:12 +0800

Commit 5f47adf762b7 ("mm/memory_hotplug: allow to specify a default
online_type") allows to specify a default online_type which make online
memory to kernel or movable zone possible but fail to update to doc. 
Update doc to fit this change.

Link: https://lkml.kernel.org/r/20230802074312.2111074-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~doc-update-params-of-memhp_default_state=
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3105,7 +3105,7 @@
 			[KNL,SH] Allow user to override the default size for
 			per-device physically contiguous DMA buffers.
 
-	memhp_default_state=online/offline
+	memhp_default_state=online/offline/online_kernel/online_movable
 			[KNL] Set the initial state for the memory hotplug
 			onlining policy. If not specified, the default value is
 			set according to the
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch
swap-stop-add-to-avail-list-is-swap-is-full.patch
mm-disable-kernelcore=mirror-when-no-mirror-memory.patch

