Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2441C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 30 Mar 2022 05:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242690AbiC3FES (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 01:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242686AbiC3FER (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 01:04:17 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2687CFB96
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 22:02:32 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p17so19500305plo.9
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 22:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q85yzQxuckTI85t4cJc6DzVDpQWWYMYpPgEAz27AZ68=;
        b=ZHB4+/xxhnaUd9srMjdIbuyk3a2PTfBvLvGAfiBjML6/F3kNlVnSuQW/XM+IzgUwbY
         5/NhAggjA+JF2LrMbYNU0lxeZapTt/wS0JljVhTU2i2oWKUpxI0lxEbsL585kyDCCiUG
         wX4xh6bQKFgWZjJI2nBt95FnpSNviAw4BfWG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q85yzQxuckTI85t4cJc6DzVDpQWWYMYpPgEAz27AZ68=;
        b=ncncYsexfgnAMzA+UyV5IH8PwX1BuZ94bYm7tKojHWkE6+wwclt8mSWvXj+OvNzAr6
         ljkmSsXcNbVzio71uUyK738R8yeh8eDEjji3EIQApp/7+EJrQ/++vI796jRTHQmcT7Tu
         3j0rHV8aezlqhz757K1RA+WItLELlILmBDIkiguI+PWL/ohFqmBXsShm96wUy0QtZBF5
         FPzhvDgjp+2O0rS7y7bbjx5a21bTGOZuBojE5+6arkKLDmzKtbgKdmYaCA3lIZpQT78q
         462gUFFclpSukbFTMGmHdUgGxtzy28gIuNLNREaep8f+oNMVxX+quUThQHvTYdcP+s0i
         G9UQ==
X-Gm-Message-State: AOAM533qEuktgdr0f1XTB+tzAd5qWAdQLqu0XQAcNTKDZsO4XBrRB5Lz
        9EqjS7Tya+JmZvp2UH6mrpaUyA==
X-Google-Smtp-Source: ABdhPJynLoJHDRoNgTS6HubmG1wyKYpNp3nof3cTY8dxxZLdxGtQyIunL3E09HMqA82pa808/H7T4Q==
X-Received: by 2002:a17:902:d4cf:b0:154:2416:218e with SMTP id o15-20020a170902d4cf00b001542416218emr32897719plg.60.1648616552074;
        Tue, 29 Mar 2022 22:02:32 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:1719:a115:46dd:6b80])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090aa40800b001c6ccb2c395sm4524541pjp.9.2022.03.29.22.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 22:02:31 -0700 (PDT)
Date:   Wed, 30 Mar 2022 14:02:26 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        senozhatsky@chromium.org, ngupta@vflare.org, ivan@cloudflare.com,
        david@redhat.com, axboe@kernel.dk, minchan@kernel.org
Subject: Re: + mm-fix-unexpected-zeroed-page-mapping-with-zram-swap.patch
 added to -mm tree
Message-ID: <YkPkYmn6E7DY7EPP@google.com>
References: <20220326034321.2589FC340E8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220326034321.2589FC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/03/25 20:43), Andrew Morton wrote:
> Two processes under CLONE_VM cloning, user process can be corrupted by
> seeing zeroed page unexpectedly.
> 
>     CPU A                        CPU B
> 
> do_swap_page                do_swap_page
> SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
> swap_readpage valid data
>   swap_slot_free_notify
>     delete zram entry
>                             swap_readpage zeroed(invalid) data
>                             pte_lock
>                             map the *zero data* to userspace
>                             pte_unlock
> pte_lock
> if (!pte_same)
>   goto out_nomap;
> pte_unlock
> return and next refault will
> read zeroed data
> 
> The swap_slot_free_notify is bogus for CLONE_VM case since it doesn't
> increase the refcount of swap slot at copy_mm so it couldn't catch up
> whether it's safe or not to discard data from backing device.  In the
> case, only the lock it could rely on to synchronize swap slot freeing is
> page table lock.  Thus, this patch gets rid of the swap_slot_free_notify
> function.  With this patch, CPU A will see correct data.
> 
>     CPU A                        CPU B
> 
> do_swap_page                do_swap_page
> SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
>                             swap_readpage original data
>                             pte_lock
>                             map the original data
>                             swap_free
>                               swap_range_free
>                                 bd_disk->fops->swap_slot_free_notify
> swap_readpage read zeroed data
>                             pte_unlock
> pte_lock
> if (!pte_same)
>   goto out_nomap;
> pte_unlock
> return
> on next refault will see mapped data by CPU B
> 
> The concern of the patch would increase memory consumption since it could
> keep wasted memory with compressed form in zram as well as uncompressed
> form in address space.  However, most of cases of zram uses no readahead
> and do_swap_page is followed by swap_free so it will free the compressed
> form from in zram quickly.

Minchan, a quick question, shouldn't this instead revert 3f2b1a04f4493?
