Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D05C727A3
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244035AbjHXXWx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244078AbjHXXWQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3476ECEE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E5464FED
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70864C433C9;
        Thu, 24 Aug 2023 23:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919333;
        bh=BNLqhDRRM/KA5eEv955pQGHbw5WSOA+pV5uQ3BEQc/4=;
        h=Date:To:From:Subject:From;
        b=jrKxMcOO9+Ox8JiGQcet/1r2C5FBmirgMtimjknyh2sm80/dKVL0DZ/WmPqzvJA5L
         GLazXuj7TAACzMg3l8cQRE8ehh3Z1ufFKoY/pnecdE7MtDPkjM9wJYyK8zT3I3WxvX
         0jdxnnfjFVMQqUDmlu934NBbdr2hFLKqiHKwUGBU=
Date:   Thu, 24 Aug 2023 16:22:12 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch removed from -mm tree
Message-Id: <20230824232213.70864C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix kernel-doc warning from tlb_flush_rmaps()
has been removed from the -mm tree.  Its filename was
     mm-fix-kernel-doc-warning-from-tlb_flush_rmaps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix kernel-doc warning from tlb_flush_rmaps()
Date: Fri, 18 Aug 2023 21:06:27 +0100

Patch series "Improve mm documentation".

If you build with W=1, kernel-doc complains about tlb_flush_rmaps().  Then
I ran scripts/find-unused-docs.sh against mm/ and found a large number of
files which weren't included in the ReST documentation.  I fixed up a
couple of them, and added all those without erros to the rst files. 
There's a lot more work to do to organise all of this, but at least now if
we have documentation that refers to these functions, we'll get a nice
link to them.


This patch (of 4):

The vma parameter wasn't described.

Link: https://lkml.kernel.org/r/20230818200630.2719595-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230818200630.2719595-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmu_gather.c~mm-fix-kernel-doc-warning-from-tlb_flush_rmaps
+++ a/mm/mmu_gather.c
@@ -63,6 +63,7 @@ static void tlb_flush_rmap_batch(struct
 /**
  * tlb_flush_rmaps - do pending rmap removals after we have flushed the TLB
  * @tlb: the current mmu_gather
+ * @vma: The memory area from which the pages are being removed.
  *
  * Note that because of how tlb_next_batch() above works, we will
  * never start multiple new batches with pending delayed rmaps, so
_

Patches currently in -mm which might be from willy@infradead.org are


