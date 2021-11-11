Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615EFC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A07761108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhKKCvK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234437AbhKKCvK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE13C610A2;
        Thu, 11 Nov 2021 02:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598902;
        bh=nKX3dhavRhQTpg9yx3yV/r9ksIX2pnEm7wyKOpzOFmE=;
        h=Date:From:To:Subject:From;
        b=vF4gjvYSil5Izm4BwCQbIhNm8uObJ+OuEPTZNXnjriOX8YbkS+1xxIFzsiztd5ukr
         Dt6pbcl/5y0pxdFx4wwl+GvQ8jy3TFNIRVHGeaxvPZTwJ9JnJSt+Z8HOHqBpXyt4cg
         9kfMWXTFVlv/RrwoO0iYziFDl0ST42JY5C1QVmyM=
Date:   Wed, 10 Nov 2021 18:48:21 -0800
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com
Subject:  [merged]
 kfence-add-note-to-documentation-about-skipping-covered-allocations.patch
 removed from -mm tree
Message-ID: <20211111024821.Cn_NmP1et%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: add note to documentation about skipping covered allocations
has been removed from the -mm tree.  Its filename was
     kfence-add-note-to-documentation-about-skipping-covered-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: add note to documentation about skipping covered allocations

Add a note briefly mentioning the new policy about "skipping currently
covered allocations if pool close to full." Since this has a notable
impact on KFENCE's bug-detection ability on systems with large uptimes, it
is worth pointing out the feature.

Link: https://lkml.kernel.org/r/20210923104803.2620285-5-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/dev-tools/kfence.rst~kfence-add-note-to-documentation-about-skipping-covered-allocations
+++ a/Documentation/dev-tools/kfence.rst
@@ -269,6 +269,17 @@ tail of KFENCE's freelist, so that the l
 first, and the chances of detecting use-after-frees of recently freed objects
 is increased.
 
+If pool utilization reaches 75% (default) or above, to reduce the risk of the
+pool eventually being fully occupied by allocated objects yet ensure diverse
+coverage of allocations, KFENCE limits currently covered allocations of the
+same source from further filling up the pool. The "source" of an allocation is
+based on its partial allocation stack trace. A side-effect is that this also
+limits frequent long-lived allocations (e.g. pagecache) of the same source
+filling up the pool permanently, which is the most common risk for the pool
+becoming full and the sampled allocation rate dropping to zero. The threshold
+at which to start limiting currently covered allocations can be configured via
+the boot parameter ``kfence.skip_covered_thresh`` (pool usage%).
+
 Interface
 ---------
 
_

Patches currently in -mm which might be from elver@google.com are


