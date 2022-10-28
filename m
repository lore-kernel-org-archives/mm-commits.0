Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4D3ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 02:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiJ1CbU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 22:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbiJ1CbU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 22:31:20 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147A2BCBAB
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 19:31:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p3so3640803pld.10
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 19:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tAUHHH/m0eIDeN4f4s+iXMFmqb+KGK4/n0ZCUCCOc5I=;
        b=aSJM+OG1FhyemlYtNwTjw5ZV4VuGb+rqhlQAT7rtmCvgGxlpk6ZnaI2nltig9f4BbZ
         0PHobX3HoAX2IxGudWVhQ6GzIsWvwD92Ad+AqVY3003VaLigfymIuruJNDEkJ2/30Xn8
         dxuLieOP54d6pyehSJRWCTwwCRMwpyRQo4cNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tAUHHH/m0eIDeN4f4s+iXMFmqb+KGK4/n0ZCUCCOc5I=;
        b=ks4hIRz63M/gMJa4ogLqrQLYzjX0k5a3ndJSkiIGHAKprWfiJAT1ifoDyFDV5zmaGB
         ZHsWsHAKRCujp/YVkxe3aZsWjebwAawOYLyBXUdQaID7gs5sgV8tUJ+nuG+AwuGzDXwl
         mSMLYfxEOik6sCtXSty3L2gD9AwlVlKnYYm7RbKHA2yBpsQTN27SItX5itCRmSWYGQhe
         kUfBYBkGwhZndNi82+R2KVv4DFzyfH4IRwyafzk7/o3Z4FKEpAIBz698AXEegZ7jloof
         XJAv9TPBAuEElQbINzuKOMSswLymtaOBRc9g6nqOrDQ0mDzvqgUU7rzUusf/mHHGLmEd
         fslw==
X-Gm-Message-State: ACrzQf329cqD+hrWaceityQgEcVTB0gC7edLV06iQREClCB9xGhU0b3P
        j3tmvHMfAAxvpv8wsbNIFzq/Ag==
X-Google-Smtp-Source: AMsMyM5nOKKnkWR9Ks8X1/lz1RvJR71ZgqIIeKuYxY6WVk4l1o1x/tiZwsP6ykw6vNdeD8zsm0YyYA==
X-Received: by 2002:a17:90a:1946:b0:212:f926:5382 with SMTP id 6-20020a17090a194600b00212f9265382mr13460581pjh.218.1666924278543;
        Thu, 27 Oct 2022 19:31:18 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:dd1f:6bfc:e6b3:cd8d])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090a818500b0020d9ac33fbbsm1623721pjn.17.2022.10.27.19.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 19:31:17 -0700 (PDT)
Date:   Fri, 28 Oct 2022 11:31:14 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, linux-kernel@vger.kernel.org
Subject: Re: + zram-add-size-class-equals-check-into-recompression.patch
 added to mm-unstable branch
Message-ID: <Y1s+8ohGRlutI7aI@google.com>
References: <20221027200348.1BC0FC433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027200348.1BC0FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/10/27 13:03), Andrew Morton wrote:
> The patch titled
>      Subject: zram: add size class equals check into recompression
> has been added to the -mm mm-unstable branch.  Its filename is
>      zram-add-size-class-equals-check-into-recompression.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-size-class-equals-check-into-recompression.patch

[..]

> Patch series "zsmalloc/zram: configurable zspage size", v3.
> 
> It makes no sense for us to recompress the object if it will be in the
> same size class.  We anyway don't get any memory gain.  But, at the same
> time, we get a CPU time overhead when inserting this object into zspage
> and decompressing it afterwards.
> 
> Link: https://lkml.kernel.org/r/20221027042651.234524-1-senozhatsky@chromium.org
> Link: https://lkml.kernel.org/r/20221027042651.234524-2-senozhatsky@chromium.org
> Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
