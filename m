Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E27EC10F1E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiLLCOk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiLLCOI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FAA56599
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CF3F60E77
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7491AC433EF;
        Mon, 12 Dec 2022 02:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811239;
        bh=8GRR7lW/y0WuAOQL2vYyNZGQNuqTHbm6SalKO7kU4GA=;
        h=Date:To:From:Subject:From;
        b=jZxcEfN6fAwcIBcmWCugncm53a8Um97MsX92Qxdf0U0y4XLAHDN7/z5aUS0s19+61
         HOdGyNZGmPcWjiRYnpSDYhaafEARwhqMwpqqDg55bl/SFJXgWKHxdwjS6Gmpx2VVPJ
         aEJJGyxodo37xUVu7HlZzyohI06Ea5MMRHf55wY8=
Date:   Sun, 11 Dec 2022 18:13:58 -0800
To:     mm-commits@vger.kernel.org, zhang.songyi@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] include-linux-pgtableh-remove-redundant-pte-variable.patch removed from -mm tree
Message-Id: <20221212021359.7491AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/pgtable.h: : remove redundant pte variable
has been removed from the -mm tree.  Its filename was
     include-linux-pgtableh-remove-redundant-pte-variable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhang songyi <zhang.songyi@zte.com.cn>
Subject: include/linux/pgtable.h: : remove redundant pte variable
Date: Mon, 28 Nov 2022 21:07:43 +0800 (CST)

Return value from ptep_get_and_clear_full() directly instead of taking
this in another redundant variable.

Link: https://lkml.kernel.org/r/202211282107437343474@zte.com.cn
Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/pgtable.h~include-linux-pgtableh-remove-redundant-pte-variable
+++ a/include/linux/pgtable.h
@@ -425,9 +425,7 @@ static inline pte_t ptep_get_and_clear_f
 					    unsigned long address, pte_t *ptep,
 					    int full)
 {
-	pte_t pte;
-	pte = ptep_get_and_clear(mm, address, ptep);
-	return pte;
+	return ptep_get_and_clear(mm, address, ptep);
 }
 #endif
 
_

Patches currently in -mm which might be from zhang.songyi@zte.com.cn are


