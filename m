Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5A4C54EBD
	for <mm-commits@archiver.kernel.org>; Sat,  7 Jan 2023 03:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbjAGDcv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 22:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbjAGDcu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 22:32:50 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7A287F3B
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 19:32:50 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c6so3720239pls.4
        for <mm-commits@vger.kernel.org>; Fri, 06 Jan 2023 19:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hjxv+xIhTwQrJB7VLnNhJS3+8iBXInP37apOW91zlQM=;
        b=ksE6cxtDRAcTGbEWy7gXGQfs4mQ+pymQITdSMCufHZmV165jh9WPiyNQgNeYHys9Xk
         bIZTSyP+2WW0GJxPJRTJ8L8YuHTT2oGUcr7CBXBFEz6JO9vTBTaECvH+stlcfZYPSRt4
         QkxZDiAOLRnNNa6n2VBZwRKmkP+NV719pUWPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hjxv+xIhTwQrJB7VLnNhJS3+8iBXInP37apOW91zlQM=;
        b=hOUn+j4yqPA5DSXhDCj2ipC5h8kklfwOQym4ueS7TuQJWMKwEhLyHbnlm363wIEO3D
         KZtz+BRIl5PR63ttLRkTZC2bOU1iLsAgKAbjJKAuHfim9e1ODJJET8+W3wTfsIrVT6O0
         3x7aZ/WZOFGnWy+72sFqKdCD2ht9cIUa7oJYaHyG+hZSfNLnVmz6yTj2FaJrXehiM+kL
         jLhVRSjp6jAUsPvLqvWPaRFei6nkMMOKLk5TbAKfGuexWIUz3NK0Uh9XyqpVP2Caqx6h
         3GABg99iYqW0aasfTGmB74NbRkOxvYW2fpiY9ybVTX2pJJTIJEsE2mR4pSzoCJepxIj5
         XeJA==
X-Gm-Message-State: AFqh2kp8hqop2WlCUpAAM+Is2lANUGoHHmoex+DK6+aDsayMRBUfwD9Y
        fRxOOZC1TyEYx9nR82tbMBzG0A==
X-Google-Smtp-Source: AMrXdXs0HmUc9A+T4HiV+QT9T3oVdcLWQ7fwTzfwWH2XzLtXewDZ1sYqND9NB696dOUW+PBCKwzs6w==
X-Received: by 2002:a17:903:1c1:b0:191:271f:47be with SMTP id e1-20020a17090301c100b00191271f47bemr90477729plh.35.1673062369500;
        Fri, 06 Jan 2023 19:32:49 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902a38300b001896522a23bsm1687883pla.39.2023.01.06.19.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 19:32:48 -0800 (PST)
Date:   Sat, 7 Jan 2023 12:32:44 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        senozhatsky@chromium.org, minchan@kernel.org, linmiaohe@huawei.com,
        gregkh@linuxfoundation.org
Subject: Re: + mm-remove-pagemovable-export.patch added to mm-unstable branch
Message-ID: <Y7jn3OkwM/0lPwa+@google.com>
References: <20230107005739.82CA6C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107005739.82CA6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/01/06 16:57), Andrew Morton wrote:
> The only in-kernel users that need PageMovable() to be exported are z3fold
> and zsmalloc and they are only using it for dubious debugging
> functionality.  So remove those usages and the export so that no driver
> code accidentally thinks that they are allowed to use this symbol.
> 
> Link: https://lkml.kernel.org/r/20230106135900.3763622-1-gregkh@linuxfoundation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
