Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FF2C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 03:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiJRDW5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 23:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiJRDWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 23:22:12 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80A2A221A
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:18:16 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id w196so14263760oiw.8
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 20:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0JRtJHnrpwqJAXwai249OxbZhkP91v0Egvsyb//bBK0=;
        b=Xur4i6Y1n9sdRHtehlOPt4RzsU4VKCYGP3FRNhpKvF+c5fdvXviBLDloIpMWAGcNLL
         o4CWx13/Vbt6ftwyCPntI09qK/BJLlj/W5ykD2Mj8Pc5+GgBQQ3dvLCgCkIeeZM+MGOd
         rv+mwq6l9XJZYgObh6ULVgOxWFxATFP4I4uD0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JRtJHnrpwqJAXwai249OxbZhkP91v0Egvsyb//bBK0=;
        b=Dc4aKeh2ZFZT2YaokLha83sG24NlCpYHk7MnKpwSGShjHUwBBkgOi1mO8jTMR/uWac
         wWkE3UkYF8Lc2oO6noc5TqMlypkV30jkBFwTwX+s6lR+DShIp5486ugyeh2EJWJKHBkL
         T4v238Ahp0VChe293GDuaOt+dOrsXWQ/JrhHoJhZ8CZ00RLzZffKYFuD1/4KGQey6UQ4
         U0VJRDQLtatJi6cniMey9Q8FfcuvdfHnridI/6my1qwKbhlJjoTHH57/9rQByUjVJ0UG
         UE7pn21KFx/zOSYe13g33T55MVdjb7Oh9vj/HCiD0tLJGQPdvwg1AA1CQcdWMV5woBRk
         zMvA==
X-Gm-Message-State: ACrzQf22sx6Rf8iKwyn+8GhjzrsLQ3ItpiStXPm3IsNXRzWg7JAY02Iz
        bQNTiEYwhIt2YVOog0M0YkQ6kQpODTV9iw==
X-Google-Smtp-Source: AMsMyM7F7Fskhsw0rA46F42UxlwpE3AMzhcvxR6sy3Pb7WlrUr1lkCnkaqROn4CfO8hfZg+06NrzaQ==
X-Received: by 2002:a17:90b:1b06:b0:20d:3b10:3817 with SMTP id nu6-20020a17090b1b0600b0020d3b103817mr1105412pjb.43.1666062580980;
        Mon, 17 Oct 2022 20:09:40 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:58b4:95a3:4654:2a9f])
        by smtp.gmail.com with ESMTPSA id s21-20020a056a00195500b00562ef28aac6sm8071829pfk.185.2022.10.17.20.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 20:09:40 -0700 (PDT)
Date:   Tue, 18 Oct 2022 12:09:36 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org
Subject: Re: + zram-preparation-for-multi-zcomp-support.patch added to
 mm-unstable branch
Message-ID: <Y04Y8J5bb6O9W4rV@google.com>
References: <20221018000913.BD244C43151@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018000913.BD244C43151@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/10/17 17:09), Andrew Morton wrote:
> The patch titled
>      Subject: zram: preparation for multi-zcomp support
> has been added to the -mm mm-unstable branch.  Its filename is
>      zram-preparation-for-multi-zcomp-support.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-preparation-for-multi-zcomp-support.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Andrew, can you please drop all these patches. I'll resend a rebased
series shortly. It's much easier this way than handling all those
individual conflicts that we get in Kconfig and so on.
