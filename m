Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E7BC63697
	for <mm-commits@archiver.kernel.org>; Tue, 17 Nov 2020 06:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72DFE221FD
	for <mm-commits@archiver.kernel.org>; Tue, 17 Nov 2020 06:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hob4BGb4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKQGRh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Nov 2020 01:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgKQGRg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2020 01:17:36 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC8BC0617A6
        for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2020 22:17:36 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id n11so18435536ota.2
        for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2020 22:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=XS8dxxvzXqHyhSnJeYWiMmMdvaRFstVe2miK9SNdJ8A=;
        b=Hob4BGb4uJ/2tg2eIVEKPsyCU5Ghz1ujqJpPBWjC1k1O8iaxGv1C5PZSDOFkj79XH0
         LPGbskncFA/yubrHVib8oPdx8/6gmeqgvTvql9DauuQkf/m8ulmZMjk20GBGcOvN+HN8
         hDqAvTFY8FvrG6mbY4WZ8iZ1nJ+n5HPrdLBe0SpEqN0pTZpwlgJQJQk/WAPYvY7wiaKO
         bg3AHmVMaosAX9tGC2egkoGe8omiEDmgQvJt6YOIJcHATDizC+LPHKpl0jNHyAChkjcU
         N6RbbwM2Naiv+YLonq5NHGjNbkZ8L3ECr+XvMQHP5V0WIwXd/ez0EH9ZSChhWV9fOgYg
         z9kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=XS8dxxvzXqHyhSnJeYWiMmMdvaRFstVe2miK9SNdJ8A=;
        b=n+YZSzPpHSZ1IlE3Z/aABJNlOYTYKnyrdIS5P8sQ6iGRdtafM9SV3LYfv/lQod7U/f
         AJDoEBrIiww4mYcmfQYSU8UYYVCocGt1o7Q/5ao4stamYK0Nc8u1ftGkLS9iH4cbXRtu
         xbxOAARjIh02ZzZCsD8NDo62Ct3/DIwwxTMu2WuZUAlbNWR45OwJ7qLZnI9EgIFOtTj0
         ds8E9wr5e0OV0q31USGMOD6zb30D8Bak0xJsSPrAuza+LrWDH6oma5C605EALgKq7Gjr
         Q24Vp/TQ20gou8Ea9x530925m8oAMIUfCOyPDxJgw9g9otinRQfP1besjW5vW1bXR7yN
         gCoQ==
X-Gm-Message-State: AOAM5332XW2gOxmlc8lGGdPSVsddUHIGMEIM+RYEReN8rNO/rBTN7QyN
        6y7XNi3l8Or8IUb9Dr7KzMbpjQ==
X-Google-Smtp-Source: ABdhPJylatU3dtHMrFCyVFB6nlBVDHBkl3BMnWrz6zItu1ISz+YO2VszqoQi0UPXzC14Yo8YOXZY3Q==
X-Received: by 2002:a9d:27e8:: with SMTP id c95mr2057356otb.262.1605593855434;
        Mon, 16 Nov 2020 22:17:35 -0800 (PST)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id v8sm5861847ooh.6.2020.11.16.22.17.33
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Mon, 16 Nov 2020 22:17:34 -0800 (PST)
Date:   Mon, 16 Nov 2020 22:17:20 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
cc:     hughd@google.com, mm-commits@vger.kernel.org, sh_def@163.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: + mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
 added to -mm tree
In-Reply-To: <20201116230526.NkEfmeDCH%akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.2011162149210.1082@eggly.anvils>
References: <20201116230526.NkEfmeDCH%akpm@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 16 Nov 2020, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/shmem: use kmem_cache_zalloc in shmem_alloc_inode()
> has been added to the -mm tree.  Its filename is
>      mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Hui Su <sh_def@163.com>
> Subject: mm/shmem: use kmem_cache_zalloc in shmem_alloc_inode()

Andrew, Stephen, please revert this untested "cleanup" from your
trees a.s.a.p: it's a disaster for anyone using shmem/tmpfs.

> 
> in shmem_get_inode():
> new_inode();
>   new_inode_pseudo();
>     alloc_inode();
>       ops->alloc_inode(); -> shmem_alloc_inode()
>         kmem_cache_alloc();
> 
> memset(info, 0, (char *)inode - (char *)info);
> 
> So use kmem_cache_zalloc() in shmem_alloc_inode(),
> and remove the memset in shmem_get_inode().

I could not follow that argument at all.  The shmem_inode_cachep
uses a constructor, and the memset shown is of only a portion of
the whole inode.  zeroing the entire inode quickly crashes the
kernel, after showing errors.

(If you're lucky enough to have a readable display at that point:
I did not, but got on better with framebuffer than drm/i915; and
I wonder if there's a separate bug in that area too, because fixing
this shmem issue is not enough to get my drm/i915 rc4-mm1 booting.)

> 
> Link: https://lkml.kernel.org/r/20201115174026.GA365412@rlk
> Signed-off-by: Hui Su <sh_def@163.com>

NAK.  Hui Su, please test your "cleanups" before sending them.

I'm sorry for being slow to respond, but the priority appeared
to be to get Matthew Wilcox's series running reliably, so I had not
got around to checking the less urgent shmem patches before they
slipped into mmotm - there may well be more that I want to NAK,
but this is the dangerous one.

Thanks,
Hugh

> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/shmem.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/mm/shmem.c~mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode
> +++ a/mm/shmem.c
> @@ -2331,7 +2331,6 @@ static struct inode *shmem_get_inode(str
>  		inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
>  		inode->i_generation = prandom_u32();
>  		info = SHMEM_I(inode);
> -		memset(info, 0, (char *)inode - (char *)info);
>  		spin_lock_init(&info->lock);
>  		atomic_set(&info->stop_eviction, 0);
>  		info->seals = F_SEAL_SEAL;
> @@ -3851,7 +3850,7 @@ static struct kmem_cache *shmem_inode_ca
>  static struct inode *shmem_alloc_inode(struct super_block *sb)
>  {
>  	struct shmem_inode_info *info;
> -	info = kmem_cache_alloc(shmem_inode_cachep, GFP_KERNEL);
> +	info = kmem_cache_zalloc(shmem_inode_cachep, GFP_KERNEL);
>  	if (!info)
>  		return NULL;
>  	return &info->vfs_inode;
> _
> 
> Patches currently in -mm which might be from sh_def@163.com are
> 
> mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
> mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
> mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch
> mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
> mm-compaction-move-compaction_suitables-comment-to-right-place.patch
> mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
> acctc-use-elif-instead-of-end-and-elif.patch
> mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch
