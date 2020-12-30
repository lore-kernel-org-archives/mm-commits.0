Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6681C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 30 Dec 2020 15:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7592721D1B
	for <mm-commits@archiver.kernel.org>; Wed, 30 Dec 2020 15:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgL3PpO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Dec 2020 10:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgL3PpO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Dec 2020 10:45:14 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B22C06179C
        for <mm-commits@vger.kernel.org>; Wed, 30 Dec 2020 07:44:33 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d13so17736657wrc.13
        for <mm-commits@vger.kernel.org>; Wed, 30 Dec 2020 07:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Ec8poaPF6qlRrNwp+xHF6bY/o9NVo8b8Mjo+pjEbuDo=;
        b=p5ZWH3UXn+ALAlomf+AMGo0qpgilK3fzPQvE3q4wYtSdeUs87fZcES1ZveUXB1mW23
         swOZC23Nc8ClVKZwO5ZmK9k11s3ALjY2GxAiVm3tcFI8JvmFx43jnJBF5el+r2VZy4WY
         iDemgsZc/GIaLrwcWWe3RN2BQKEoZ7zgBXvAdyShuy6Y7jDcEHCpC+YGai7FWDU98T7u
         cBI//TZinzDJ7LDBYRj+Lb09vEbP7osA4vevyqRUrldBAvci15Qlo2gH8HywWWD/7lj7
         hs6MxfqqEHKiNFZCZ5KExMAM9IAmUvIb3BTToe39UBjzBTbrY9L3Q53+tyT+ubsSwnrb
         VBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ec8poaPF6qlRrNwp+xHF6bY/o9NVo8b8Mjo+pjEbuDo=;
        b=gVZQsx5e0jMfuw6hWluSmV9kF8THx0JmBUyQwk5d8L3KJQ6HU4vfWQZ7ukJ3svUrJL
         gEjMfmWHR4Ay9nXMVJuL9SfwgYpCmB0sMww2nDwwLtGUGdOMkFXZu3grYNavffaGXvyC
         YoMGcxCQ08iF+FLPQOsC4H5CmF2LAAQgNj2h6YQAYYvqXk3L+lMi/G5DrqUNAVGdIGdp
         DhbvhoBAxzGJVJj0nSL3rd9D+8dsqsF9mbckF+NRvsY7pUeV+J6FaMkybz4YWE94fy9u
         fZ70ISAfWqUdujhlcLl9qQTLNiRbz4w50exxpP6vRHefzt272cQEiN19VEN6AY3Smrvc
         +Mgg==
X-Gm-Message-State: AOAM531EPf9o6ATB613XtslKUoLiE3/9kIU7rEB490irGvm8lpa5pIr7
        pHlyp+NLcflDP+eTV9uqlWmiEqlR1PCUDmT2
X-Google-Smtp-Source: ABdhPJx75hGMwnI/4mGQur2LZ4QuGRIic58aW/TdwtkibjFrMpNiiX/shxSN5pb5YVz/sWxSeiBAuQ==
X-Received: by 2002:adf:eecc:: with SMTP id a12mr60570143wrp.312.1609343072516;
        Wed, 30 Dec 2020 07:44:32 -0800 (PST)
Received: from localhost.localdomain (p200300d9970348005c94200a58b3c908.dip0.t-ipconnect.de. [2003:d9:9703:4800:5c94:200a:58b3:c908])
        by smtp.googlemail.com with ESMTPSA id h184sm8207819wmh.23.2020.12.30.07.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Dec 2020 07:44:31 -0800 (PST)
Subject: Re: + ipc-convert-ipcs_idr-to-xarray-update.patch added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>, dave@stgolabs.net,
        mm-commits@vger.kernel.org, willy@infradead.org
References: <20200424014753.DfBuzjmzo%akpm@linux-foundation.org>
From:   Manfred Spraul <manfred@colorfullife.com>
Cc:     1vier1@web.de
Message-ID: <3e33fff1-4b28-8fe5-6567-3f26cdc8b1b2@colorfullife.com>
Date:   Wed, 30 Dec 2020 16:44:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20200424014753.DfBuzjmzo%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Matthew,

Due to lack of time, I didn't follow up immediately, but I haven't 
forgotten the patch series:

On 4/24/20 3:47 AM, Andrew Morton wrote:
> The patch titled
>       Subject: ipc-convert-ipcs_idr-to-xarray-update

[...]

> -		xas_lock(&xas);
> +		xa_lock(&ids->ipcs);
>   
> -		min_idx = ids->next_idx;
> -		new->seq = ids->seq;
> +		err = __xa_alloc_cyclic(&ids->ipcs, &idx, NULL,
> +				XA_LIMIT(0, max_idx), &ids->next_idx,
> +				GFP_KERNEL);
> +		if (err == 1) {
> +			ids->seq++;
> +			if (ids->seq >= ipcid_seq_max())
> +				ids->seq = 0;
> +		}
> +
> +		if (err >= 0) {
> +			new->seq = ids->seq;
> +			new->id = (new->seq << ipcmni_seq_shift()) + idx;
> +			/* xa_store contains a write barrier */
> +			__xa_store(&ids->ipcs, idx, new, GFP_KERNEL);
> +		}

The GFP_KERNEL is really ugly.

When I see "GFP_KERNEL", it means for me that the called function might 
sleep.
When I see "GFP_ATOMIC", it means for me that the called function may 
fail, and that the caller must implement a retry algorithm.

I think the GFP_KERNEL here means nothing, but I'm not sure.

Would it be possible to make __xa_store(,,,0) an officially supported 
feature?
- The function will fail if there was no previous xa_alloc for exactly 
the to be stored entry (or an xa_insert, or an xa_store(,,,GFP_KERNEL), 
etc.)
- The function will not allocate any memory.
- The function will not fail due to out of memory.
- The function will not drop the xa_lock()

Then the usage would be clear:
    xa_alloc(,GFP_KERNEL)
    acquire_all_locks()
    __xa_store(,,,0)
    drop_all_locks()


The kerneldoc is for me not clear enough:

> **
>  * __xa_store() - Store this entry in the XArray.
>  * @xa: XArray.
>  * @index: Index into array.
>  * @entry: New entry.
>  * @gfp: Memory allocation flags.
>  *
>  * You must already be holding the xa_lock when calling this function.
>  * It will drop the lock if needed to allocate memory, and then reacquire
>  * it afterwards.
Is it guaranteed the dropping/acquiring the lock will never happen after 
storing the entry into the array?
If the xarray code first stores the entry, and then allocates memory for 
tree balancing or similar, then it would break the ipc/*.c

--

     Manfred

