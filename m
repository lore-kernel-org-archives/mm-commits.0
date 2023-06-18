Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB7EEB64D7
	for <mm-commits@archiver.kernel.org>; Sun, 18 Jun 2023 05:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjFRFb4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 18 Jun 2023 01:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjFRFbz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 18 Jun 2023 01:31:55 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF70B123
        for <mm-commits@vger.kernel.org>; Sat, 17 Jun 2023 22:31:53 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-25bf4b269e0so2357513a91.0
        for <mm-commits@vger.kernel.org>; Sat, 17 Jun 2023 22:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687066313; x=1689658313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=subZUXKaOZgcLTEr0XtKyzRMaOj+BOsmltqDLPSsZHA=;
        b=O7UpYKfD+ta7lKVtpkhYSiTnsfhi1kdV4u6aOOf1ZM9SvPnddSKCxGqOXPATR8lqdg
         xF5ZZEs7WkQDOmeJwuoBOroCz9jaS2Z3XzbNnicVmsoEDjzTatrbSbXIZ3JTFFMYleL3
         qjWkN+bhUL3KxM8GsbPwZG5orRrJ9kwWpkiGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687066313; x=1689658313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=subZUXKaOZgcLTEr0XtKyzRMaOj+BOsmltqDLPSsZHA=;
        b=dxCRK02VENoP7LvB4KklSMIB5kB9LEVgpqECQk0q44F3vqS8l3VLVOROSrUwp+Z6r+
         1RCd2WA+JyYc0sCBSCDLgq3WjuDgDK91hb7Ut0bgQiryX8Uwac7Ub/s11vSASX/k4AHC
         GPLVhtiY6tRo0xSm5WZVimMh1Q0b+XtEHJcTHohYaTRdoW+AsaV9IcBK+kQOuEQK7ge5
         tDYp1bvxw8f9QGNYxTKyfMnyQnMisKADIVaUuviuagM+3QzjnvM+vBxC1PppoqO7xIWp
         ypZkDDpJCcep0gPVmfHK/znGNGe77VrTcuGMM6mV4CZg4DgmsCBgQZAiUHUKuy5UCsau
         HTDQ==
X-Gm-Message-State: AC+VfDxliQy0f2UW4edHBQbhjMsr0JIb5GRCGgBGBsF5YF9CMUjEEO7B
        GcrT8mZ7Tx7+Y+XNUAORlFYvdiX2rbWEh13LuOs=
X-Google-Smtp-Source: ACHHUZ71MuIZ5+EuLNzIA2H9CDa5SWM81mqqIu+fF96zO3NlN6H4hQOQ8YvIGb45Q38MA4ZJGsH9eA==
X-Received: by 2002:a17:90a:19ce:b0:25e:db77:1db7 with SMTP id 14-20020a17090a19ce00b0025edb771db7mr3661656pjj.9.1687066313415;
        Sat, 17 Jun 2023 22:31:53 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id 2-20020a17090a1a0200b0025954958e06sm3384102pjk.18.2023.06.17.22.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 22:31:53 -0700 (PDT)
Date:   Sun, 18 Jun 2023 14:31:48 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com,
        senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com
Subject: Re: + mm-zswap-add-pool-shrinking-mechanism.patch added to
 mm-unstable branch
Message-ID: <20230618053148.GD2417543@google.com>
References: <20230612205124.A58DFC433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612205124.A58DFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/06/12 13:51), Andrew Morton wrote:
> Subject: mm: zswap: add pool shrinking mechanism
> Date: Mon, 12 Jun 2023 11:38:09 +0200
> 
> Patch series "mm: zswap: move writeback LRU from zpool to zswap", v3.
> 
> This series aims to improve the zswap reclaim mechanism by reorganizing
> the LRU management. In the current implementation, the LRU is maintained
> within each zpool driver, resulting in duplicated code across the three
> drivers. The proposed change consists in moving the LRU management from
> the individual implementations up to the zswap layer.
> 
> The primary objective of this refactoring effort is to simplify the
> codebase. By unifying the reclaim loop and consolidating LRU handling
> within zswap, we can eliminate redundant code and improve
> maintainability. Additionally, this change enables the reclamation of
> stored pages in their actual LRU order. Presently, the zpool drivers
> link backing pages in an LRU, causing compressed pages with different
> LRU positions to be written back simultaneously.
> 
> The series consists of several patches. The first patch implements the
> LRU and the reclaim loop in zswap, but it is not used yet because all
> three driver implementations are marked as zpool_evictable.
> The following three commits modify each zpool driver to be not
> zpool_evictable, allowing the use of the reclaim loop in zswap.
> As the drivers removed their shrink functions, the zpool interface is
> then trimmed by removing zpool_evictable, zpool_ops, and zpool_shrink.
> Finally, the code in zswap is further cleaned up by simplifying the
> writeback function and removing the now unnecessary zswap_header.
> 
> 
> This patch (of 7):
> 
> Each zpool driver (zbud, z3fold and zsmalloc) implements its own shrink
> function, which is called from zpool_shrink.  However, with this commit, a
> unified shrink function is added to zswap.  The ultimate goal is to
> eliminate the need for zpool_shrink once all zpool implementations have
> dropped their shrink code.
> 
> To ensure the functionality of each commit, this change focuses solely on
> adding the mechanism itself.  No modifications are made to the backends,
> meaning that functionally, there are no immediate changes.  The zswap
> mechanism will only come into effect once the backends have removed their
> shrink code.  The subsequent commits will address the modifications needed
> in the backends.
> 
> Link: https://lkml.kernel.org/r/20230612093815.133504-1-cerasuolodomenico@gmail.com
> Link: https://lkml.kernel.org/r/20230612093815.133504-2-cerasuolodomenico@gmail.com
> Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Tested-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
