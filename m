Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059A1EB64DD
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 04:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjHKELo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 00:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjHKELm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 00:11:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBBEE4F
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 21:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GymhSioEgpTcI5PupyjFUy2U/zPWkh80IXY5aHY7L5A=; b=qqAlHMuYViJRRUGMoDh32EkK91
        gI4ua6SK0G5w15MKkQ1PVUM/K2cWgBL/4SgnFdKs5/TC1eYoCkCLihDIzPdkd+VH7fi7hxH0qM4f8
        HaSjd8Zw8T+a4m7F6eIOBscvsOb7TUQPesRjx8aK2I480G7q/Pv8/o3R75K0OeOzJmM+88i/1z4mk
        nff9u8mXVdZqaul1T1xsgkKWTCsxjJqUI/CW898k50rkzDnS4jiiffylLHYDBqELc9FrMl1JbufOe
        H5UndzrUIeQwxYyvK4wIyTo+w5+kpcYp70bXOFw6zqKMZisViIuXyPUy7Zq/sS8IuMe6DZugyMR3R
        +oz3sWLA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qUJUx-00GYWU-Uh; Fri, 11 Aug 2023 04:11:40 +0000
Date:   Fri, 11 Aug 2023 05:11:39 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        fengwei.yin@intel.com
Subject: Re: + zswap-make-zswap_load-take-a-folio-fix.patch added to
 mm-unstable branch
Message-ID: <ZNW0+8QiWesvJwh+@casper.infradead.org>
References: <20230810163538.7C2AAC433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230810163538.7C2AAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Aug 10, 2023 at 09:35:37AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: zswap: don't warn if none swapcache folio is passed to zswap_load
> has been added to the -mm mm-unstable branch.  Its filename is
>      zswap-make-zswap_load-take-a-folio-fix.patch

Disagree that this is a fix patch.  My original patch does:

-       VM_WARN_ON_ONCE(!PageLocked(page));
-       VM_WARN_ON_ONCE(!PageSwapCache(page));
+       VM_WARN_ON_ONCE(!folio_test_locked(folio));
+       VM_WARN_ON_ONCE(!folio_test_swapcache(folio));

so I didn't add a new assertion, merely removed a call to
compound_head().  I think this patch deserves to stand on its own and
not be folded into mine.

