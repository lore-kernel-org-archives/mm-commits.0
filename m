Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DC8C07E96
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 04:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F79A61CC8
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 04:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhGHEtp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jul 2021 00:49:45 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:33732 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhGHEtp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Jul 2021 00:49:45 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GL3ft2dwGzB9Dt;
        Thu,  8 Jul 2021 06:47:02 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4RNY8SeyMsjD; Thu,  8 Jul 2021 06:47:02 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GL3ft1jnKzB9Dg;
        Thu,  8 Jul 2021 06:47:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D47158B7D3;
        Thu,  8 Jul 2021 06:47:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 3MAroupGgIg8; Thu,  8 Jul 2021 06:47:01 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 238AC8B767;
        Thu,  8 Jul 2021 06:46:59 +0200 (CEST)
Subject: Re: [patch 26/54] powerpc: convert to setup_initial_init_mm()
To:     Andrew Morton <akpm@linux-foundation.org>,
        benh@kernel.crashing.org, jrdr.linux@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com
References: <20210708010851.Nu7rJ1_vQ%akpm@linux-foundation.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <2d98012a-1701-4ebc-02dc-9f8f1337c0a3@csgroup.eu>
Date:   Thu, 8 Jul 2021 06:46:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708010851.Nu7rJ1_vQ%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



Le 08/07/2021 à 03:08, Andrew Morton a écrit :
> From: Kefeng Wang <wangkefeng.wang@huawei.com>
> Subject: powerpc: convert to setup_initial_init_mm()
> 
> Use setup_initial_init_mm() helper to simplify code.
> 
> Note klimit is (unsigned long) _end, with new helper, will use _end
> directly.

The patch has been rebased because klimit doesn't exist anymore so the above sentence should be droped.

> 
> Link: https://lkml.kernel.org/r/20210608083418.137226-12-wangkefeng.wang@huawei.com
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   arch/powerpc/kernel/setup-common.c |    5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> --- a/arch/powerpc/kernel/setup-common.c~powerpc-convert-to-setup_initial_init_mm
> +++ a/arch/powerpc/kernel/setup-common.c
> @@ -926,10 +926,7 @@ void __init setup_arch(char **cmdline_p)
>   
>   	klp_init_thread_info(&init_task);
>   
> -	init_mm.start_code = (unsigned long)_stext;
> -	init_mm.end_code = (unsigned long) _etext;
> -	init_mm.end_data = (unsigned long) _edata;
> -	init_mm.brk = (unsigned long)_end;
> +	setup_initial_init_mm(_stext, _etext, _edata, _end);
>   
>   	mm_iommu_init(&init_mm);
>   	irqstack_early_init();
> _
> 
