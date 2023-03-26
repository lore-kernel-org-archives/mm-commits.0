Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60FAC76196
	for <mm-commits@archiver.kernel.org>; Sun, 26 Mar 2023 01:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjCZBRX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Mar 2023 21:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZBRW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Mar 2023 21:17:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD76F658D
        for <mm-commits@vger.kernel.org>; Sat, 25 Mar 2023 18:17:21 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso5368462pjb.2
        for <mm-commits@vger.kernel.org>; Sat, 25 Mar 2023 18:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679793441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5y5xBJ5G+EdVFO5W6nwY/qNofnYl8mwoNxVLOxTaH0=;
        b=VMffPhoxuVzv/SpHlxscVFV1BG962IHgPDLzfY/AWLFvby58IfLp7t/Mf428Bs8FvY
         O1TX7ZEnbPdnhiLLkvdf+Qpm1ZfCCSsRUequVFIZuob4t+p2s9dLkJe1ln6S0GNaFGF6
         9p2q+TFfY37gn3VNTpHXhDeNn84AJOaJ+t3XA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793441;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5y5xBJ5G+EdVFO5W6nwY/qNofnYl8mwoNxVLOxTaH0=;
        b=tjBhj2scpkuiniRYhSvgpQBTsHh0oFyEzyVOKJSIu31xjRfrWaeWpUyncjTkngd9hS
         mJzfjtDmv/aE1fAPbQG1F8ZrNPR4WQhUrQGnCvFPivTOdnsZdP5DVS4qtU75NGtzaHzL
         2mcoa0aHPaZjgJrggE6yNbr3prhipmAM02qAt586xrhvKttDbP7fVDmdzE8g5V932YbW
         3PCbzU9jwfa+HJRJxi+9GMJIhDc2prOe4CvGUD1TRJgEMwDox4JpR6MmQ5ttENRQj2mG
         MyRm3rAYsFY8mbTJPJc0R4XgGznCWkYXcbVIk5VB+vpNjonXQj7ORIQDX/u9Y0BAl8/l
         7cNQ==
X-Gm-Message-State: AAQBX9ebICcpK3EAwG9lIAg9OlLVXa16U/HvAWqAB5Bj+DTeRduzkBea
        42pmrLldAt55xw6VAy0cGnpCtbWzoSagBL+7qDGfIA==
X-Google-Smtp-Source: AKy350Z4RZSXF4dJpFCySiI8mvruvSN39oX2F29OTJeGCwedBI9c4FWhw94iwK0pl7BW/f1uz056Cw==
X-Received: by 2002:a17:902:fb88:b0:1a1:aea7:6d4e with SMTP id lg8-20020a170902fb8800b001a1aea76d4emr6150211plb.34.1679793441297;
        Sat, 25 Mar 2023 18:17:21 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090276c100b0019e81c8fd01sm16336745plt.249.2023.03.25.18.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 18:17:20 -0700 (PDT)
Date:   Sun, 26 Mar 2023 10:17:17 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org
Subject: Re: + zsmalloc-document-new-fullness-grouping.patch added to
 mm-unstable branch
Message-ID: <20230326011717.GJ3271889@google.com>
References: <20230325195321.13C04C433EF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325195321.13C04C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/03/25 12:53), Andrew Morton wrote:
> Patch series "zsmalloc: minor documentation updates".
> 
> Two minor patches that bring zsmalloc documentation up to date.
> 
> 
> This patch (of 2):
> 
> Update documentation and reflect new zspages fullness grouping (we don't
> use almost_empty and almost_full anymore).
> 
> Link: https://lkml.kernel.org/r/20230325024631.2817153-1-senozhatsky@chromium.org
> Link: https://lkml.kernel.org/r/20230325024631.2817153-2-senozhatsky@chromium.org
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Fixes: 67e157eb3639 ("zsmalloc: show per fullness group class stats")
