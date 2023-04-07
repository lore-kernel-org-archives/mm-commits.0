Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41934C761A6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Apr 2023 01:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjDGBGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 21:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjDGBGG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 21:06:06 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B162283F2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 18:06:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-629698debf8so70549b3a.2
        for <mm-commits@vger.kernel.org>; Thu, 06 Apr 2023 18:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680829565; x=1683421565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LJPWKbsOgqAeZNNGmvDoQCXrWdC7gdnaPWYYTtOKtGg=;
        b=I/6GpwUp+5b3bCxLBTgShDAyUW/0tY5bK05vPYaE7f/HGm56sobBKtbgyh7vP2/p5f
         R78Icc87R1dB5D7n43TseOfEPhSmuXu2sEMQJuTHM/efvaeyN8IG/NoBHTdUVhW3HRq+
         VD1aSow7OSBOUiRG4EfeEgW8NV3eMqb+9low0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680829565; x=1683421565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJPWKbsOgqAeZNNGmvDoQCXrWdC7gdnaPWYYTtOKtGg=;
        b=GixIOZ3HUYG5kRcuab85rS49mjyDJsVLOQV8Yf+vnavmCtHU7TcknrO9llO4BM4g0R
         BoCjCdS0WuhFVDs5zF/GATtOl5/z9+EInq3kwEfUBN+dFuz0PdJOPRXdx2Klu5fmY0hP
         hLNcgUpy+bqi27WAx1dzyVP8Oa9bePjvp8zSSMJbhDoQlDOwhr1gZNdzsshtxu5Qo6mr
         YfeaDXSh7geFII7MleQes79CjSW0YyP/+dJH+R2ftipYUrNAPY91OgKIPBNYPf5iNNuU
         MAo7g7/ZU45qZsgkY16xchciMPpdW9ZX5j6ohE+1OOQT4GB9qRll7IetssEz+RMXdrfA
         qPDg==
X-Gm-Message-State: AAQBX9eQ+9+18KZ36NXBnFEKyrO8hOqhavLO6YP2t7g7HT0FAYkECvo0
        r+uLinY/4z7ynxNE9lCZ/4W05g==
X-Google-Smtp-Source: AKy350aWYsFEIyRbw4xguBgm0Amn6VGWEABFLCGostAqU6urxBxWuRC86L6yMD/B4YpY6cJ7IV5Nmw==
X-Received: by 2002:aa7:96e9:0:b0:62d:ad69:93a9 with SMTP id i9-20020aa796e9000000b0062dad6993a9mr766964pfq.8.1680829565200;
        Thu, 06 Apr 2023 18:06:05 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id c8-20020aa781c8000000b00593e84f2d08sm1927950pfn.52.2023.04.06.18.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 18:06:04 -0700 (PDT)
Date:   Fri, 7 Apr 2023 10:06:01 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: + zram-refactor-highlevel-read-and-write-handling.patch added to
 mm-unstable branch
Message-ID: <20230407010601.GY12892@google.com>
References: <20230406221837.6AA67C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406221837.6AA67C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/04/06 15:18), Andrew Morton wrote:
> Instead of having an outer loop in __zram_make_request and then branch out
> for reads vs writes for each loop iteration in zram_bvec_rw, split the
> main handler into separat zram_bio_read and zram_bio_write handlers that
> also include the functionality formerly in zram_bvec_rw.
> 
> Link: https://lkml.kernel.org/r/20230406144102.149231-7-hch@lst.de
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
