Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E873C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8AA61372
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhKEUsV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:43284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233782AbhKEUsR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A17A861357;
        Fri,  5 Nov 2021 20:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145137;
        bh=3laThTs8az9HfqbyXz9b288O9taJO3LrkKCUHkrL5Ng=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zIjNYy/Piknx2M/n+dYwDNtwryCpIjhV+PpOp74c5hmtxN6qhsH2AnY2BcDbzM1gL
         VywLlblc7eY6xLcMaRGDirTxo9ZPIZdTBbSsBd/zxTSrGYk8w83E+M1+SN9It4gJBH
         DENVG2kpxhLBLRRXb53RA/LShK74sb8Fe4BSnobc=
Date:   Fri, 05 Nov 2021 13:45:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com, torvalds@linux-foundation.org
Subject:  [patch 209/262] kfence: add note to documentation about
 skipping covered allocations
Message-ID: <20211105204537.mUNMkL-XE%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
