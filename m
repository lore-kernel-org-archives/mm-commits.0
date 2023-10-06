Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD33CE94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbjJFVtZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbjJFVtW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:49:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686EABD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:49:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89308C433C7;
        Fri,  6 Oct 2023 21:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628961;
        bh=8O9UfqDkVBqUUfYFzxTJWjUjDu6tDsxzBTfYwzwutBQ=;
        h=Date:To:From:Subject:From;
        b=l2rpBzX2ff8BpknJ8ynvsEuAWxx8/SUIslVnCP0s48tRc68dIeXHC7yZ7YGywTeuW
         4XM7lb8QJidxWTdMt56pHp1N6qmbAICJyl5s9FS57fumU8H+gGQf3b5d/OwoY7vwaA
         d0/qLqdTsmTx/2kNPkpYJhlz2vWw85X4OWRID15w=
Date:   Fri, 06 Oct 2023 14:49:18 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-document-smart-scan-mode.patch removed from -mm tree
Message-Id: <20231006214920.89308C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/ksm: document smart scan mode
has been removed from the -mm tree.  Its filename was
     mm-ksm-document-smart-scan-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: document smart scan mode
Date: Mon, 25 Sep 2023 21:09:38 -0700

This adds documentation for the smart scan mode of KSM.

[akpm@linux-foundation.org: fix typo]
[akpm@linux-foundation.org: document that smart_scan defaults to on]
Link: https://lkml.kernel.org/r/20230926040939.516161-4-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-document-smart-scan-mode
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -155,6 +155,15 @@ stable_node_chains_prune_millisecs
         scan. It's a noop if not a single KSM page hit the
         ``max_page_sharing`` yet.
 
+smart_scan
+        Historically KSM checked every candidate page for each scan. It did
+        not take into account historic information.  When smart scan is
+        enabled, pages that have previously not been de-duplicated get
+        skipped. How often these pages are skipped depends on how often
+        de-duplication has already been tried and failed. By default this
+        optimization is enabled.  The ``pages_skipped`` metric shows how
+        effective the setting is.
+
 The effectiveness of KSM and MADV_MERGEABLE is shown in ``/sys/kernel/mm/ksm/``:
 
 general_profit
_

Patches currently in -mm which might be from shr@devkernel.io are


