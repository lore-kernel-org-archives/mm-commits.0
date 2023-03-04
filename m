Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA87C61DA4
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 02:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCDCEm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 21:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDCEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 21:04:42 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652DB13DDC
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 18:04:41 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id n5so2664695pfv.11
        for <mm-commits@vger.kernel.org>; Fri, 03 Mar 2023 18:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hh1fbC64KDRTF5qNzX+BdGA3Z86D2DKyGMlwoGrcKUM=;
        b=PlB3LlK8hwLzrcFl7DLZlBU9Uqxc2o47EZk1htqOM4oz+mSIgql5JmZOO4AuxsQW/k
         mQe7+y1AsSAK8LuldvMNBjViO0OSLW1SKlE1hi8oY/SE8aylqkeNE2Cpw0MpS4hKPs++
         FM4vgc3OeGgB8tk0c4Bp7aGceElefowr4Hrj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hh1fbC64KDRTF5qNzX+BdGA3Z86D2DKyGMlwoGrcKUM=;
        b=afVwYp9n6jmcCI9J345ivfxzByaNZASUPTJVUWku3jXXaEqvx9nLQaKIdorNR+/dBf
         i5F1MWRUwaAtMsQGDrTVcNsgNBJjX444GitGNdQ0qJZTYZWh2wN+avzaqh25rkgbxq08
         aLKrnzNJxrTdwiocX+I6S7aq9xlSOLcOcmJGXZNg8Ei5ZPhkfiCurR5mRHjik2UviX2H
         esBBy8m6zmRAkiqLM5oioZvMegRsAFzLN8TLiXR/Uc1Qudm+ZaPOPey9pnx18thcsTsc
         zfXPRpTMHZYvR0PoVXf4zIidTA8q7Tf1ZPpnSqhae42NvP+G29X1OU5AKcAS5j3hPicw
         EbSQ==
X-Gm-Message-State: AO0yUKWnFvYhWN8wmjdOUkptGK+huNFmZGdiC2rUaWrAZJMXt5w/SqMD
        M21LwG0/jy6cNLLv7FDVLxrC4AVXMgNfJmdtFgs=
X-Google-Smtp-Source: AK7set83c8BaScOn7WoKieMrn9jxOVeRMtJmKIPSpbtwwacVanDMvIi/4hAbN9RWEOJSP5V7lF9bAA==
X-Received: by 2002:a05:6a00:13a8:b0:5a8:ac15:534d with SMTP id t40-20020a056a0013a800b005a8ac15534dmr9509566pfg.13.1677895480835;
        Fri, 03 Mar 2023 18:04:40 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id c24-20020aa78818000000b005d3901948d8sm2238736pfo.44.2023.03.03.18.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 18:04:40 -0800 (PST)
Date:   Sat, 4 Mar 2023 11:04:36 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        senozhatsky@chromium.org, minchan@kernel.org
Subject: Re: +
 zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix.patch added to
 mm-unstable branch
Message-ID: <20230304020436.GC5231@google.com>
References: <20230303232900.708DEC433EF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303232900.708DEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/03/03 15:28), Andrew Morton wrote:
> Subject: zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping-fix
> Date: Fri Mar  3 03:24:35 PM PST 2023
> 
> fix comment spello

Thanks!
