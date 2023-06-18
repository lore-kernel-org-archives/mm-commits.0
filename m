Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D130EB64D7
	for <mm-commits@archiver.kernel.org>; Sun, 18 Jun 2023 04:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjFREOi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 18 Jun 2023 00:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjFREOi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 18 Jun 2023 00:14:38 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5451BB
        for <mm-commits@vger.kernel.org>; Sat, 17 Jun 2023 21:14:37 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b543f7e53aso9534165ad.1
        for <mm-commits@vger.kernel.org>; Sat, 17 Jun 2023 21:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687061677; x=1689653677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k+T4VegcziDXP6WxPL43UZa0+QDyLCa0W391ZLiS3Xo=;
        b=EHRdT93vOpKYtD59O2vOi2bO+Hrv6jjQ9kukKA+b0zSSBaw5isR9NjiyXu7Y+UbD6c
         5EI+klnx3bh4XHYIqV8dsQkg8J3aKFqS9DzEVDUq/XHsw71w5ggwRbacvxm8vtDRlLQj
         34TI42/l3/nN4ZAdBnachiebD+9NDkzM0MmjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687061677; x=1689653677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+T4VegcziDXP6WxPL43UZa0+QDyLCa0W391ZLiS3Xo=;
        b=DSJYmuXCFe01d25o3kl7yQAZTbbIxNbbp9pr5PF0QQnNa9bD1pkkVZbE3FCXnArNfd
         bXrpEIVbQE7BIBwT+2jJhEc918uBv7p5QP++nwLzpD0tx/mSQi0wc5PM3jOLiwdG0j1u
         FuTyNf6MXm1Pc+XXnPD8JAnQgecDgEppqbayM9BWPbL5CHgkRXLkYDMIYlAMGjl94HsQ
         4s91tzNpzdWNIO1VZl+SmvVJSegTSWI2rZDOFxOwjnnRkv/a2PXP3u97o2smA5q3gudv
         AI5L5U1gS9hsNONxSO0p5higVszxM59SqaSYvCiTFwoP7Nbahh9rq4Jj26aw78txbyFX
         Bl3w==
X-Gm-Message-State: AC+VfDy7SEgFA9y/QiTwJjX4Hq0/8JbWpfARp3aX5ZTv4939IjEhKaH0
        VBpaYH876f0CIi69UKWxGxyFVg==
X-Google-Smtp-Source: ACHHUZ4jFWLwUP1J0b3eyop636gMdMkUc3eWLUtnnKSKWsPU+8xA3y+MKOQL6hF1f2GT2bO3IHh4bA==
X-Received: by 2002:a17:902:d4c3:b0:1ab:eee:c609 with SMTP id o3-20020a170902d4c300b001ab0eeec609mr8536118plg.40.1687061676751;
        Sat, 17 Jun 2023 21:14:36 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id c19-20020a170902c1d300b001acad024c8asm1032700plc.40.2023.06.17.21.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 21:14:36 -0700 (PDT)
Date:   Sun, 18 Jun 2023 13:14:31 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com
Subject: Re: + mm-zswap-remove-page-reclaim-logic-from-zsmalloc.patch added
 to mm-unstable branch
Message-ID: <20230618041431.GB2417543@google.com>
References: <20230612205130.91CF4C433EF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612205130.91CF4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/06/12 13:51), Andrew Morton wrote:
> Subject: mm: zswap: remove page reclaim logic from zsmalloc
> Date: Mon, 12 Jun 2023 11:38:12 +0200
> 
> Switch zsmalloc to the new generic zswap LRU and remove its custom
> implementation.
> 
> Link: https://lkml.kernel.org/r/20230612093815.133504-5-cerasuolodomenico@gmail.com
> Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Tested-by: Yosry Ahmed <yosryahmed@google.com>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
