Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35406C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 03:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379893AbiFQDAz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 23:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiFQDAy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 23:00:54 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E7C66212
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 20:00:53 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso130760pjn.2
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 20:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zrgtNTxh+v+8dx+nAy3WThQrOnKeGoUipIofEvm2OT0=;
        b=QDwhuLwsHiTF3eFlBnlTyjFyKYrhwEnAVskUH5tmg+FatqAGNG3caHBFGCMMHyNV5H
         zebse8RQnvGsY4HgJRFOKGaerIqN0TwUQjZhdwg0SC+zTWGKFEBZYBLFUBtI451sPpIl
         FjtcCUhtnTpFmN3jLBOngsQp0aTpmfcY2GaR+idwL5pPsohEqB/TcFdTl2/96IaX+Ctd
         /ZvZwVNfWCrbU+dQxIS6MRYA/9izB9Zkau28VZRCDwEV63t3piQqX8BSLRekNsHtb1BN
         FmcYjLr8CryEsqezCnDuhAEwPa/pxxupY8y8drN4FfFatVYVghNkouTVp2DwyFK1QjQx
         bOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zrgtNTxh+v+8dx+nAy3WThQrOnKeGoUipIofEvm2OT0=;
        b=4xN79gn+YqDeaIHfC40yiCVPrENUEtC30T2mh5Uols3ylGcwxfnMlrZ5Dmc90BOZxX
         5sx+Wu4FEPL9uadz82+xwhdfMvrvv3jv1VTkFHW+poY5KhD6eTtFzuYaMKJX1E2St2PZ
         qoXAOb7DcLD9XwHfSuEdgd4a6vjUk6alYjJoCkJCCyM7WENS/w/4d0v1uaLS8OW7xRM7
         b7Oq367figMSDyQiwzz1XpHoddJ2HKFd89jU2cvLD0Q9BHnREW1tQW9zfZQNy2Q7ked+
         7GWNuLVIvs56bQhJoT0zx1/Ln7wiyE5I812pUPnVruUQpUndJARPzhuu6id4qLapSL0q
         y+rg==
X-Gm-Message-State: AJIora9vT2xHB5yY2WPUVEEiswDXC40KzMgAGJePn8TSe7tGd85jLIXt
        SpI+Gu5COGtjYpAATA6kj1c=
X-Google-Smtp-Source: AGRyM1uwfqv2pyo/oUGs+lJDVmLmRgnPAgq9d0neKkI6zbESqs1JfT+9fNrPr/VOw39IfjihHr/oeA==
X-Received: by 2002:a17:90a:e2c2:b0:1ea:788a:e951 with SMTP id fr2-20020a17090ae2c200b001ea788ae951mr8341509pjb.155.1655434852870;
        Thu, 16 Jun 2022 20:00:52 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:e5d:5870:ff9d:8701])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709026e0100b0016160b3331bsm2296170plk.305.2022.06.16.20.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 20:00:52 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 16 Jun 2022 20:00:50 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Jaewon Kim <jaewon31.kim@samsung.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        YongTaek Lee <ytk.lee@samsung.com>,
        Sooyong Suk <s.suk@samsung.com>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "avromanov@sberdevices.ru" <avromanov@sberdevices.ru>
Subject: Re: [to-be-updated]
 zram_drv-add-__gfp_nomemalloc-not-to-use-alloc_no_watermarks.patch removed
 from -mm tree
Message-ID: <YqvuYl59Gp++mB5g@google.com>
References: <20220608192933.5279DC34116@smtp.kernel.org>
 <CGME20220608192938epcas1p3eb403705cf57aa56be63a19423bbae8c@epcms1p3>
 <20220617010432epcms1p348c725abef40bfd539cc29c82a64f6ef@epcms1p3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617010432epcms1p348c725abef40bfd539cc29c82a64f6ef@epcms1p3>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Jaewon,

On Fri, Jun 17, 2022 at 10:04:32AM +0900, Jaewon Kim wrote:
> 
> 
> Dear Minchan Kim
> 
> I'm sorry but I got reported this atomic alloation failure again recently.
> I asked network develeper to implement a work around though.
> I just hope to get your signed-off if you don't mind.
> 
> Thank you
> Jaewon Kim

As I mentioned, GFP_ATOMIC allocation could be easily failed due to
reclaim constraint, the user should carry on the fallback plan.

The atomic allocation could also fail not only zram but also other
sources if they try to allocate GFP_ATOMIC.

The suggested patch could affect other existing zram workloads a lot
(which would be common than rare atomic allocation failure) so 
I don't want to accept the patch.

Thank you.
