Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC94C636D6
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 07:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjBCHx6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 02:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjBCHx4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 02:53:56 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2A921BD
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 23:53:53 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id g9so2963245pfk.13
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2023 23:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9lC5ldR2HJF7JcQmfW0U3YtIHAvTOV0kFj50eP+cWbU=;
        b=mNh5I4XH65swodnkbRTbYA3jRee9uzQlQsaq1aqTWOR0MOplAJdEs5/Xo6TO6GTbOw
         FmjeZAJYq44ia76rKPks/mAwi0S4QFc6GGvcRMrOUMhC1hQXXl7+2uQInupawbbZQdzz
         iXnOq+LCsingoGTp9sBdH+mFN+d4x/kLGBBEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lC5ldR2HJF7JcQmfW0U3YtIHAvTOV0kFj50eP+cWbU=;
        b=rxGU+BjDOrHT3N1wGmEvfu6G6eT5gPS+t5RhZVGz0872nXzhy0BnIaWmZ47Pj5EPb9
         PysZDflXh1KoLmTwOrhTn4taGIGDKl9tqrAPNK6hr960Wq84vAs9T6656tVMFWaXyE/f
         DsW+WeSGQLeI4625RarSbpT0VBnlgFSE0XQ5bY7hKGxCU4QVi1gerD4vI30FgtnLMUJI
         nfEoh32hisyPJD+Y/T22D6wi5QJkpl/xdwFL6MGOK4c9deIb28A3S8J4kdS4PSeTA1Dv
         o5BHVfWA+AILPS7Jd47E0l+TLz7qX+o8QmJPLH7GzUL6I6Il3gJvUD9vlAPDeZRQPuYq
         TXPQ==
X-Gm-Message-State: AO0yUKV/g1YdZ74yk8CSx1SsjPptJy/hk2PnjnPhqMfI86ys7R8mzTUK
        Id+kluiReDxJ435E2zDvbtZ/bQ==
X-Google-Smtp-Source: AK7set8Xnq9ocx8Mo6N+kfwTE1vifUFfMK4ZUqJAvJdr9Gg9C74MB7mhBXUewJgAuIK6yB0K3Vreqw==
X-Received: by 2002:aa7:88d1:0:b0:593:b49:16a2 with SMTP id k17-20020aa788d1000000b005930b4916a2mr10205227pff.12.1675410833167;
        Thu, 02 Feb 2023 23:53:53 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id bd37-20020a056a0027a500b0058a3d8eab6asm971905pfb.134.2023.02.02.23.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 23:53:52 -0800 (PST)
Date:   Fri, 3 Feb 2023 16:53:47 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        minchan@kernel.org, kbusch@kernel.org, ira.weiny@intel.com,
        dave.jiang@intel.com, dan.j.williams@intel.com, axboe@kernel.dk,
        hch@lst.de, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [merged mm-stable] block-remove-rw_page.patch removed from -mm
 tree
Message-ID: <Y9y9i7UCwxUj2t40@google.com>
References: <20230203063848.D066CC4339B@smtp.kernel.org>
 <Y9y9Gw0dSgwMSfIi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9y9Gw0dSgwMSfIi@google.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/02/03 16:51), Sergey Senozhatsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > Subject: block: remove ->rw_page
> > Date: Wed, 25 Jan 2023 14:34:36 +0100
> > 
> > The ->rw_page method is a special purpose bypass of the usual bio handling
> > path that is limited to single-page reads and writes and synchronous which
> > causes a lot of extra code in the drivers, callers and the block layer.
> > 
> > The only remaining user is the MM swap code.  Switch that swap code to
> > simply submit a single-vec on-stack bio an synchronously wait on it based
> > on a newly added QUEUE_FLAG_SYNCHRONOUS flag set by the drivers that
> > currently implement ->rw_page instead.  While this touches one extra cache
> > line and executes extra code, it simplifies the block layer and drivers
> > and ensures that all feastures are properly supported by all drivers, e.g.
> > right now ->rw_page bypassed cgroup writeback entirely.
> > 
> > [akpm@linux-foundation.org: fix comment typo, per Dan]
> > Link: https://lkml.kernel.org/r/20230125133436.447864-8-hch@lst.de
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Keith Busch <kbusch@kernel.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Appologies for fat finger.

Was going to say

Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org> # zram
Revieewd-by: Sergey Senozhatsky <senozhatsky@chromium.org> # zram
