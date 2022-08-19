Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE60BC32771
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 12:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346819AbiHSMEo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 08:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347622AbiHSMEn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 08:04:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C50C6CE8
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:04:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso4658681pjj.4
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IEQJ6ZxN/DOwo5gxO6oM41Y5wJB4l6YdjD+w496qTnA=;
        b=nCJTg2QYYAPyNDQLqtXny7BooVGncdOY3hae46ezm9GCgRkPKKeIM7hlgYux22y3Pj
         lEdBGozvVvJw++pmQcTCjFF4Y0GPwpM5qzYK7pR1bjLKka3VtlNupEInespwOaJ+0TjW
         L66jl4bDjSlVOzdLfIYfUFdcjXyVMkXHidr28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IEQJ6ZxN/DOwo5gxO6oM41Y5wJB4l6YdjD+w496qTnA=;
        b=8QO5yRfEap001Jzr6Xce9QUOObZVskQA6jjcB7x6RnX9d3y2GnjngMRwsN/A0RTDJo
         EEnxFLXzCPtTOf096/WI/9qwB2+j7D4facfTDQjb8rprOSKPq/jF6ZiMHJ+S1V8rQrgw
         JJVKGSnWmdU8ukApupXxE7eA/uns4tJzyu+Ycc4TaxnSwcLd9AJriNxdrNObzcmGn/zy
         3/W3yVrrEOiFpPvbCdJZKsQIQTj02fQK2WQgV0xwABPZ7MAUAfk24CBP1oHncdjrfylj
         mXG2t07VSgtx8hlFlPXLzpa3+fC4OPh+k605ZBQ9EO4O9N2lvM7xG8q6xaz0lnljMipQ
         OrKA==
X-Gm-Message-State: ACgBeo1LgNyuc/UamnF2CZ0Kua9jWvHf3L7KteSeVyQV5QaEN4Fkr3Dr
        dMHXFWmN8M6pv279zGo+FuVJ8Q==
X-Google-Smtp-Source: AA6agR6fielIlkU4RRGfQOnh8bbNyc1anJLFCbPas9C3smXZhIhBZjd1gXVyKrsyhjGj0AsMRqhoyA==
X-Received: by 2002:a17:902:db12:b0:16e:e5fc:56db with SMTP id m18-20020a170902db1200b0016ee5fc56dbmr7165056plx.46.1660910680833;
        Fri, 19 Aug 2022 05:04:40 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:7527:6400:5770:d67d])
        by smtp.gmail.com with ESMTPSA id q2-20020a17090a938200b001facd399d1asm2929803pjo.27.2022.08.19.05.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 05:04:40 -0700 (PDT)
Date:   Fri, 19 Aug 2022 21:04:35 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru
Subject: Re: + zsmalloc-remove-unnecessary-size_class-null-check.patch added
 to mm-unstable branch
Message-ID: <Yv98U22CMElN6OL7@google.com>
References: <20220811212201.71ECFC433D6@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811212201.71ECFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/08/11 14:22), Andrew Morton wrote:
> pool->size_class array elements can't be NULL, so this check
> is not needed.
> 
> In the whole code, we assign pool->size_class[i] values that are
> not NULL. Releasing memory for these values occurs in the
> zs_destroy_pool() function, which also releases and destroys the pool.
> 
> In addition, in the zs_stats_size_show() and async_free_zspage(),
> with similar iterations over the array, we don't check it for NULL
> pointer.
> 
> Link: https://lkml.kernel.org/r/20220811153755.16102-3-avromanov@sberdevices.ru
> Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
