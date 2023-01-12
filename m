Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E37C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjALV7Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240969AbjALV67 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:58:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0F06B19E
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:50:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B945B81FC4
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D742EC433F2;
        Thu, 12 Jan 2023 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673560204;
        bh=uvRRdoW6QywQLAIyagooIfBFejyJr7k24bSVpHk8/do=;
        h=Date:To:From:Subject:From;
        b=snXT+QTOD5KBMtcbjg8WksnyPgb6eGpUhm1czmHFbeFvpXmj+JZOVPOoDFs22yDoq
         2MJJ1bmeMLALNtddSwy4pW6qvlNroyi4WaDXy0F1f/spFgzCeRtTG1v1tkOT8Q3qHW
         j97fHcns7PaqyYkwoCZAietk6n4VXqaO4R1fpQLU=
Date:   Thu, 12 Jan 2023 13:50:04 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        geert@linux-m68k.org, corbet@lwn.net, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pagevec-add-folio_batch_reinit.patch added to mm-unstable branch
Message-Id: <20230112215004.D742EC433F2@smtp.kernel.org>
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
Date: Thu, 12 Jan 2023 12:39:28 +0000

Patch series "update mlock to use folios", v4.

This series updates mlock to use folios, converting the internal interface
to using folios exclusively and exposing the folio interface externally.

As a product of this we move to using a folio batch rather than a pagevec
for mlock folios, which brings it in line with the core folio batches
contained in mm/swap.c.


This patch (of 5):

This performs the same task as pagevec_reinit(), only modifying a folio
batch rather than a pagevec.

Link: https://lkml.kernel.org/r/cover.1673526881.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/9018cecacb39e34c883540f997f9be8281153613.1673526881.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    5 +++++
 1 file changed, 5 insertions(+)

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

mm-vmalloc-correct-use-of-__gfp_nowarn-mask-in-__vmalloc_area_node.patch
selftest-vm-add-mremap-expand-merge-offset-test.patch
mm-pagevec-add-folio_batch_reinit.patch
mm-mlock-use-folios-and-a-folio-batch-internally.patch
m68k-mm-motorola-specify-pmd_page-type.patch
mm-mlock-update-the-interface-to-use-folios.patch
documentation-mm-update-references-to-__mlock_page-to-_folio.patch

