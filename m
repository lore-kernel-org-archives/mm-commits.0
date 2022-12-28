Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B6CC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 23:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiL1X2z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 18:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiL1X2y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 18:28:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DF213D15
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 15:28:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF4FC61626
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 23:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAA7C433EF;
        Wed, 28 Dec 2022 23:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672270132;
        bh=oKcGXK6zg3XhKou/nZjnfToyMPu1alvLV2wKenk//y4=;
        h=Date:To:From:Subject:From;
        b=A6vkPxi0paxSRWN7cqlqcImzKnaC+CW60UjKrlBY+t8bTPbDAxrr1MDFI6X8BRV8O
         tt8r2n58d8zG8egnlvhG2CwfPXC0K7u3kF/hzjwQxcKs2U2QQTU8KHzBsat9Ulup8n
         6q1JYiqjbD9dndpVcu/hNC/v3kcbGeDszyJPrZxM=
Date:   Wed, 28 Dec 2022 15:28:50 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        geert@linux-m68k.org, corbet@lwn.net, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagevec-add-folio_batch_reinit.patch added to mm-unstable branch
Message-Id: <20221228232852.1BAA7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagevec: add folio_batch_reinit()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pagevec-add-folio_batch_reinit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pagevec-add-folio_batch_reinit.patch

This patch will later appear in the mm-unstable branch at
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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: pagevec: add folio_batch_reinit()
Date: Mon, 26 Dec 2022 08:44:19 +0000

Patch series "update mlock to use folios", v3.

This series updates mlock to use folios, converting the internal interface
to using folios exclusively and exposing the folio interface externally.

As a product of this moves to using a folio batch rather than a pagevec
for mlock folios, which brings it in line with the core folio batches
contained in mm/swap.c.


This patch (of 5):

This performs the same task as pagevec_reinit(), only modifying a folio
batch rather than a pagevec.

Link: https://lkml.kernel.org/r/cover.1672043615.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/b75d577d0994229f142bcca8ff330c4c587389dd.1672043615.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/pagevec.h~mm-pagevec-add-folio_batch_reinit
+++ a/include/linux/pagevec.h
@@ -103,6 +103,11 @@ static inline void folio_batch_init(stru
 	fbatch->percpu_pvec_drained = false;
 }
 
+static inline void folio_batch_reinit(struct folio_batch *fbatch)
+{
+	fbatch->nr = 0;
+}
+
 static inline unsigned int folio_batch_count(struct folio_batch *fbatch)
 {
 	return fbatch->nr;
_

Patches currently in -mm which might be from lstoakes@gmail.com are

selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

