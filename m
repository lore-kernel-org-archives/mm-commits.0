Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A89FC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345377AbiFCSpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347363AbiFCSoz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:44:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F561D33D
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AjI29Z4amIhdGwAkQDv4fDGSF2gn8t285kaGbL2V8jA=; b=vLwfxksjp1rWhdwMndoLeZTwUY
        I2dtT1EnVEQEWwiuCfDP6MRLgYJclZ0HauXjL/xk4Ugjft4nQEYxDO+xYXfD9nL1Z2YKM+q6vCD06
        +QMjEmhZTpm1d1zWf4j94znNrdSbSsiVBA08WxXLiw22v0S9Wsv4gjz2FaZi7jEx9u00ibXi3wJ3L
        NJA0EWX+5NS0pn8fgB/0Yi3HDD8an/Mly9oxg6aK6eZNT8y3tTmldEtEN/IJsec6uUfX5w1Ge6Llz
        e/xm+ymJlEOoTh3TKqnYC6MWw4bz0i7pJeay2Uay80pX8pSe9u6bIHFNckbfBHoRSYZa3Bv37BfG1
        UPl/9SpA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nxCHx-00855t-TF; Fri, 03 Jun 2022 18:44:49 +0000
Date:   Fri, 3 Jun 2022 19:44:49 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: + xarray-replace-kernelh-with-the-necessary-inclusions.patch
 added to mm-nonmm-unstable branch
Message-ID: <YppWoUnSxCUljVpS@casper.infradead.org>
References: <20220603183231.15159C385A9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603183231.15159C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jun 03, 2022 at 11:32:30AM -0700, Andrew Morton wrote:
> ------------------------------------------------------
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Subject: include/linux/xarray.h: replace kernel.h with the necessary inclusions
> Date: Fri, 3 Jun 2022 20:11:53 +0300
> 
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
> 
> Replace kernel.h inclusion with the list of what is really being used.
> 
> Link: https://lkml.kernel.org/r/20220603171153.48928-1-andriy.shevchenko@linux.intel.com
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

NAK, breaks the test suite.
