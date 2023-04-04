Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4631BC76196
	for <mm-commits@archiver.kernel.org>; Tue,  4 Apr 2023 02:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjDDCA5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 22:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDDCA4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 22:00:56 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A3C1723
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 19:00:54 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f22so25788079plr.0
        for <mm-commits@vger.kernel.org>; Mon, 03 Apr 2023 19:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680573654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rdHedRZrnkSWG12NS1hxkCjrbGhL3Wyq1hfAOyNe3S0=;
        b=LRQnO8EKh0v8sd9QQLYtRlBnnSiTr0MI2li053Vba6MYVoOOjVMScLVO/UtaJeyqtr
         efavwialEDnCNwAsI1dKpmaTszSzQST64SXFqQ4pyi8DCEQFlLHEbHpZdAzTT0M2nwtg
         Q/JH2wvQY4nsAJ5l6nnO4xA9DOUDEXn07VJRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680573654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rdHedRZrnkSWG12NS1hxkCjrbGhL3Wyq1hfAOyNe3S0=;
        b=jO3tDkhN/8txhgyF1JKajLNhsaMN9WWrKmCSkG+kaSLn2BfO0IIy65/clUhpfZYG1Q
         0yGfbF9Jrew/RuWstSGzIpTvrLS6zJmzD8XBp7mTB/HhC5/ioSvCGbyNNv/0CatjFLxc
         rSMIFC4VfTwemm0SWQJnY9YNZoC83zovad2BhkoSnrwCWGIvuEHK1LujoQJNajxd5R1I
         8WguYtFHj5AjOz6GAoS9I8/3FQ18A5vJAebqlHdXQf9admXLeUwSGEc+uTrYiVFvkgFl
         n6+exLf7g50wSWgen+IGVhpPKlytJ7lVXdiutK2SsmVZIP+k1flxkbct8yNkHhm5b9ze
         6KPw==
X-Gm-Message-State: AAQBX9cjl7ly6eeXlgYfIY4zzX+EOqU3s7JS+5RSalKRcW7FrQXTuj9n
        ndP8cJxNItRyXy6ITevxhoMsJw==
X-Google-Smtp-Source: AKy350bXcq2CG247QaSZDmzqsgmUcYfS5tlD7eBmtzqI7dMm9epyakf9n771Wdiwgj+Km3i9Rd4WtQ==
X-Received: by 2002:a17:90b:4b0b:b0:23c:8ee2:bc14 with SMTP id lx11-20020a17090b4b0b00b0023c8ee2bc14mr1113990pjb.24.1680573654370;
        Mon, 03 Apr 2023 19:00:54 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id v4-20020a17090a088400b0023b3a9fa603sm10066856pjc.55.2023.04.03.19.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 19:00:53 -0700 (PDT)
Date:   Tue, 4 Apr 2023 11:00:48 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, senozhatsky@chromium.org,
        minchan@kernel.org, mcgrof@kernel.org, martin@omnibond.com,
        hubcap@omnibond.com, hch@lst.de, brauner@kernel.org,
        axboe@kernel.dk, p.raghav@samsung.com
Subject: Re: +
 zram-always-chain-bio-to-the-parent-in-read_from_bdev_async.patch added to
 mm-unstable branch
Message-ID: <20230404020048.GG12892@google.com>
References: <20230403204245.2B976C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403204245.2B976C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/04/03 13:42), Andrew Morton wrote:
[..]
> zram_bvec_read() is called with the bio set to NULL only in
> writeback_store() function.  When a writeback is triggered,
> zram_bvec_read() is called only if ZRAM_WB flag is not set.  That will
> result only calling zram_read_from_zspool() in __zram_bvec_read().
> 
> rw_page callback used to call read_from_bdev_async with a NULL parent bio
> but that has been removed since commit 3222d8c2a7f8 ("block: remove
> ->rw_page").
> 
> We can now safely always call bio_chain() as read_from_bdev_async() will
> be called with a parent bio set.  A WARN_ON_ONCE is added if this function
> is called with parent set to NULL.
> 
> Link: https://lore.kernel.org/linux-mm/ZBHcl8Pz2ULb4RGD@infradead.org/ [1]
> Link: https://lore.kernel.org/linux-mm/20230322135013.197076-1-p.raghav@samsung.com/ [2]
> Link: https://lore.kernel.org/linux-mm/8adb0770-6124-e11f-2551-6582db27ed32@samsung.com/ [3]
> Link: https://lkml.kernel.org/r/20230403132221.94921-2-p.raghav@samsung.com
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Martin Brandenburg <martin@omnibond.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Mike Marshall <hubcap@omnibond.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
