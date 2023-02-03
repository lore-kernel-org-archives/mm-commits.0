Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47939C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjBCGhe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCGga (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24F88D637
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C08DB82985
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF06FC433EF;
        Fri,  3 Feb 2023 06:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406177;
        bh=PNv+345r3GSZadJuRS/7UDmbRXvqJXHonb2Fgm04d30=;
        h=Date:To:From:Subject:From;
        b=lY2en+msHPH2QC0jbJYh+OyUYjb+0jdgk5l+9GrTeMKeDXXWD+veUohcdSi/B+n5Q
         iF8tTY00m/1RFOPYVV3j9dLfK7N8OL89Qz4pvOvu84RwI9KQGtNIdQxlx3KrK1Jdhw
         stJr5YgCx+MDBwfxse4fwi2NSnTmOXyXPdJJh/A0=
Date:   Thu, 02 Feb 2023 22:36:16 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        geert@linux-m68k.org, corbet@lwn.net, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagevec-add-folio_batch_reinit.patch removed from -mm tree
Message-Id: <20230203063616.EF06FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: pagevec: add folio_batch_reinit()
has been removed from the -mm tree.  Its filename was
     mm-pagevec-add-folio_batch_reinit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


