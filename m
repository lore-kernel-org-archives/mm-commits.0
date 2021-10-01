Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E572C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 01:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DADC761452
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 01:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351058AbhJABWG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 21:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351046AbhJABWF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Sep 2021 21:22:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B80C06176A
        for <mm-commits@vger.kernel.org>; Thu, 30 Sep 2021 18:20:22 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id r7so5407772pjo.3
        for <mm-commits@vger.kernel.org>; Thu, 30 Sep 2021 18:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vzZD7IbKAWrZBsdMe7z6WICsVxtPRDHvZiXRvokqaZM=;
        b=CBm6h309mVYmsDzAMzFRMd1ClkxMWuw34fgVHFRpmL7khpHOa2HMZMQnf9axzGuw53
         zfSbzClcR/RZsQEhPY7Hs66/SPqFlLb9jjHqeOBp3q/xdu0zMPMY0STW5e4VU2UVYGOn
         /0ZZYLm3AytVLY08LjVsMi4f9SW4b5NjLh4/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vzZD7IbKAWrZBsdMe7z6WICsVxtPRDHvZiXRvokqaZM=;
        b=BAC5wAcBq6XLzh+Yd7Yhwg/lpLOPlp1e9J9a3+PdXP07prD65vYe0EcBXf2s22wWN0
         6qO4mR/uasgkFFvotIMDicFGPw7IR6MzWtLU/11m1VsygBYRK/cndsvFu/7XDKkZC80X
         LaM3LMk6ygg3kP8r7HaWWIl+PppQM9XQocCmujmXsAX8W1oOSJn9CyWO3agLQplMxT2B
         4umGr9n6wlpxRl0RrNPiH8Mp3oFsY/AsuH++O6PDPsQ4B3rBt7VDCaSxe2mB/1VOGyWs
         TznI/hTtkb/54s8SCdb6dflI7QSbJ5Sd8HSWB2cYnXe1rN18tPymf1yboBTTgVeR6kUv
         RNCQ==
X-Gm-Message-State: AOAM533s5EjCcWXxkfKZweXXHMkROLrHjVoMZYhG44kVFYoYhxUkw8aG
        nTSO7mJvrifCSLItdoH0BpHGH2Pw2aF/dg==
X-Google-Smtp-Source: ABdhPJxpIAzgsStZTzdo5FSm94LfIkxsr1OBmzed/IAjqEoxkY/ZjOLuPXhjj3UgilrVVl6W2Z02zg==
X-Received: by 2002:a17:90b:1d04:: with SMTP id on4mr9962928pjb.48.1633051222113;
        Thu, 30 Sep 2021 18:20:22 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:159f:3ab6:88f:1129])
        by smtp.gmail.com with ESMTPSA id s13sm4436684pfg.125.2021.09.30.18.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 18:20:21 -0700 (PDT)
Date:   Fri, 1 Oct 2021 10:20:14 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     akpm@linux-foundation.org
Cc:     andreyknvl@gmail.com, arnd@arndb.de, ast@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de,
        christophe.leroy@csgroup.eu, davem@davemloft.net,
        dvyukov@google.com, glider@google.com, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        monstr@monstr.eu, mpe@ellerman.id.au, paulus@samba.org,
        pmladek@suse.com, rostedt@goodmis.org, rth@twiddle.net,
        ryabinin.a.a@gmail.com, senozhatsky@chromium.org,
        tglx@linutronix.de, wangkefeng.wang@huawei.com
Subject: Re: + kallsyms-remove-arch-specific-text-and-data-check.patch added
 to -mm tree
Message-ID: <YVZiTtYbBsOzdQbH@google.com>
References: <20210930212149.TDvMQI9fl%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930212149.TDvMQI9fl%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (21/09/30 14:21), akpm@linux-foundation.org wrote:
> 
> Patch series "sections: Unify kernel sections range check and use", v4.
> 
> There are three head files(kallsyms.h, kernel.h and sections.h) which
> include the kernel sections range check, let's make some cleanup and unify
> them.
> 
> 1. cleanup arch specific text/data check and fix address boundary check
>    in kallsyms.h
> 
> 2. make all the basic/core kernel range check function into sections.h
> 
> 3. update all the callers, and use the helper in sections.h to simplify
>    the code
> 
> After this series, we have 5 APIs about kernel sections range check in
> sections.h
> 
>  * is_kernel_rodata()		--- already in sections.h
>  * is_kernel_core_data()	--- come from core_kernel_data() in kernel.h
>  * is_kernel_inittext()		--- come from kernel.h and kallsyms.h
>  * __is_kernel_text()		--- add new internal helper
>  * __is_kernel()		--- add new internal helper
> 
> Note: For the last two helpers, people should not use directly, consider to
>       use corresponding function in kallsyms.h.

FWIW, Andrew, feel free to add (to the series)

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
