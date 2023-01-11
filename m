Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1BCC46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbjAKVo0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbjAKVoZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 16:44:25 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59671EC56
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 13:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8cqhhUvvVLY24tg6X5mlsfN/WENZuGXF4d8EpESV7uA=; b=qkpNNdTlcFqTgkfsiAVl972vax
        cPXpiShBnnNxFdRzqvmvFq6BsIJcBV0dM0GYESkKBrb/USkYoad4XUQxHV6nqVEA1xc065iY8Swzm
        PYG9nzuxfluUCuaKsqPGIWZlGlN9jigRQdKWHq7AHxt+OAxf7UjBRM/8MK4KSlEiOGz2kvCmqC0ME
        JutHVnkl3v6lIrewVHSTKGrNQvAGhtpeP2OG/Sn2K5rOq4on4aJKg3J9fCCT/+43dzGkXGd/Ozovk
        lPq+HzP8CSyZjRSrI45Nh0UhYvNAyaXAKQWOan/MddxdvwyPfOzfnajj3yqQeUkokEv7KIBKUOLpL
        U0UotTFg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFitd-004Ur3-QD; Wed, 11 Jan 2023 21:44:33 +0000
Date:   Wed, 11 Jan 2023 21:44:33 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Subject: Re: + mm-add-folio_add_new_anon_rmap.patch added to mm-unstable
 branch
Message-ID: <Y78twan8x1lKo9aF@casper.infradead.org>
References: <20230111205838.8174CC433F1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111205838.8174CC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jan 11, 2023 at 12:58:38PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: add folio_add_new_anon_rmap()
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-add-folio_add_new_anon_rmap.patch

Thanks!  It needs this fixlet on riscv:

diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 92f53adc0dd9..d6177f3c6897 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -6,6 +6,7 @@
 
 #include <linux/migrate.h>
 #include <linux/pagemap.h>
+#include <linux/rmap.h>
 #include <linux/swap.h>
 #include "internal.h"
 
