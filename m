Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496BAC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 30 Mar 2022 05:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242009AbiC3FJN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 01:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbiC3FJM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 01:09:12 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FB3F1E9E
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 22:07:27 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t13so15407613pgn.8
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 22:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R9TnWA3sZW6Bqt+u/3+Ucy95MyFAhpwPXNi+AyhUHrw=;
        b=IdIhob+SzZW+OGCafoiDU9ZUJH+5YmkrFo2zZ/CuVYB2vup66vNHJbw+AcXCA/PN7O
         BkTJ0d1DJ+GDX6gmr1p1tuEv/fNiNEEIctAjdEC2wglH8zv+wIYiGbAcmomDtI9jIpkm
         1qAhK2jGeMH0mw9o2Lgsf5YU/qjz6CNR8GSr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R9TnWA3sZW6Bqt+u/3+Ucy95MyFAhpwPXNi+AyhUHrw=;
        b=wwAi2wyKJo1JJUHB6DZyz2QOIdA5xD55UOSzw0VktPK4KzXUjZciXKN1woM+rXZKzO
         OHsWvFh5w/oVRFDqhm9dBtva07WTifqvNAm+JTB3ZuS0Wtl660MqUQS/KveM7FU5Uvie
         m7TsL5oH2McXVuba0dXQF0qOlTjd9lq+Oc1ToyzqIrOseKKubxdH6eZ8ZNAZi/+oWciE
         r1fhvVxYVxHJaYb5XCGB426FGt/AlDVT2vnD0iaDOYSfT06vi+BjunfsmbUfvTSlCXqr
         toJF55uHaiQzLQ4ggYZ9l1rrviEMA40TMgYQzWMImJg0ARpjdkFU+2aYDmmlJtMJYNK7
         Jcvw==
X-Gm-Message-State: AOAM533MC2VKzT6rL4ySoSETMlySeIx4M9PJ6u4wCWjEz5/XOfvMlR++
        SmDt6jP1D++CLN/PvaT1Zyhjrw==
X-Google-Smtp-Source: ABdhPJzQlvPNKvUuFuC4RkLZTn4rsje855s74+PrtSBhdJsJJzRvB1SgxX06QvjbST3EivIS3oICMA==
X-Received: by 2002:a63:790d:0:b0:386:33e7:d67c with SMTP id u13-20020a63790d000000b0038633e7d67cmr4657439pgc.312.1648616846979;
        Tue, 29 Mar 2022 22:07:26 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:1719:a115:46dd:6b80])
        by smtp.gmail.com with ESMTPSA id a11-20020a63cd4b000000b00378b9167493sm17866801pgj.52.2022.03.29.22.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 22:07:26 -0700 (PDT)
Date:   Wed, 30 Mar 2022 14:07:21 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        ngupta@vflare.org, ivan@cloudflare.com, david@redhat.com,
        axboe@kernel.dk
Subject: Re: + mm-fix-unexpected-zeroed-page-mapping-with-zram-swap.patch
 added to -mm tree
Message-ID: <YkPliXgyWSEd+RvQ@google.com>
References: <20220326034321.2589FC340E8@smtp.kernel.org>
 <YkPkYmn6E7DY7EPP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkPkYmn6E7DY7EPP@google.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/03/30 14:02), Sergey Senozhatsky wrote:
> On (22/03/25 20:43), Andrew Morton wrote:
> > Two processes under CLONE_VM cloning, user process can be corrupted by
> > seeing zeroed page unexpectedly.
> > 
> >     CPU A                        CPU B
> > 
> > do_swap_page                do_swap_page
> > SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
> > swap_readpage valid data
> >   swap_slot_free_notify
> >     delete zram entry
> >                             swap_readpage zeroed(invalid) data
> >                             pte_lock
> >                             map the *zero data* to userspace
> >                             pte_unlock
> > pte_lock
> > if (!pte_same)
> >   goto out_nomap;
> > pte_unlock
> > return and next refault will
> > read zeroed data
> > 
> > The swap_slot_free_notify is bogus for CLONE_VM case since it doesn't
> > increase the refcount of swap slot at copy_mm so it couldn't catch up
> > whether it's safe or not to discard data from backing device.  In the
> > case, only the lock it could rely on to synchronize swap slot freeing is
> > page table lock.  Thus, this patch gets rid of the swap_slot_free_notify
> > function.  With this patch, CPU A will see correct data.
> > 
> >     CPU A                        CPU B
> > 
> > do_swap_page                do_swap_page
> > SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
> >                             swap_readpage original data
> >                             pte_lock
> >                             map the original data
> >                             swap_free
> >                               swap_range_free
> >                                 bd_disk->fops->swap_slot_free_notify
> > swap_readpage read zeroed data
> >                             pte_unlock
> > pte_lock
> > if (!pte_same)
> >   goto out_nomap;
> > pte_unlock
> > return
> > on next refault will see mapped data by CPU B
> > 
> > The concern of the patch would increase memory consumption since it could
> > keep wasted memory with compressed form in zram as well as uncompressed
> > form in address space.  However, most of cases of zram uses no readahead
> > and do_swap_page is followed by swap_free so it will free the compressed
> > form from in zram quickly.
> 
> Minchan, a quick question, shouldn't this instead revert 3f2b1a04f4493?

Never mind! My bad.

The patch looks good to me.
