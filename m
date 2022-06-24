Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02990C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 06:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiFXGIC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 02:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiFXGIB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 02:08:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38E55F4A
        for <mm-commits@vger.kernel.org>; Thu, 23 Jun 2022 23:07:58 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id n12so1740971pfq.0
        for <mm-commits@vger.kernel.org>; Thu, 23 Jun 2022 23:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RnclWShF+rfwpyddxUlZEYgwqXUSCG0VE+dNsxzVWTQ=;
        b=CaCv6dTRLoo5An4/Z2beuHRCL+/+km0Q40IxDth3I1MjenOcUa6jFuK7xA77wv5ubt
         aCZwfBQkaQoElHxWuth5+zXCHavzF4SmXJNcpjpw2gzpgTy4ixLpeEAryGqNNTT5KjoC
         ugGsAKv64w8P1+Cr9BCAeQMzmthqqn00+AAic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RnclWShF+rfwpyddxUlZEYgwqXUSCG0VE+dNsxzVWTQ=;
        b=v6FBMwDz/6olV+9gvOrlGkXmdjrBycvEd4bSKlQrfNq6HvcIpC/3BplfHvlsyE7L4m
         72xdoo+ZZwKWMRriTrMVr71yOF2h5/q4u5fi9bZpCoXIZYMnZ4foE4Js4F1I9pvJWVnS
         gVA11Pzq3U8gWdkmnWp6VjwQn5EO0LXPnwcL4aZnabwxiECNlJ0HUmtRxS1AdsQGoG8i
         LKBlpTuHMPSYM7+4m15WXy/clowWMxEmkJbzHgOd4b8haX9VYS8ByNDyVSaekhe2JbXR
         Mjhbx52Cton3vz7rm7NkwRbwKEN42s1IGhrtkolWOKPk295pMoBartNKo/swfjTGZgSa
         RTmA==
X-Gm-Message-State: AJIora+L4dbe8q1gOaT8VQYP0zN25Vkji3aLGA760uA6GNxu9lqDs3sq
        BUfK4nX5RqmzxPjcVPGLFewK2mOJ/bzg1A==
X-Google-Smtp-Source: AGRyM1t2q2o1MtUwxMgrDSNYVKoiMo8Oqfj61j6ZEGYZ++emcSQVsxKAxxlgpojhrqoaQQSlqAnYRw==
X-Received: by 2002:a05:6a00:1584:b0:51c:7932:975a with SMTP id u4-20020a056a00158400b0051c7932975amr44550859pfk.80.1656050878199;
        Thu, 23 Jun 2022 23:07:58 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:421d:f075:63ad:7026])
        by smtp.gmail.com with ESMTPSA id a23-20020aa79717000000b0051c03229a2bsm730791pfg.21.2022.06.23.23.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:07:57 -0700 (PDT)
Date:   Fri, 24 Jun 2022 15:07:53 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org
Subject: Re: + zram-do-not-lookup-algorithm-in-backends-table.patch added to
 mm-unstable branch
Message-ID: <YrVUuZsO/16tGjzS@google.com>
References: <20220622192241.739B4C34114@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622192241.739B4C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/06/22 12:22), Andrew Morton wrote:
> The patch titled
>      Subject: zram: do not lookup algorithm in backends table
> has been added to the -mm mm-unstable branch.  Its filename is
>      zram-do-not-lookup-algorithm-in-backends-table.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-lookup-algorithm-in-backends-table.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 

Andrew, I sent v2 of this patch. Added code comment and put some more info
into commit message.

Message ID: 20220624060606.1014474-1-senozhatsky@chromium.org
