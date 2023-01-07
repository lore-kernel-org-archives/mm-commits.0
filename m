Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A7FC46467
	for <mm-commits@archiver.kernel.org>; Sat,  7 Jan 2023 03:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjAGDcW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 22:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbjAGDcV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 22:32:21 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3323D8CD32
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 19:32:20 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id fz16-20020a17090b025000b002269d6c2d83so7122446pjb.0
        for <mm-commits@vger.kernel.org>; Fri, 06 Jan 2023 19:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hIP+kM7GAI1Azsv1pohpDHcuZ62KbjjO2qOO8ZJcNCE=;
        b=FvDve2bIcYW4vNLVKSr+HIazMKE2hiCs5p0PMCXtZmwhIfqtG8WnZ8ZGKrlvTx/s9z
         7IgJ9ki5mpLLN3tf3OxQymxiP8ZtWetWZKdP2h+vLk0cyZyNYqIFQqXkSbzJrPw3e9Cd
         1EWjvLiVl9U3GpO+xZGAqdx/f2lyWg3IpYCD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hIP+kM7GAI1Azsv1pohpDHcuZ62KbjjO2qOO8ZJcNCE=;
        b=xoTGAKPRaIyR3x4Uj66q95i//hBIPL/iN/4IfqFFVVp++XrvYfr4G6/i6Xv1zW7Xaj
         q6K+e9UbnK0ddWc7Ify/B/NqpmxhgMgWdXix6/y94q+MjETTqv7kTUyCRKVtIHNflDpQ
         1ud4s3hCdvffkllkuH74nuzVe9wp3nmEtYa5/KnoVKmIzLvDsoW0Fbd60FfQ6r5kG3os
         xGLpiNlBbkCZ0M9ZBaVlwDPkwjiOaHUKjghpTvP6XY8GIrfCrmYOjAz/2fx/5zajdjSW
         0wsGSxlEeLMBE8cE6Gf0GPoJ+htL6/PUsn+8IhFm0/rJCBc1pQ5mvkVQtYrC4p7hKjqS
         GJKg==
X-Gm-Message-State: AFqh2koXWw78r74I1GrVbJAhvpRN8qXDHl4AgXEZjQojutLIp4vFqxDI
        SNFHM3EhR6qxjX7seOFyNKSi9Q==
X-Google-Smtp-Source: AMrXdXup0pzScmt0jrTavc8DARirYFJM/3Yfrm1/821l+KwmUWm34DLgDzPDnyL8lXtjRWFZ13b90w==
X-Received: by 2002:a05:6a21:6d9c:b0:b1:dac3:37b9 with SMTP id wl28-20020a056a216d9c00b000b1dac337b9mr89229170pzb.45.1673062339784;
        Fri, 06 Jan 2023 19:32:19 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id n6-20020a170903110600b00192d9258532sm1639914plh.150.2023.01.06.19.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 19:32:19 -0800 (PST)
Date:   Sat, 7 Jan 2023 12:32:14 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        linux@weissschuh.net, hannes@cmpxchg.org, corbet@lwn.net,
        nphamcs@gmail.com
Subject: Re: +
 docs-admin-guide-mm-zswap-remove-zsmallocs-lack-of-writeback-warning.patch
 added to mm-hotfixes-unstable branch
Message-ID: <Y7jnvmoCe1zZyzsh@google.com>
References: <20230106235448.3921FC433EF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230106235448.3921FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/01/06 15:54), Andrew Morton wrote:
> Writeback has been implemented for zsmalloc, so this warning no longer
> holds.
> 
> Link: https://lkml.kernel.org/r/20230106220016.172303-1-nphamcs@gmail.com
> Fixes: 9997bc017549a ("zsmalloc: implement writeback mechanism for zsmalloc")
> Suggested-by: Thomas Weiﬂschuh <linux@weissschuh.net>
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
