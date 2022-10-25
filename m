Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8181BC67871
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 02:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiJYCfG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 22:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiJYCfE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 22:35:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A64264B3
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 19:35:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id m2so5590476pjr.3
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 19:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DmkVsoA0gOiHUXUilmWegawlOGChriLadlbqOiMb5oY=;
        b=JQgcGHtR5kDlQtNojEO1WEYOmdlRKK69Yv2JZz0LtuXJNvSQc46p5+aVp5hxcraIwX
         2ZHRNTFE2B3EdHztgEsJz1wSq4El54HRV5JICrcFsYzDZ5ScipF7XIC5egCenvE5tyzo
         XY2t4jlEacYkZAHDGz6pisMCaSi14MVrigy7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DmkVsoA0gOiHUXUilmWegawlOGChriLadlbqOiMb5oY=;
        b=2xuXj8jwpCULHIDohUJXZUnWuQFBlFNIyV+E6e3M/c/quY6il/BhoiFZ5tClYZHeIU
         dOl9eCP3sppxnvKd2FN8E9aSjXE0eLwZhCf6L751h0EFpuLrGO0skeQ8TPdKQJk4qVq3
         I1l2fOEgyy2oxzo7ehzQP8Mb0w0G0qpMcKFUkN6sUTyPb9lqxzziNwLNoP0eDb68yx+S
         3S8qJiG89UjFCoqxUMVXOXbhhvnjTJWuG2NYDqHh+VR8jLgHuVFZ2/UIQFiSDVPLbrqR
         skEfKcfyV7d979W6vJ3a5RklEQ3C+HBtT6Ev1YyCNniDnSx/Fs82gDx8nUoSr76zm1KG
         C7jQ==
X-Gm-Message-State: ACrzQf24O4W0HGjFqadU8N5mGKBibdh0CXQ2o37kT6ZJ5JM5iD+4CONQ
        bdLyqsF143/uj7+ePg44DCprqA==
X-Google-Smtp-Source: AMsMyM6OybUC7HkgfnXRdZaFKrN3/3jEzsxcLqdDO6fkLS1mqgHeQ/9crhB5cOaZ20+Yq+4eouQT6A==
X-Received: by 2002:a17:903:41c3:b0:185:4ca4:7515 with SMTP id u3-20020a17090341c300b001854ca47515mr36864617ple.31.1666665302517;
        Mon, 24 Oct 2022 19:35:02 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:c493:65a6:2d64:1325])
        by smtp.gmail.com with ESMTPSA id nl1-20020a17090b384100b0021311ab9070sm1927581pjb.52.2022.10.24.19.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 19:35:02 -0700 (PDT)
Date:   Tue, 25 Oct 2022 11:34:58 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru
Subject: Re: + zram-add-size-class-equals-check-into-recompression.patch
 added to mm-unstable branch
Message-ID: <Y1dLUje4Yn7WskAy@google.com>
References: <20221024210006.40FB0C433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024210006.40FB0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/10/24 14:00), Andrew Morton wrote:
> It makes no sense for us to recompress the object if it will be in the
> same size class.  We don't get any memory gain anyway.  But at the same
> time, we get a CPU time overhead when inserting this object into zspage
> and decompressing it afterwards.
> 
> Link: https://lkml.kernel.org/r/20221024120942.13885-1-avromanov@sberdevices.ru
> Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
