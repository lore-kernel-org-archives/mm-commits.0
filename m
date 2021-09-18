Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC7EC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 18 Sep 2021 14:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8334561019
	for <mm-commits@archiver.kernel.org>; Sat, 18 Sep 2021 14:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbhIROzy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 18 Sep 2021 10:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhIROzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 18 Sep 2021 10:55:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625D8C061574
        for <mm-commits@vger.kernel.org>; Sat, 18 Sep 2021 07:54:30 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g16so20114512wrb.3
        for <mm-commits@vger.kernel.org>; Sat, 18 Sep 2021 07:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=/6EYPVCzDuISAoNEJ5Zcd5VKFtywYp0Rq/hq02JrPUE=;
        b=YlX1B52pBeKyu/4BzfEQe7lV2RM0VWIua+ueTVoGxoW6bTAqeFdPFhoncVMnLW6woH
         RooQn9nTLD9VKjICUJLIW1bfx4Lvdauj2cotsE3/6K90tdVJJWgHMueB+KnhlUqumVBu
         1of0OkrWRZ5kuXTL3ot97rz9vmRbbO40Gn5M2JFu+ZYqtsrMqub+Ta/vdygPW0+mNQ5U
         VSBpr8Dx/JikoNzfRiW9GQZy4LoBE1+9/BMfnXLjZWzxaUQTH2yL7rt4S4HaJ4cbOPJB
         4DU6IvPVUFWNbhOyVdzzeCGonx+BtSuVj4XGFdz4wCEkZyadt/Atd3BR/4n1WKgTw32e
         rsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/6EYPVCzDuISAoNEJ5Zcd5VKFtywYp0Rq/hq02JrPUE=;
        b=y4rOZztyeVvyUORzIwPZfEcTLeBiNGPKWhSifu9JLiFvb7EHxF8KhXxPALppeyxJA2
         9uXXZELynKDyIpm09dLaC+w3YJ3l6Dxjt3V4Nxn79BwWJxCei9esYL4n0kyhAZI9wfFk
         iAqubdbdKPYiX6CpLCTnEmM1lKZ090ekavonS+Om1t13C21tKBX0xBxFM3NGS0GCUjvW
         O38HASNVso2RC2VIVGqgeetU3XiORaXvtADMiaalpu1wLCTXNnDWohAPgul57p3ObSkk
         +e269QKuuA6Q6OaLGThh/gVdGqrAzXe0fWWE1L6r4fRFHMS9YhPntLBrtANAReOxZx2w
         IKvg==
X-Gm-Message-State: AOAM533AsqNHcjPxoFO7pD7uJ+QI9q6yA+ywk8VSJNTFjEdTMSyIZToD
        1OU4rdVeXsbkCavOrpspPJ/lJdqj0BU+v+gc
X-Google-Smtp-Source: ABdhPJyvkCKFyF29zqv8a10aaSRuygatO7a5M5TXhroiyHpN+/Q2oMYqV+jPcH5OJ6py3c+nwbnKYA==
X-Received: by 2002:a5d:65d0:: with SMTP id e16mr18324560wrw.182.1631976868804;
        Sat, 18 Sep 2021 07:54:28 -0700 (PDT)
Received: from localhost.localdomain (p200300d9973962007086c7f795e39cc9.dip0.t-ipconnect.de. [2003:d9:9739:6200:7086:c7f7:95e3:9cc9])
        by smtp.googlemail.com with ESMTPSA id r2sm10657399wrg.31.2021.09.18.07.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 07:54:28 -0700 (PDT)
Subject: Re: +
 ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch added
 to -mm tree
To:     akpm@linux-foundation.org, dave@stgolabs.net,
        ebiederm@xmission.com, mclapinski@google.com,
        mm-commits@vger.kernel.org
References: <20210916175104.Fx0YqSM5k%akpm@linux-foundation.org>
From:   Manfred Spraul <manfred@colorfullife.com>
Message-ID: <2246c0d9-3832-61c4-92a7-5f431f1b9887@colorfullife.com>
Date:   Sat, 18 Sep 2021 16:54:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210916175104.Fx0YqSM5k%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi,

On 9/16/21 7:51 PM, akpm@linux-foundation.org wrote:
> The patch titled
>       Subject: ipc: check checkpoint_restore_ns_capable() to modify C/R proc files
> has been added to the -mm tree.  Its filename is
>       ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files.patch
>
> ------------------------------------------------------
> From: Michal Clapinski <mclapinski@google.com>
> Subject: ipc: check checkpoint_restore_ns_capable() to modify C/R proc files
>
> This commit removes the requirement to be root to modify sem_next_id,
> msg_next_id and shm_next_id and checks checkpoint_restore_ns_capable
> instead.
>
> Since those files are specific to the IPC namespace, there is no reason
> they should require root privileges.  This is similar to ns_last_pid,
> which also only checks checkpoint_restore_ns_capable.
>
> Link: https://lkml.kernel.org/r/20210916163717.3179496-1-mclapinski@google.com
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-By: Manfred Spraul <manfred@colorfullife.com>
> [...]
>   #else
>   #define proc_ipc_doulongvec_minmax NULL
>   #define proc_ipc_dointvec	   NULL
> @@ -111,6 +124,9 @@ static int proc_ipc_sem_dointvec(struct
>   #define proc_ipc_dointvec_minmax_orphans   NULL
>   #define proc_ipc_auto_msgmni	   NULL
>   #define proc_ipc_sem_dointvec	   NULL
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +#define proc_ipc_dointvec_minmax_checkpoint_restore	NULL
> +#endif	/* CONFIG_CHECKPOINT_RESTORE */
>   #endif

This fallback is actually not required:

 From what I see, the whole file is not compiled when sysctl is disabled.

--

     Manfred

