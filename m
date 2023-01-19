Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11A2C004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 14:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjASOvT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 09:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjASOvR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 09:51:17 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C491E127
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 06:51:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 66B303887E;
        Thu, 19 Jan 2023 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674139875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vjod+qdBayGtzzzLxz8BowYbmuuYSyD2KElY3nbUQXE=;
        b=k9EFcMMWr6FaupBg6e55kdov+e0f4LR/ooptLLfYqB5pkR0Dht6IOt5nqfiC/xsuZlXd01
        Qv3s9ZeaEP5fIi3K1eHQIAUab56BOD1oanQU4q/AwTDcWyJipSAj9RD4Oz4JB38QZCoiug
        vtjEQql7XZQq5gOhvLl/uq6AhWlDPho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674139875;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vjod+qdBayGtzzzLxz8BowYbmuuYSyD2KElY3nbUQXE=;
        b=AfLlIklmqUZoUWA2AV7opXfgXuQc5qPw9yIcCPXx043fWUIuayZFlGSfFrdFlqNCIU1ijp
        QY7Uqag1nNj/EJAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 41FA4139ED;
        Thu, 19 Jan 2023 14:51:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id faFuD+NYyWNIMwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 19 Jan 2023 14:51:15 +0000
Message-ID: <915ed887-c1ae-effd-3e78-1f659c6bdc0f@suse.cz>
Date:   Thu, 19 Jan 2023 15:51:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: + mm-use-stack_depot_early_init-for-kmemleak.patch added to
 mm-hotfixes-unstable branch
Content-Language: en-US
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        nathan@kernel.org, ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        zhaoyang.huang@unisoc.com
References: <20230118001933.5E38DC433F1@smtp.kernel.org>
 <a6ff1869-d90e-3d3c-b023-3a95b4bc7eaf@alu.unizg.hr>
 <Y8lWUVIcOasoLYEZ@arm.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Y8lWUVIcOasoLYEZ@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 1/19/23 15:40, Catalin Marinas wrote:
> On Thu, Jan 19, 2023 at 02:02:29PM +0100, Mirsad Goran Todorovac wrote:
>> On 18.1.2023. 1:19, Andrew Morton wrote:
>> > --- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak
>> > +++ a/mm/kmemleak.c
>> > @@ -2070,8 +2070,10 @@ static int __init kmemleak_boot_config(c
>> >   		return -EINVAL;
>> >   	if (strcmp(str, "off") == 0)
>> >   		kmemleak_disable();
>> > -	else if (strcmp(str, "on") == 0)
>> > +	else if (strcmp(str, "on") == 0) {
>> >   		kmemleak_skip_disable = 1;
>> > +		stack_depot_want_early_init();
>> > +	}
>> >   	else
>> >   		return -EINVAL;
>> >   	return 0;
>> > _
>> > 
>> > Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are
>> > 
>> > mm-use-stack_depot_early_init-for-kmemleak.patch
>> 
>> Please note that this patch activates stack_depot_want_early_init() only when
>> kernel boot param "kmemleak=on" is used.
>> 
>> When the following configuration is used:
>> 
>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
>> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
>> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
>> CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
> 
> Indeed, I commented here already:
> 
> https://lore.kernel.org/all/Y8gDdnpvkCKvVV1t@arm.com/

And v4 was submitted with that change included:

https://lore.kernel.org/all/1674091345-14799-2-git-send-email-zhaoyang.huang@unisoc.com/
