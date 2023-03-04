Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AB1C61DA4
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 02:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjCDCfn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 21:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDCfm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 21:35:42 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE6E1A675
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 18:35:41 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id i10so4679624plr.9
        for <mm-commits@vger.kernel.org>; Fri, 03 Mar 2023 18:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jy8NpoZIQRG8OhKGY5bI8u6Nc53cPFIHshg9FSvK1s8=;
        b=FNzkaNukRpgEmhWy/JZ5EGoBAiZ3ILqd3e6zJuMb8yCkr9WDMFTvzYa2VmQ22xHKHZ
         vO+eupeUlvDSvvdBR6iWSn9LZe3JtA8xf49BouPLZ7Eb6dNPEW0Rabkovqzzr9anQmBD
         jTtQyC9sJnvGBdMNS4Eud/GSD1GdDIsdnlWYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jy8NpoZIQRG8OhKGY5bI8u6Nc53cPFIHshg9FSvK1s8=;
        b=uRBrbmjJUNAj2x1nuGjz/W3NRa0asEgh7cI48qyyOEv0wXEA9Bdc5UODoVgDGGzi4g
         ANlP1wF8qutVPC/kj66nSk/rHPLMzxFNdqHcBI6D6xFKiDE2SkIwbNlzy5XWuOy4Gg2A
         SVSX/qQdK/anubYFTD1RQL8BASLGCSofKeAo1INE4p+D6QS4WXujNi2lxaIkGSh7U9XM
         g5/0g7KMt9YGPXN98za4QpYQRSe9lNglEcXxy2XGPmkh+gJlJCmCsdIbtQBUVXcLkVbW
         Y0Zb3BmiXHxDwEbSD/jeOlk/wD5J+UFnPHfWnuzHxyKF4p3IbBy+0CzwVTsbiD2BSAi6
         kNZg==
X-Gm-Message-State: AO0yUKUFixnTB3YjGrZiEXSp/3cFV64sL5/NRDc4Ia8lmAI6tu0Ga71P
        lRcAMbdVRZVoDV9YSsNObICNuZSGB1Gxvqf+VGw=
X-Google-Smtp-Source: AK7set+4ltFcRGwe7JPnbdanBZoec1hmIeV1uqqahXF0OaN6/HBY7Ehd92YcIVgIpm7/ogNpnoo83g==
X-Received: by 2002:a17:902:dacc:b0:19a:9055:6658 with SMTP id q12-20020a170902dacc00b0019a90556658mr8749000plx.18.1677897340941;
        Fri, 03 Mar 2023 18:35:40 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id a16-20020a170902b59000b00195f242d0a0sm2153473pls.194.2023.03.03.18.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 18:35:40 -0800 (PST)
Date:   Sat, 4 Mar 2023 11:35:36 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        senozhatsky@chromium.org, minchan@kernel.org
Subject: Re: +
 zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix.patch
 added to mm-unstable branch
Message-ID: <20230304023536.GD5231@google.com>
References: <20230303232902.1CD39C433A0@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303232902.1CD39C433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/03/03 15:29), Andrew Morton wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix
> Date: Fri Mar  3 03:25:23 PM PST 2023
> 
> fix zs_stats_size_show() accumulation, per Yosry

[..]

> --- a/mm/zsmalloc.c~zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix-fix
> +++ a/mm/zsmalloc.c
> @@ -651,9 +651,9 @@ static int zs_stats_size_show(struct seq
>  		 * stats.
>  		 */
>  		for (fg = ZS_INUSE_RATIO_70; fg <= ZS_INUSE_RATIO_99; fg++)
> -			class_almost_full = zs_stat_get(class, fg);
> +			class_almost_full += zs_stat_get(class, fg);
>  		for (fg = ZS_INUSE_RATIO_10; fg < ZS_INUSE_RATIO_70; fg++)
> -			class_almost_empty = zs_stat_get(class, fg);
> +			class_almost_empty += zs_stat_get(class, fg);
>  
>  		obj_allocated = zs_stat_get(class, ZS_OBJS_ALLOCATED);
>  		obj_used = zs_stat_get(class, ZS_OBJS_INUSE);

This also needs to set class_almost_full and class_almost_empty to 0
for each class.

Andrew, I'll send v4 in a bit.
