Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5C3EB64D7
	for <mm-commits@archiver.kernel.org>; Sun, 18 Jun 2023 04:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjFRESK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 18 Jun 2023 00:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjFRESJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 18 Jun 2023 00:18:09 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05D11BB
        for <mm-commits@vger.kernel.org>; Sat, 17 Jun 2023 21:18:07 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-666edfc50deso733899b3a.0
        for <mm-commits@vger.kernel.org>; Sat, 17 Jun 2023 21:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687061887; x=1689653887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WKyQSJ6hCBvd3oxveKbl6J9my7ZvgHLkdj6EwzudN7s=;
        b=M3fjDwQnknkIRc6Ns8LD4xVHqlM2BpspNIOMrUHmZeHBQWhF9Y66OMDpjKtA30Wj8o
         F8tFxAlb+E5A2a98tplwPJ2A8PsRogsH0heKgQlzMDvZniyjaSSa3cJH+O0+Re8qLj6h
         xoYASOZ76TV5ct5udC9P5onkee/L7VTwd6cFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687061887; x=1689653887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKyQSJ6hCBvd3oxveKbl6J9my7ZvgHLkdj6EwzudN7s=;
        b=G8v6Hb89GaBj4wZz3DJHsmAsP3D7lzLgMruN5m5dr0Vs+GG0VWhpiKyI+DCkuHWb/Q
         zSSkEUzGw4xCtUCWqLGWynYRV1DAG8ieYDYEeN47Xy9XhSHrs5BLxbZ3tBGycD2J0AFw
         ZigXDrIIGJK2NH+fY8xS11xXwySTkiQbnPlCAD+MMP8Nv80+aprr0T7m/GB3/M/Shzzz
         zuK7LB1T3KgYn1mY1pOm+8HVZ1W6XWZrxehTpcUUAkt3ju5z0pXAbduIxkb40DY4bDQ2
         e6HCgWL4MPDkNSxQjT3+DyKUoh63tMkj1FOUAZevY8Saf/kTKqyLlxOzlMOFVNczy/+A
         cGSw==
X-Gm-Message-State: AC+VfDzrkExU4AQIvJ+MxYdqEJmFxy/PcVHvXrommpRtwDpM3t8lGwmw
        BCI8/TxcBq+eoMzDUE3l+3hQqA==
X-Google-Smtp-Source: ACHHUZ4RLar8YLSE8IH/PLs7udaIPKSGv+yv4OEI/faBbZ96lksBd9U31G6Kif+dKo4VFD1X1ygyVw==
X-Received: by 2002:a05:6a00:806:b0:663:f82a:ec02 with SMTP id m6-20020a056a00080600b00663f82aec02mr9321807pfk.8.1687061887257;
        Sat, 17 Jun 2023 21:18:07 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id b2-20020aa78702000000b006668f004420sm5062224pfo.148.2023.06.17.21.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 21:18:06 -0700 (PDT)
Date:   Sun, 18 Jun 2023 13:18:02 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com
Subject: Re: + mm-zswap-remove-shrink-from-zpool-interface.patch added to
 mm-unstable branch
Message-ID: <20230618041802.GC2417543@google.com>
References: <20230612205132.8A1D9C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612205132.8A1D9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/06/12 13:51), Andrew Morton wrote:
> Subject: mm: zswap: remove shrink from zpool interface
> Date: Mon, 12 Jun 2023 11:38:13 +0200
> 
> Now that all three zswap backends have removed their shrink code, it is
> no longer necessary for the zpool interface to include shrink/writeback
> endpoints.
> 
> Link: https://lkml.kernel.org/r/20230612093815.133504-6-cerasuolodomenico@gmail.com
> Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
> Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
