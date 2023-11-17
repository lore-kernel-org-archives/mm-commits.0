Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7E3C197A0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 01:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjKQBiJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Nov 2023 20:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjKQBiJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2023 20:38:09 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB53129
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 17:38:06 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6b77ab73c6fso1132514b3a.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Nov 2023 17:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1700185085; x=1700789885; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EAhUsXVItApU2YCSUKvfC2gtCtARC3yWGc3BDPQUxvk=;
        b=IuitTHTTrQntVie1uYMBBbgJAgqhRrtSXCcr+O43JIrdI4VnOXp8xNMVcMUfZGDUf7
         HQ0YrK5lAOYTFdirFY+WhyK0O2OwIFa9Kp7quz/EXIn04Q2JhGsomWKiKPNlvnPnYwsd
         No4uBeq1XnbvDFxL++wyVRLqDPNgXzz0wn10s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700185085; x=1700789885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EAhUsXVItApU2YCSUKvfC2gtCtARC3yWGc3BDPQUxvk=;
        b=pVhnyqKo9i91y2qT6la9m/5znTt+fzLtS0EJ+q0FA090AQZxALznfNVqC3PM/m62md
         HysblqCl7DnavJIJOFF4vwM8PkKLby1cJfiBvC9IAfx5iYa+n24elzcLjEvKwnj4JsJ1
         YJekOXe56R0c/FKkN1KDQpqPLi5mGdU+5RW9uRMiuotOY7to1WKqlf2BGmoS7jaYu+Pg
         oHHYzArgY9dFpQgjjSab/Jghxb9TS0IhpQ8zAlUY/MYMmWta8pEA60kpRHW5ycW51zIE
         pstSIY+U9IkpFn7QriMx+DWoTCG1Ywj+r3s6Aa8UQV0amF35h2525cX3ASbBqaVXtGqG
         SYWQ==
X-Gm-Message-State: AOJu0YzyXj9rXeEHwQB7E8jtsdmOihNAyemWaORs2JfKMBsA1YAZSHHZ
        Drb9JQTjHzCdigASEauucpxhDw==
X-Google-Smtp-Source: AGHT+IGAErwY2aJHDCH6I2ywGmsqu8zXWQgOf2DNznqyPW4hN0lLmi0rrls/t2mhD+GPoaLSoHcVDg==
X-Received: by 2002:aa7:92c3:0:b0:68e:351b:15b9 with SMTP id k3-20020aa792c3000000b0068e351b15b9mr3889210pfa.4.1700185085666;
        Thu, 16 Nov 2023 17:38:05 -0800 (PST)
Received: from google.com (KD124209171220.ppp-bb.dion.ne.jp. [124.209.171.220])
        by smtp.gmail.com with ESMTPSA id n32-20020a056a000d6000b006b225011ee5sm374871pfv.6.2023.11.16.17.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 17:38:05 -0800 (PST)
Date:   Fri, 17 Nov 2023 10:38:01 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org
Subject: Re: + zram-split-memory-tracking-and-ac-time-tracking.patch added to
 mm-unstable branch
Message-ID: <20231117013801.GB1325348@google.com>
References: <20231115224146.450B3C433C9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115224146.450B3C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/11/15 14:41), Andrew Morton wrote:
> ZRAM_MEMORY_TRACKING enables two features:
> - per-entry ac-time tracking
> - debugfs interface
> 
> The latter one is the reason why memory-tracking depends on DEBUG_FS,
> while the former one is used far beyond debugging these days.  Namely
> ac-time is used for fine-grained writeback of idle entries (pages).
> 
> Move ac-time tracking under its own config option so that it can be
> enabled (along with writeback) on systems without DEBUG_FS.
> 
> Link: https://lkml.kernel.org/r/20231115024223.4133148-1-senozhatsky@chromium.org
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Andrew, I sent a small (one-liner) fixup patch [1]

[1] https://lore.kernel.org/linux-block/20231117013543.540280-1-senozhatsky@chromium.org
