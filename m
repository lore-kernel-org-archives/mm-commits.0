Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D616CA0EEB
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 16:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbjILQKU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236583AbjILQKC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 12:10:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E781724;
        Tue, 12 Sep 2023 09:09:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07E2C433C7;
        Tue, 12 Sep 2023 16:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694534980;
        bh=CAIk6vw8OzZDI1FJyC0jmDb7nYJBnyOGVfJahRMQpqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yGB7U0b1v2ErUF8JDn1fHFE6Q3RjpCbynDbDZzaZXoorqFIyJXCbLpPeqhZ9Q/uMV
         iT8kq2iYuAwcM2IxYIkfsnJbSNcaHUHdL3aRtz1UXXetip33MBMe6ox3P/ZJ04dJEZ
         t6e/Zcw2AL4LZ2iGtc7DkYepmaLn8LZJ/mBi1Cw4=
Date:   Tue, 12 Sep 2023 09:09:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        joe.liu@mediatek.com, mgorman@techsingularity.net
Subject: Re: +
 mm-page_alloc-free-pages-to-correct-buddy-list-after-pcp-lock-contention.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20230912090938.c5314956fe385241bf567a9e@linux-foundation.org>
In-Reply-To: <20230912135029.GA249952@cmpxchg.org>
References: <20230911210053.8B7B0C433CD@smtp.kernel.org>
        <20230912135029.GA249952@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 12 Sep 2023 09:50:29 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> This patch is superseded by the following patch you picked up:
> mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch

OK.

> If you drop this patch here, you can also drop the fixlet to
> free_unref_page(). The branch in there should look like this:
> 
> 	if (pcp)
> 		free_unref_page_commit(..., pcpmigratetype, ...);
> 	else
> 		free_one_page(..., migratetype, ...);

Well kinda.  It's actually

	if (pcp) {
		free_unref_page_commit(zone, pcp, page, migratetype, order);
		pcp_spin_unlock(pcp);
	} else {
		free_one_page(zone, page, pfn, order, migratetype, FPI_NONE);
	}

