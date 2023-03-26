Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30B9C6FD1C
	for <mm-commits@archiver.kernel.org>; Sun, 26 Mar 2023 01:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjCZBQf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Mar 2023 21:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZBQe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Mar 2023 21:16:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736333C3E
        for <mm-commits@vger.kernel.org>; Sat, 25 Mar 2023 18:16:31 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d8so3231170pgm.3
        for <mm-commits@vger.kernel.org>; Sat, 25 Mar 2023 18:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679793391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bx7uIjRIv+iSKCpggMiCcUBxaYj9Iysl0Pgn9BJ2FQU=;
        b=e5TaTaQPH8ZqCFbHCnuCoOjnQXyvumstWcc/K0JSF5skMM1g3uEXypbfoOgeWM89fT
         Z6ehRWUBvM4J0iH58EeglRAt6ans9LNCWK9qPG3ItP8tV5UGoBkWaNKwfPuLgG/X02HK
         090ZYgAmTGnKj8H6E6oSoNhhw+DkmrnmrFfzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bx7uIjRIv+iSKCpggMiCcUBxaYj9Iysl0Pgn9BJ2FQU=;
        b=QIWZJHS8nR1o/wRY9pexcYbGSmyNEcppHK4+pO/5WGGDLr/Codv1mn18msKp8jaV6x
         x9vGwT4z94hQjfVmBTRbYwdo9UFIja3DseznglqaNMH68vkwK5LeSUG2pp8JWpFEmf5B
         z2MuA2TA5PuncU4bXAhUw3LT043a3nralHpTrDv4TAjeFw0bvpcGTFEyqDWSP5ZS3l72
         s0Nzx6JOgr7OlA4qYAS/KcQbPULooleQQo5fmtLF4DmnOEHGZG3hoA20ONwvbQ3zbTMB
         Q1m32TIdu0ifW5fcuZX6/4WJwZkXmclTZYwUNIppjotv9p3A17KE5VgJKFkqfsXfIu21
         ZjVA==
X-Gm-Message-State: AAQBX9eudLaQnxh8XITAGRFMugc5GIECgfZgxzJURr4CXEtbKSCh9RKT
        EWax37DTZtCymoBZjmA/3m4aEA==
X-Google-Smtp-Source: AKy350bQ9uPRgbkDCKa6qDHhjbTU9sxZ59edwmg7NPDQnQK5/HmQzSsC+/mf4YN9hVXecdNo9DlJ8g==
X-Received: by 2002:a62:6385:0:b0:627:e175:2b5f with SMTP id x127-20020a626385000000b00627e1752b5fmr6582872pfb.3.1679793390890;
        Sat, 25 Mar 2023 18:16:30 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id u14-20020a62ed0e000000b005ac419804d3sm16192583pfh.186.2023.03.25.18.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 18:16:30 -0700 (PDT)
Date:   Sun, 26 Mar 2023 10:16:26 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org
Subject: Re: + zsmalloc-document-freeable-stats.patch added to mm-unstable
 branch
Message-ID: <20230326011626.GI3271889@google.com>
References: <20230325195322.B4F8DC4339B@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325195322.B4F8DC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/03/25 12:53), Andrew Morton wrote:
> 
> When freeable class stat was added to classes file (back in 2016) we
> forgot to update zsmalloc documentation.  Fix that.
> 
> Link: https://lkml.kernel.org/r/20230325024631.2817153-3-senozhatsky@chromium.org
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Fixes: 1120ed548394 ("mm/zsmalloc: add `freeable' column to pool stat")
