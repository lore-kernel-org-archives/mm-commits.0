Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEEAC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjBCGhx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjBCGga (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BF08D63F
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 101FF61D1D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6284DC4339C;
        Fri,  3 Feb 2023 06:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406179;
        bh=+z+1pvHlnTg24nyCFUz0acf12z4qG3JJCq3FB0h0Pmk=;
        h=Date:To:From:Subject:From;
        b=0TATOE6wnysrgS1Iqznl1LVoM8L2VdZpbjq0VvZlx95Gvo549Z3EAMAGZwYNJaTHz
         7PkVHiMsPZq8WDNBOUmQPOEAd5vsCehhCwlrZPjyIMJzSPED6vEb4S0igKC5B2MFtA
         mAn6IniWTSMNU+sQTkAjojSo3RJt8Rue0rUoeOFM=
Date:   Thu, 02 Feb 2023 22:36:18 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        Liam.Howlett@oracle.com, joel@joelfernandes.org, hughd@google.com,
        geert@linux-m68k.org, corbet@lwn.net, brauner@kernel.org,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-mm-motorola-specify-pmd_page-type.patch removed from -mm tree
Message-Id: <20230203063619.6284DC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: m68k/mm/motorola: specify pmd_page() type
has been removed from the -mm tree.  Its filename was
     m68k-mm-motorola-specify-pmd_page-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: m68k/mm/motorola: specify pmd_page() type
Date: Thu, 12 Jan 2023 12:39:30 +0000

Failing to specify a specific type here breaks anything that relies on the
type being explicitly known, such as page_folio().

Make explicit the type of null pointer returned here.

Link: https://lkml.kernel.org/r/ad6be2821bbd6af10966b3704568ff458b270d9c.1673526881.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-mm-motorola-specify-pmd_page-type
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -124,7 +124,7 @@ static inline void pud_set(pud_t *pudp,
  * expects pmd_page() to exists, only to then DCE it all. Provide a dummy to
  * make the compiler happy.
  */
-#define pmd_page(pmd)		NULL
+#define pmd_page(pmd)		((struct page *)NULL)
 
 
 #define pud_none(pud)		(!pud_val(pud))
_

Patches currently in -mm which might be from lstoakes@gmail.com are


