Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7216DC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 10:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiJZKb2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Oct 2022 06:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiJZKb1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2022 06:31:27 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9F489CF7
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 03:31:26 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id g24so8604619plq.3
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 03:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o3WIGqmDVFhlGjUFlqXNdRIfQzvN1HtZiVx+H8leinM=;
        b=VfEtiLQslMh/3TkpwXoKybHiJzUCKs0GYdPqrpc9rfAYVuZeBBoEx8dj1i4f7rd5pj
         XCad0fbIQNZ4IO6B+NIzHRfZhMwSuNTV02S/LZynCEsdZJU0MvfL4ZOH+Qtvh+wfwaGP
         GS1rgiNS7dz+elSz3dKJYslAM4+q8Dcs3B2lk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o3WIGqmDVFhlGjUFlqXNdRIfQzvN1HtZiVx+H8leinM=;
        b=li92nKwqS6PNp7Y7qqm58Owazt8pzsVPnlV3uVxuc214FhU7eColRoATLBNikHvWaV
         mTBqsB0489vSEr5owrl3hdDnhZCWQuVphFcRsq7qmNNppoDmPyAZuLFCcsB8czJxlOcH
         QGAHUaSWchfVfuaPKvlbW5K7WPL6DItUDnIJoZI+D4PKoK+/v0aoIJ6GJTkDAvvtyDk0
         borPtpIoQQPfWxNJGI9MO1e8qw2GvfJHyzUxHh7h2BPc0KiyE+J5GGZ/dFO2MWGFpkZ8
         q8tzubpqjqrfMaj+3OTef3J6wnlArgATAMlnhMe74A/gLNl77Tv2ApoQeSEqp2AVcD8v
         kYNQ==
X-Gm-Message-State: ACrzQf2loJ1aOBuPhBhnLycihsIwrAWNDMjXewrr4BiowiOh1RbWjc5k
        wUHBi213S2jLToUuBdd/K4NmJw==
X-Google-Smtp-Source: AMsMyM5cWloPs/ejDnpQuQqlrBqj3Pmyy7NLWKvLszO7kuTyCdAGjLO4p9oITmGdV++NxSSwGoc1nA==
X-Received: by 2002:a17:902:c24d:b0:186:a2d6:9f7f with SMTP id 13-20020a170902c24d00b00186a2d69f7fmr16324990plg.131.1666780286094;
        Wed, 26 Oct 2022 03:31:26 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:faf6:e503:6cac:3b53])
        by smtp.gmail.com with ESMTPSA id j7-20020a17090276c700b0017f73caf588sm2584663plt.218.2022.10.26.03.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 03:31:25 -0700 (PDT)
Date:   Wed, 26 Oct 2022 19:31:21 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, ubizjak@gmail.com
Subject: Re: + zram-use-try_cmpxchg-in-update_used_max.patch added to
 mm-unstable branch
Message-ID: <Y1kMeRsIX8kIKzpH@google.com>
References: <20221018205005.52F6CC433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018205005.52F6CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/10/18 13:50), Andrew Morton wrote:
> Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
> update_used_max.  x86 CMPXCHG instruction returns success in ZF flag, so
> this change saves a compare after cmpxchg (and related move instruction in
> front of cmpxchg).
> 
> Also, reorder code a bit to remove additional compare and conditional jump
> from the assembly code.  Together, hese two changes save 15 bytes from the
> function when compiled for x86_64.
> 
> No functional change intended.
> 
> Link: https://lkml.kernel.org/r/20221018145154.3699-1-ubizjak@gmail.com
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I totally missed that patch.

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
