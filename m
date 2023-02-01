Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96805C38142
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 03:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjBADuP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 22:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjBADuN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 22:50:13 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3D553553
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 19:50:11 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z1so9664683plg.6
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 19:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ae99MfV+hr7XD4c+hSHHJoc352Anmhik2JZpKT1Va9s=;
        b=O8ju+wkrMK/E6H59y2NapFGEb3PGeyuHPmZjdF7G43uOH00cg+ryB0bBKSYWpcPXsZ
         /APcdZgORcQj0y/q/MFfPVf3SrKoianXCI9j4K1/I7OdJCsB9FhwhggU66cnzvV3rQZ6
         i92wjCcy+2vNssJlqJeI/s4yiqweLfpJ9NgcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ae99MfV+hr7XD4c+hSHHJoc352Anmhik2JZpKT1Va9s=;
        b=L4W3x5YXo0dKpQq9z+k9EMnvhFsvBpz0NU/AdguH3gPP9z2YOGfmTd1Y0Dn7A+cbRT
         KjdlIZl3gs5tMO1ewFlPaSbovJAddKTTBXkd1SN8HyI3ZEj/cclKXT+Hi7KIOWMV07vZ
         K0aBaImGip4jiTb0bp27IFU/OKxM4WU1cmtCNI32SE15wQAuQabuTTOqGLUciUV2OrcF
         d0ekaksWiAhkGJQPcYpwLKqlqN6M7LZF91jUnNZS80x/h63PWZVNp524kWRUreRwKqX4
         sA8rxppDGLJ4OFYsz3SG5MLcMeIadSmFfEHzEZBVTSpOJpmcm1ed7YkK3eAiu4weUyKu
         ESUQ==
X-Gm-Message-State: AO0yUKX3/afaoZCe9QLCFUnwux9JsN2H69qEvWD1oIE0HwZp5L25Nfht
        rHynlC/Rh1hUpDdbQsn6yqQBVQ==
X-Google-Smtp-Source: AK7set9QYmytWy0Ea5BS28HgnHN5b9dmFzoXWIL2c59JVnvRCNpn2nCnwa9pyzwFptZqFeIy0pq7yg==
X-Received: by 2002:a17:902:e3cc:b0:196:29ba:ee49 with SMTP id r12-20020a170902e3cc00b0019629baee49mr1068560ple.67.1675223410891;
        Tue, 31 Jan 2023 19:50:10 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id d16-20020a170902aa9000b00189b2b8dbedsm10569052plr.228.2023.01.31.19.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 19:50:10 -0800 (PST)
Date:   Wed, 1 Feb 2023 12:50:05 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, senozhatsky@chromium.org, ngupta@vflare.org,
        minchan@kernel.org, hannes@cmpxchg.org, ddstreet@ieee.org,
        arnd@arndb.de, nphamcs@gmail.com
Subject: Re: [merged mm-hotfixes-stable]
 zsmalloc-fix-a-race-with-deferred_handles-storing.patch removed from -mm
 tree
Message-ID: <Y9nhbXqxs12QPNfT@google.com>
References: <20230201004455.D78F2C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201004455.D78F2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/01/31 16:44), Andrew Morton wrote:
> Currently, there is a race between zs_free() and zs_reclaim_page():
> zs_reclaim_page() finds a handle to an allocated object, but before the
> eviction happens, an independent zs_free() call to the same handle could
> come in and overwrite the object value stored at the handle with the last
> deferred handle.  When zs_reclaim_page() finally gets to call the eviction
> handler, it will see an invalid object value (i.e the previous deferred
> handle instead of the original object value).
> 
> This race happens quite infrequently.  We only managed to produce it with
> out-of-tree developmental code that triggers zsmalloc writeback with a
> much higher frequency than usual.
> 
> This patch fixes this race by storing the deferred handle in the object
> header instead.  We differentiate the deferred handle from the other two
> cases (handle for allocated object, and linkage for free object) with a
> new tag.  If zspage reclamation succeeds, we will free these deferred
> handles by walking through the zspage objects.  On the other hand, if
> zspage reclamation fails, we reconstruct the zspage freelist (with the
> deferred handle tag and allocated tag) before trying again with the
> reclamation.
> 
> [arnd@arndb.de: avoid unused-function warning]
>   Link: https://lkml.kernel.org/r/20230117170507.2651972-1-arnd@kernel.org
> Link: https://lkml.kernel.org/r/20230110231701.326724-1-nphamcs@gmail.com
> Fixes: 9997bc017549 ("zsmalloc: implement writeback mechanism for zsmalloc")
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
