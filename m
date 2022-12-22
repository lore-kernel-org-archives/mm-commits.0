Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B130C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 22 Dec 2022 21:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbiLVVb5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Dec 2022 16:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbiLVVbz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2022 16:31:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF9B2252E
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 13:31:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C6D061981
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 21:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B4C433EF;
        Thu, 22 Dec 2022 21:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671744712;
        bh=LpofkZpXa5Uh9R9agdvsqOdH92ckTi0j7hWSFqEGSio=;
        h=Date:To:From:Subject:From;
        b=JbiBFHFrIEjfTkrw198zrVp+m9qJ5UzJaXvsmEYueCzFcNGGHMskt9k8SSbbuU5za
         nfRD/7f1ytJKWvt6yrfNj6oFGo9C5+Mdk8OJmXOO7sbEnzxZGwp6e6VyIXvRS9Sv5k
         SczzXyghKHO74dfRlc/tyJQnDqkFcfft3pspbLRc=
Date:   Thu, 22 Dec 2022 13:31:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        liam.howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        corbet@lwn.net, brauner@kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagevec-add-folio_batch_reinit.patch added to mm-unstable branch
Message-Id: <20221222213152.C61B4C433EF@smtp.kernel.org>
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
Date: Thu, 22 Dec 2022 19:48:30 +0000

Patch series "update mlock to use folios".

This series updates mlock to use folios, converting the internal interface
to using folios exclusively and exposing the folio interface externally.

As a product of this, move to using a folio batch rather than a pagevec
for mlock folios, which brings it in line with the core folio batches
contained in mm/swap.c.


This patch (of 4):

This performs the same task as pagevec_reinit(), only modifying a folio
batch rather than a pagevec.

Link: https://lkml.kernel.org/r/cover.1671738120.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/f05b330bc806aa64f6ae5d0001ea9d29d47da354.1671738120.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

