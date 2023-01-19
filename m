Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E927C6379F
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 15:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjASPDf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 10:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjASPDc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 10:03:32 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0B22A177
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 07:03:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 23FAC604F0;
        Thu, 19 Jan 2023 16:03:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1674140607; bh=raIfu7ekdQMU85aDYaVwIFUVvSbx6I7+yZGTJbAArjc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=crlvTUK45dMg57dwrfz3r0PO4OmdT2B/a90lKOX1BRJtOU+Ityl4udz3eKL4io14F
         RRU6s3J/JiPhaJBAozqhaQCSqS/JJM+ymSkOq227nRav4cGEExKi2iUBCPAf4daghl
         WBdbYgLsqkLk8wyYEWuXNNFDy3DaouxN0321ZvGu1+z1JdCMB5boH3IiQaXCaBdai3
         1OlcBWhvCgAvUMgTuQ8ql6AmRB9d8vtF4hG9Upcs3t3DKOTwYk410HcITBfmhTpNM2
         oesOxsEsVmIhupiLlftSseWil03k8dZlE7o8RgTORSMcr1mkwSNp4ZmIJ/78vGjJtm
         snE8saBAv6bSA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id l2IvvsIR-z0u; Thu, 19 Jan 2023 16:03:24 +0100 (CET)
Received: from [161.53.83.51] (pc-mtodorov.grf.hr [161.53.83.51])
        by domac.alu.hr (Postfix) with ESMTPSA id 27BE6604FD;
        Thu, 19 Jan 2023 16:03:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1674140604; bh=raIfu7ekdQMU85aDYaVwIFUVvSbx6I7+yZGTJbAArjc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=2ktj3HD633+NBw2N7I1UJEpXTDiSsMWOfAekgC+XUw2h+WupXsF9EDjjv17fuIwb0
         Upqz60+ZOsbIEADnV5vWiPF/rArQDYlXmjyeh0qz15Z3wc605Bgt6O26gaOzxaJqqM
         rB1LLjJMwZxQWsURhOLpef3YxoTTBFJKHNl9anRMnxl2tB7oV0y9i8gl8degCK5TGW
         Su7mSRw+a7Sw2BM/1jCK4em3sQ6ERJaLM1O20k+zbtSb0iaQv1YzxhPKortMwBBGhJ
         pLRQSqIKG7854oM9Wx1YDUVUVuSwACm2j5DzcfVUZ3q5bsu4lZAYPOxnjAO79Whfqm
         42d+43+8xEFWA==
Message-ID: <ef778ae2-f0a2-4c3b-a170-b211675c8854@alu.unizg.hr>
Date:   Thu, 19 Jan 2023 16:03:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: + mm-use-stack_depot_early_init-for-kmemleak.patch added to
 mm-hotfixes-unstable branch
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        nathan@kernel.org, ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        zhaoyang.huang@unisoc.com
References: <20230118001933.5E38DC433F1@smtp.kernel.org>
 <a6ff1869-d90e-3d3c-b023-3a95b4bc7eaf@alu.unizg.hr>
 <Y8lWUVIcOasoLYEZ@arm.com> <915ed887-c1ae-effd-3e78-1f659c6bdc0f@suse.cz>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <915ed887-c1ae-effd-3e78-1f659c6bdc0f@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 19.1.2023. 15:51, Vlastimil Babka wrote:
> On 1/19/23 15:40, Catalin Marinas wrote:
>> On Thu, Jan 19, 2023 at 02:02:29PM +0100, Mirsad Goran Todorovac wrote:
>>> On 18.1.2023. 1:19, Andrew Morton wrote:
>>>> --- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak
>>>> +++ a/mm/kmemleak.c
>>>> @@ -2070,8 +2070,10 @@ static int __init kmemleak_boot_config(c
>>>>    		return -EINVAL;
>>>>    	if (strcmp(str, "off") == 0)
>>>>    		kmemleak_disable();
>>>> -	else if (strcmp(str, "on") == 0)
>>>> +	else if (strcmp(str, "on") == 0) {
>>>>    		kmemleak_skip_disable = 1;
>>>> +		stack_depot_want_early_init();
>>>> +	}
>>>>    	else
>>>>    		return -EINVAL;
>>>>    	return 0;
>>>> _
>>>>
>>>> Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are
>>>>
>>>> mm-use-stack_depot_early_init-for-kmemleak.patch
>>>
>>> Please note that this patch activates stack_depot_want_early_init() only when
>>> kernel boot param "kmemleak=on" is used.
>>>
>>> When the following configuration is used:
>>>
>>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>>> CONFIG_DEBUG_KMEMLEAK=y
>>> CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
>>> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
>>> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
>>> CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
>>
>> Indeed, I commented here already:
>>
>> https://lore.kernel.org/all/Y8gDdnpvkCKvVV1t@arm.com/
> 
> And v4 was submitted with that change included:
> 
> https://lore.kernel.org/all/1674091345-14799-2-git-send-email-zhaoyang.huang@unisoc.com/

Indeed! I was five hours off at least.

Sorry, I missed these emails because linux-kernel@vger.kernel.org was not Cc:ed.
Fixed the filter now.

I agree this patch looks like it should be the solution, and I will test it in
the initial environment that triggered the bug as soon as I finish my current build.

Apologies, again.

Regards,
Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union
--
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

