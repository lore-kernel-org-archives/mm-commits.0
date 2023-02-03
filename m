Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558F7C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjBCGij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjBCGhT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642128C1DC
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15752B828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5727C4339B;
        Fri,  3 Feb 2023 06:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406195;
        bh=TWSpkWjzxt3iuPHyMsTlehLJw6deGNj/KmamWWhQU50=;
        h=Date:To:From:Subject:From;
        b=xuCpZlZuJMLglADeg6qFOYq6gF7u7EPYLz78nH1RZKzUmtG89EZqVmsvj4u0bVlqd
         +zQahMwwJzYRch+0kLeoNAP3vT9c+HhpFfDF+4Bnm6y3UTtQDQ3dcvoekgKccwgNbq
         n3+eQHVghzJF1oPj2V5vWgu3Af6CDv7NZo0p/lcY=
Date:   Thu, 02 Feb 2023 22:36:35 -0800
To:     mm-commits@vger.kernel.org, gerg@linux-m68k.org,
        geert@linux-m68k.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch removed from -mm tree
Message-Id: <20230203063635.B5727C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: m68k/mm: remove dummy __swp definitions for nommu
has been removed from the -mm tree.  Its filename was
     m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: m68k/mm: remove dummy __swp definitions for nommu
Date: Fri, 13 Jan 2023 18:10:09 +0100

The definitions are not required, let's remove them.

Link: https://lkml.kernel.org/r/20230113171026.582290-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/m68k/include/asm/pgtable_no.h~m68k-mm-remove-dummy-__swp-definitions-for-nommu
+++ a/arch/m68k/include/asm/pgtable_no.h
@@ -31,12 +31,6 @@
 extern void paging_init(void);
 #define swapper_pg_dir ((pgd_t *) 0)
 
-#define __swp_type(x)		(0)
-#define __swp_offset(x)		(0)
-#define __swp_entry(typ,off)	((swp_entry_t) { ((typ) | ((off) << 7)) })
-#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
-#define __swp_entry_to_pte(x)	((pte_t) { (x).val })
-
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
_

Patches currently in -mm which might be from david@redhat.com are


