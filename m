Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1415C2B9F7
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 01:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 773996141E
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 01:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhEYBvz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 21:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhEYBvz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 May 2021 21:51:55 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C9AC061574
        for <mm-commits@vger.kernel.org>; Mon, 24 May 2021 18:50:26 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id z24so29863313ioi.3
        for <mm-commits@vger.kernel.org>; Mon, 24 May 2021 18:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jq6foPNcpknD5/cV49MGEGaPoVcQUKXSqh38enXDFAs=;
        b=LLStxliAbLOqRm2IkEONMQ5K2kmp61YD3YcIGWmNdYx+n7lj+t24vm+bWh5YcqJ4M8
         IJhBw+TsAEz7kV+NYlbgsPa45D4gvjHoAQHdmSHQ/LgGcKgEeSudNDKs71yrBri9+F0C
         oJqwYr6EYBzErblR79YO4IrsZcgyxTyefRsh1pEku30MkGiSxZ5uUZH4WTo2EJuGZC08
         2UC9Kl1T4zCZu6dvUIEN1noLCkIChM/V2h6IMIuiIFfy4GpP/bMethDn6O4VKPCNNZ8J
         De+rDGq0oyFpBT/Rl8Fe9UkzzYs1qdVnTB+B1uCP1kFBxgZSgGWPw6UE1IcfDmLfe6nr
         MPyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jq6foPNcpknD5/cV49MGEGaPoVcQUKXSqh38enXDFAs=;
        b=sV4n2hDLFoibF1txYfeRTqZFzoV2O/G4qbewkgoqysL16P8iC2TKFXlTSP24izio80
         C6UhwXUEqG6JvTULXP4FbLKmrlCyc7xvxKtmLXLqrTHcjrkj+C7reNzFiViwi8V3nCLr
         4cAlGa8wuFdwBV318DUKrZyJOWmDG7p1qazEgVSu3zBavbGAEtX+SduAbWv4JZuN7tNj
         TCErK9fVt7XnlaWO+x1Qh43SXELCJvdpORcjFuSo2tYhbfeytmPnZmm7xRwbGor4POFI
         F8X55sedDJ6mDSHw/KnRP3yE7MlcCajGxn+VD9XcuWGhFRHYzRtSXs3riB7xH6flGcT4
         lp4w==
X-Gm-Message-State: AOAM53075cRmK8bnbQlO+YmNuxbgJVpYfjr48wsbb6FRlR8gSZPhN0YE
        FgeZ5u06rVvl2THPMyS0eF0kwoOjg5ziHFzaafSs1MDZPq8=
X-Google-Smtp-Source: ABdhPJzhrzMGwhFSx24IrIsvlPLC/zmBdUjwLFGwBH5lnEVnALwJYSTKPwMZcvJkqzOrEYAS3TFsKYJ8pHpINwX/mGw=
X-Received: by 2002:a5d:8485:: with SMTP id t5mr17636481iom.89.1621907425568;
 Mon, 24 May 2021 18:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210522195522.cR9W0GMvY%akpm@linux-foundation.org>
In-Reply-To: <20210522195522.cR9W0GMvY%akpm@linux-foundation.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 24 May 2021 18:50:14 -0700
Message-ID: <CAMn1gO73JghWC4KR3+T+=3+CYa1xnR1_UE0K-05JRTmdwjYUEA@mail.gmail.com>
Subject: Re: [failures] mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, khalid.aziz@oracle.com,
        kirill.shutemov@linux.intel.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        rppt@linux.ibm.com, walken@google.com, ying.huang@intel.com,
        zi.yan@cs.rutgers.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, May 22, 2021 at 12:55 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
> has been removed from the -mm tree.  Its filename was
>      mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
>
> This patch was dropped because it had testing failures

Hi Andrew,

Do you have a link to more information about these testing failures? I
don't think I received anything. Or is this about the uffd issue
reported by Peter Xu? I have a fix for that which I'll include in v4,
together with a switch from page_refcount to page_count to fix an
issue reported off-list.

Peter
