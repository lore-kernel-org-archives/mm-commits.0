Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE4FC56202
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F04220770
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RXOZcqju"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgKZA6I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbgKZA6I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Nov 2020 19:58:08 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659D1C0613D4
        for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2020 16:58:08 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id h21so493613wmb.2
        for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2020 16:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=57+EcW7c2xCJutBhLjxYuau1pXPOx0MfE5kNe/xXc3w=;
        b=RXOZcqjuSlFBEkP/KtwjZ6UQSVTfb+z6phjGuLpnxi6gkPhIG2vdvhr6rjkjlOdpp3
         ncaU52UWKqgptH8BIRJE6L6kULCpQDlWTD2Ybt6k84wXR25PJ21oqtqOZzznd8nOW5Da
         0wuokdCD2Kq5G4KKV9eXdVmgF4rPbufztgOO0GyvKlVRLXcP2drT/lDtmhN5IRxgP77D
         dbYJdLlW+usZYHVlaptSLbLqVdL1yqrkVKtuOPkGixD26880EdDelD5by9XoiyMkSOMC
         l5jdioC9R9zbkA4o6RhBmQSN5VJLqHDBACdgAhHXF+0mKoZLIMkRnC8/C9xactgC+Hz0
         JF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=57+EcW7c2xCJutBhLjxYuau1pXPOx0MfE5kNe/xXc3w=;
        b=nSF1LZ1U+8Om+Bu0Ma4pvesiirF/DUO3iBqZouse9CacpLRcUAKcy0dHUrI2KjirYZ
         wPUdjmKnb1cl5WpWTnGqIs+YzzRA0qj6TOiou8XQwX9+8KdrEwWFFCR1B0SVuo3YNip2
         RR4TuvkPrA6Ob8V6qKzBoMhMu7OcWBFsw5PvV7WT/0IXFvh+ndRTcg0CDkZyfmM0tbXz
         PJx/V5cP5xZcDf9l52rX3jRatsEOcTzU1Lz3E84uYqXEdfuNRyntPFCv4+2B7DgFEce2
         xKVoUTQIVJp5T1LH5SiMIU1wIbYoL9noWaGydey4BCz1gjkxvk+QzA3bFIlXjeI0OqLq
         tSXA==
X-Gm-Message-State: AOAM532jdOpOo5RkQILagQF4SFQuqOoqcl2GrTNQ19CjLNqlYOfEez0B
        R7u+jtPCAX0ckp6BDyZse0fvCuexIR1CeNmtQGeRdA==
X-Google-Smtp-Source: ABdhPJyXQ1UWG767fLB5o9HnJIrjMRZ4v5XT/h2ohov4nlx3OBwLlPEHZTq47h1nShsa6HgyjEtpMDj+9QBkPAptZSo=
X-Received: by 2002:a7b:c3d5:: with SMTP id t21mr345421wmj.37.1606352286916;
 Wed, 25 Nov 2020 16:58:06 -0800 (PST)
MIME-Version: 1.0
References: <20201126001651.7AB-fqk3c%akpm@linux-foundation.org>
In-Reply-To: <20201126001651.7AB-fqk3c%akpm@linux-foundation.org>
From:   Hugh Dickins <hughd@google.com>
Date:   Wed, 25 Nov 2020 16:57:40 -0800
Message-ID: <CANsGZ6ZnM0Uy1fuFTYU9q-q0PFSVDtu=QDisgWTPXvwzFGyDpg@mail.gmail.com>
Subject: Re: + mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     dchinner@redhat.com, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        mm-commits@vger.kernel.org,
        William Kucharski <william.kucharski@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yang Shi <yang.shi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Nov 25, 2020 at 4:16 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm-truncateshmem-handle-truncates-that-split-thps-fix-fix
> has been added to the -mm tree.  Its filename is
>      mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-truncateshmem-handle-truncates-that-split-thps-fix-fix
>
> fix page unlocking, per Hugh
>
> Link: https://lkml.kernel.org/r/CANsGZ6a95WK7+2H4Zyg5FwDxhdJQqR8nKND1Cn6r6e3QxWeW4Q@mail.gmail.com
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: William Kucharski <william.kucharski@oracle.com>
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/shmem.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/mm/shmem.c~mm-truncateshmem-handle-truncates-that-split-thps-fix-fix
> +++ a/mm/shmem.c
> @@ -962,7 +962,10 @@ static void shmem_undo_range(struct inod
>                                 if (index > end)
>                                         end = indices[i] - 1;
>                         }
> +               } else {
> +                       unlock_page(page);
>                 }
> +

Thanks for bearing with the gmail, and I can't read this clearly in gmail,
but I think I have deceived you into misplacing that:
it should end up as

                        if (!unfalloc || !PageUptodate(page)) {
                                blah blah blah
                        } else {
                                unlock_page(page);
                        }

>                 index = indices[i - 1] + 1;
>                 pagevec_remove_exceptionals(&pvec);
>                 pagevec_reinit(&pvec);
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org are
>
> kthread_worker-document-cpu-hotplug-handling-fix.patch
> mm.patch
> mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
> mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
> mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
> mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
> mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
> lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
> ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
> lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
> resource-fix-kernel-doc-markups-checkpatch-fixes.patch
> linux-next-rejects.patch
> linux-next-git-rejects.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
>
