Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A52C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 03:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiEIDPg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 8 May 2022 23:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiEIDNX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 8 May 2022 23:13:23 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8D48C7EF
        for <mm-commits@vger.kernel.org>; Sun,  8 May 2022 20:09:30 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id x12so10902053pgj.7
        for <mm-commits@vger.kernel.org>; Sun, 08 May 2022 20:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DnsPFd9/6WaxQ+yoZdpy61wZB3xLCRhaq2vZ2AURGmc=;
        b=fDLY5GxKThu7zDFU9m4zT/ABeWAfVP7fu2TD/9UfjUFUqWO+2ehrswh63AfQXjTHla
         6kYBOKTyvCm32/AxfBilo2jdNYdOyXSRXf9dQuyQjyQti2LD4ipCO0tXZJFXxqMSvrUf
         QlSHWjvPKG0wqsaAYbAIukVgscymHYXWHP6L8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DnsPFd9/6WaxQ+yoZdpy61wZB3xLCRhaq2vZ2AURGmc=;
        b=XVFrSCykkYHorsrNF062k/QUN3BPbabjmNBuyCVDg9QvL9aDm/nPn9vLjLmlwtHrGQ
         5HJRXV+YW83TG3Y3LBNBsbYPUR5LQdAkJ0JtB7K8xmKm9O01zttClAvHOEGiTBgXIhhM
         d75Z+1XRrg05ThAsiA2t+kp0ubImcuTe/sP9WcWuwfJsFTR3tYwF8FHJr4Lezb8ycHxm
         CI+zdI+dp7IqR4xGrwMnmdaREB/HjtgqMccVlcby7d/iy3fKajJ0rHUdMKSlu70gb5P5
         bhTbDN5WdDTHKDQL5jEXOPkWrnaCcBJBD8VK2YQB71HuwlUaAcdNu/5L+ygBmpRFlT+l
         5ssw==
X-Gm-Message-State: AOAM531kXXK2FxqB+KkyhAGPASW4pGTshuyQSaFt3Yo7ea7+LAn7l4/P
        qP3XlyzIp2DHz9T1/usIehYZmw==
X-Google-Smtp-Source: ABdhPJwzC4rBdQxO3FnPsTDH1gFwKBBE7NwQWAQisaLaauHzx1F6januPqPSxYkFZyUYHZnZbfzsrw==
X-Received: by 2002:a05:6a00:e0e:b0:50a:cb86:883c with SMTP id bq14-20020a056a000e0e00b0050acb86883cmr13993118pfb.11.1652065770193;
        Sun, 08 May 2022 20:09:30 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:8dff:f22e:e044:2857])
        by smtp.gmail.com with ESMTPSA id r7-20020a17090b050700b001d2bff34228sm11422203pjz.9.2022.05.08.20.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 20:09:29 -0700 (PDT)
Date:   Mon, 9 May 2022 12:09:25 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, ddrokosov@sberdevices.ru,
        avromanov@sberdevices.ru
Subject: Re: + zram-remove-double-compression-logic.patch added to
 mm-unstable branch
Message-ID: <YniF5R+WksISXTN3@google.com>
References: <20220507185744.D14CBC385A6@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220507185744.D14CBC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/05/07 11:57), Andrew Morton wrote:
> The 2nd trial allocation under per-cpu presumption has been used to
> prevent regression of allocation failure.  However, it makes trouble for
> maintenance without significant benefit.  The slowpath branch is executed
> extremely rarely: getting there is problematic.  Therefore, we delete this
> branch.
> 
> Since b09ab054b69b ("zram: support BDI_CAP_STABLE_WRITES"), zram has used
> QUEUE_FLAG_STABLE_WRITES to prevent buffer change between 1st and 2nd
> memory allocations.  Since we remove second trial memory allocation logic,
> we could remove the STABLE_WRITES flag because there is no change buffer
> to be modified under us.
> 
> Link: https://lkml.kernel.org/r/20220505094443.11728-1-avromanov@sberdevices.ru
> Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
> Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
