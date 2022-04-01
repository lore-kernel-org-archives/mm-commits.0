Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7141AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 02:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbiDAChX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 22:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244119AbiDAChW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 22:37:22 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408BB6B093
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 19:35:34 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2db2add4516so18732217b3.1
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 19:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hP5WWbtuGsDWD55Jj1fJetObaJLNZPB0A2WU8y815mk=;
        b=KlS+WfsrxHOGjj/wuqJYnZZs3aOBAx/NWdN3gL52r0AFeXinukZIQfaG+OYPnGYxWT
         yNUt4av6z1vSvpb92Jrhi55LgsILie34OWfemWzoO6PDtZXNg5Jg/aP206SWlRCRJvCB
         TmWwFo1HpDv9/rZxkJjwIfF7fkvYcLMXo9ZxKVewn8GBsTEtG6UW3A8N4/zS6SQIgMiy
         nwbGCtMSlnTOtHQBDNeD4InOeafToFyqdtL829i2Kpcq9S990DC08ofHFTt6iMeiykLw
         aq4efU7AjAzWSr6b5K/t3w6FdCeGcsWpkOV7J4TF+MYs96Db+qIUckfuwz5tpD833MKh
         Zhjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hP5WWbtuGsDWD55Jj1fJetObaJLNZPB0A2WU8y815mk=;
        b=HeW1jXPzE3Qs0IGkp7Cw068vqSxW9LGOGX2YpDIrEBenKJrndStRkWedgiM8P95Uo8
         DzWWMq4NRERD8X0etEvVt7FUw9IrEidlI84KvbmBu1FMja36SDkndQn4q8vFL75vFk7L
         YuB9S4Et67pBmsMdwpwXdxr8FPVot7R15h+BV+6tyYPTEwCgux5dZj70tMMJrzq1FXfE
         NIzD+2NM8YtsMce7hcDoi5X77eo8Xuj3+QtpJKLYhyE2g6PV9kdFC/805J/HUfSs7e0u
         QufADYcXBYgooHG/RQpkFqfL5xrV0eup5p5FOymwiMonl71AWeTBov1bz6voTdkQUGJz
         PYNg==
X-Gm-Message-State: AOAM5336SEAhZ0+sDBYuWEWhNo94EZP2uxMFWMypAEkSEaHiwjtJAuVO
        cwT4VwURhsKwkUDtqReJyYdU+IWS5U75LRycxdvhhyJxa7/mwQ==
X-Google-Smtp-Source: ABdhPJy/Cd4NfcSEkXGEVNwceKKy0igmNxqURdW8EhM3BQTMzIAr2N3sFThjeSG9q5kGNgljAU2gvcOY6pS3/Vl2m2s=
X-Received: by 2002:a81:1c4f:0:b0:2e5:9db3:7a8e with SMTP id
 c76-20020a811c4f000000b002e59db37a8emr7433298ywc.319.1648780533468; Thu, 31
 Mar 2022 19:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220401022700.1C58DC340F0@smtp.kernel.org>
In-Reply-To: <20220401022700.1C58DC340F0@smtp.kernel.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Fri, 1 Apr 2022 10:34:57 +0800
Message-ID: <CAMZfGtUVoP_2CTkvJwhfj+F7e9z_6sgMcsN4XgtHa8vKwcFaEQ@mail.gmail.com>
Subject: Re: + nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 1, 2022 at 10:27 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: nfs42: use a specific kmem_cache to allocate nfs4_xattr_entry
> has been added to the -mm tree.  Its filename is
>      nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch
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
> From: Muchun Song <songmuchun@bytedance.com>
> Subject: nfs42: use a specific kmem_cache to allocate nfs4_xattr_entry
>
> Fixes a null-pointer deref in nfs4.
>
> If we want to add the allocated objects to its list_lru, we should use
> kmem_cache_alloc_lru() to allocate objects.  So intruduce
> nfs4_xattr_entry_cachep which is used to allocate nfs4_xattr_entry.
>
> Link: https://lkml.kernel.org/r/164876616694.25542.14010655277238655246@noble.neil.brown.name
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Tested-by: NeilBrown <neilb@suse.de>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

My bad. I think this patch could be dropped.  I have looked at
the latest code. I found the following commit has removed
GFP_ACCOUNT on allocation.

5c60e89e71f8 ("NFSv4.2: Fix up an invalid combination of memory
allocation flags")

But this commit forgot to remove SLAB_ACCOUNT when creating
nfs4_xattr_cache_cachep (I think it is a bug).  So I think the following
patch could work properly.  I'll send a new patch to fix this issue.

Thanks.

diff --git a/fs/nfs/nfs42xattr.c b/fs/nfs/nfs42xattr.c
index ad3405c64b9e..e7b34f7e0614 100644
--- a/fs/nfs/nfs42xattr.c
+++ b/fs/nfs/nfs42xattr.c
@@ -997,7 +997,7 @@ int __init nfs4_xattr_cache_init(void)

        nfs4_xattr_cache_cachep = kmem_cache_create("nfs4_xattr_cache_cache",
            sizeof(struct nfs4_xattr_cache), 0,
-           (SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|SLAB_ACCOUNT),
+           (SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
            nfs4_xattr_cache_init_once);
        if (nfs4_xattr_cache_cachep == NULL)
                return -ENOMEM;
