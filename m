Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C1BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 00:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD3661502
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 00:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343924AbhI3Aga (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 20:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhI3Aga (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Sep 2021 20:36:30 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAB4C06161C
        for <mm-commits@vger.kernel.org>; Wed, 29 Sep 2021 17:34:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so3406762pjb.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Sep 2021 17:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LAMxImEvoR9zgpeQhNnpHNqQhvsq2PQwkw3Ht2soJt0=;
        b=nebmldPsc+nhqbbQYjR5VOuae3wuzOpINnE2kNShkfseBOZoIM426BN+r+/FOmAKUk
         E7Olak8yf7DJoWB1tJ32LKeRTdk0G028KK1xTrSLGwKSUnp/9EVP8DSijdE0yowIq/ft
         xGff5L0wpjF+/K4yfptu1RVo1aBwm7/pdjAxs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LAMxImEvoR9zgpeQhNnpHNqQhvsq2PQwkw3Ht2soJt0=;
        b=C8STUTgJeB78IM9qHBMGLO9KdymWld0vnBGDCSvHceRE40cMst7NEgzUAxiEdG8901
         NbYshPp/nhhJf7gM02m5KOausOQEkmtYrt0Jhdc7bnwv1mp45Q/m9M7dd1VnbUA+8sTB
         U0D8HB959XJAWxaea0gihFYq+aX2aF8BFxptjTAUGxg3/6GLXEEwIui6d4HBL9H74wwm
         y3sxttSiwpGoxLiQzTeD7JdL+vILds+s16KnqnShLz/L5m0v4ggL+OtirY0EYgWMDtCA
         wwYhSzqffbEeFthCoSoYESOjc4f46XMrneY5RFU8GWfR5DpG7lZJ7HSV5jxMs3YtMlgX
         8kIQ==
X-Gm-Message-State: AOAM531J0FZLP/oLszoso1sHR/LcrcMGVglmANrpQUoxvXr4YY/DeGND
        DniWBWW+68gXJMF2NlpGAH3ehw==
X-Google-Smtp-Source: ABdhPJz1EKn6AdiBgGnftnt4RvSQb8q1Hu2n8HR41tEUVMGuPoSjTD7/4OsD/RoRRn8d41Rc67nXpw==
X-Received: by 2002:a17:90b:1102:: with SMTP id gi2mr2978289pjb.43.1632962088443;
        Wed, 29 Sep 2021 17:34:48 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:f25e:9ab:ea46:1e61])
        by smtp.gmail.com with ESMTPSA id z4sm871251pfz.99.2021.09.29.17.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 17:34:48 -0700 (PDT)
Date:   Thu, 30 Sep 2021 09:34:39 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     akpm@linux-foundation.org
Cc:     bgeffon@google.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org
Subject: Re: + zram-introduce-an-aged-idle-interface-v6.patch added to -mm
 tree
Message-ID: <YVUGH89NaRujCfKW@google.com>
References: <20210929234334.qZxwN3qB4%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929234334.qZxwN3qB4%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (21/09/29 16:43), akpm@linux-foundation.org wrote:
> Sergey's cleanup suggestions
> 
> Link: https://lkml.kernel.org/r/20210929143056.13067-1-bgeffon@google.com
> Signed-off-by: Brian Geffon <bgeffon@google.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
