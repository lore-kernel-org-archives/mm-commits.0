Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130A7C11F64
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 14:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9D246141F
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 14:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhGAO6O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jul 2021 10:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhGAO6O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2021 10:58:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D36BC061762
        for <mm-commits@vger.kernel.org>; Thu,  1 Jul 2021 07:55:44 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p17-20020a17090b0111b02901723ab8d11fso4114994pjz.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Jul 2021 07:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eJQhk3uEL98zPf3pJBp+kxoy122ICJrRC9Whg+JhjOg=;
        b=WeBa1DuP247mVLYDg5bSzF0QuwvUWIKLJwEr9BhCj846FUPTslnZaQcz9KLBdmPVAR
         9gsK5aAG67OcKg/v3sZHucgHKRc87Q3ZIRekrrUTZ4cBdxVq4amvMNHyh/oCuB3dGP4z
         viCPlh8TmOYOcjCde3llIy7yiWEHlxVF2TVEire/MA7KUXVU2wfc0nj7jVLjb2ntwwfu
         NhI63RdbLmTWBMpVG606Dw32rP7S4/fAdr+fLqt7tiga73mL0Sr4zKGEYhUkP5cvyntT
         LK61yKeNtPbLlfLIzDlO5s32co9IwJTOVdLI5Qp2fWttEjM/0tAY5Sg+pnXUSkkga4Kn
         2iOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=eJQhk3uEL98zPf3pJBp+kxoy122ICJrRC9Whg+JhjOg=;
        b=rvfl0FjrEn3Yms8h2/DVp6ytz41208A67qYwUFSElcLJJRRLybVH6IXBLSSbI+W3Lx
         dXOkbV2/VtlP3aBSjvRU/9IlqlpTY/epQ3aEsqe4SBxIhWlfqRUsjTxZM2zXV7FN/5YL
         ZjWY9cZUAtFqK2n6AYyWhOYfqrjDjF8xcxfwUgAILIonXca9ieKfALdrZoUeCrs6x+1P
         IBBIkuRkgThYF0HJ6lYfpWod/i7j1W+LiOGtAi9+sSqq8gTSBu0SYY0NTqkU0xnARrDb
         JdrCEjXnGtOHg4q5/3J9Dd6RWb2oteU90ZrZO0j8mNYp77PENdGlVbETMewfgHtplNqA
         fs9A==
X-Gm-Message-State: AOAM531pSkmsER6w0+UXzvtJ4kOITz+ZjxitEBRBZ1c0je0oLa84EWgg
        ESeTvipfdmenu8o+Wx5gZ0qwlDw3H0I=
X-Google-Smtp-Source: ABdhPJz46RQN7SPmSLFVqzlpyQKQhq35ocG1qVDPlCjG2MK0CcZGI+45dvkeev9DIZR0pdMssdJB9g==
X-Received: by 2002:a17:903:18d:b029:128:d71a:4773 with SMTP id z13-20020a170903018db0290128d71a4773mr89799plg.76.1625151343585;
        Thu, 01 Jul 2021 07:55:43 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:e476:fcd4:d1bf:22a2])
        by smtp.gmail.com with ESMTPSA id y7sm229507pfi.204.2021.07.01.07.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 07:55:42 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 1 Jul 2021 07:55:41 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org, torvalds@linux-foundation.org,
        zhaoyang.huang@unisoc.com
Subject: Re: [patch 108/192] mm: zram: amend SLAB_RECLAIM_ACCOUNT on
 zspage_cachep
Message-ID: <YN3Xbdc9N81PIegK@google.com>
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015258.BrxjIzdE1%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701015258.BrxjIzdE1%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 06:52:58PM -0700, Andrew Morton wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> Subject: mm: zram: amend SLAB_RECLAIM_ACCOUNT on zspage_cachep
> 
> Zspage_cachep is found be merged with other kmem cache during test, which
> is not good for debug things (zs_pool->zspage_cachep present to be another
> kmem cache in memory dumpfile).  It is also neccessary to do so as
> shrinker has been registered for zspage.
> 
> Amending this flag can help kernel to calculate SLAB_RECLAIMBLE correctly.
> 
> Link: https://lkml.kernel.org/r/1623137297-29685-1-git-send-email-huangzhaoyang@gmail.com
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Sorry for the late. I don't think this is correct.

It's true "struct zspage" can be freed by zsmalloc's compaction registerred
by slab shrinker so tempted to make it SLAB_RECLAIM_ACCOUNT. However, it's
quite limited to work only when objects in the zspage are heavily fragmented.
Once the compaction is done, zspage are never discardable until objects are
fragmented again. It means it could hurt other reclaimable slab page reclaiming
since the zspage slab object pins the page.

> ---
> 
>  mm/zsmalloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/zsmalloc.c~mm-zram-amend-slab_reclaim_account-on-zspage_cachep
> +++ a/mm/zsmalloc.c
> @@ -328,7 +328,7 @@ static int create_cache(struct zs_pool *
>  		return 1;
>  
>  	pool->zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
> -					0, 0, NULL);
> +					0, SLAB_RECLAIM_ACCOUNT, NULL);
>  	if (!pool->zspage_cachep) {
>  		kmem_cache_destroy(pool->handle_cachep);
>  		pool->handle_cachep = NULL;
> _
