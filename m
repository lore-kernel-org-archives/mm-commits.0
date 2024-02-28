Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3760920DCE
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 05:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709097689; cv=none; b=unKfm9YG4Fz3wTIR3FH58h8ChAVEjT8PRAPCc9Sd3LIyWSv01SCKVhlV+ZYG8SPpm99ehfk7UWAPGz1ssqWB8u1wFBZv0QXOm9hieIHMCdo0gP+92AspMCKX9dDIrykTd8T8hVCU0tJAs6uqxMrdfx9LNjNIDO3eQNy2RfnvFig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709097689; c=relaxed/simple;
	bh=XbZ/5/fPOxvuJwtF2WcIr0g8R0oHBCqRkHRhZWuPnD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8JSkYn/qTwzJh6D6hnf8h++baWG1n82BBl0MUR2EwhkklBiuZVFo47HFf+BJZv5bkYQBQ+RW7rcj+MGU2zPuBuVFubLlTwapcw7xJhbQ3nO2BaeUhK4SeZdUb7ByTwQa1mhzUnD6eG0SnAen9llugIgsytuR5LZzhxrZJBvzHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NrIzTEDn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NrIzTEDn"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dc0d11d1b7so43112685ad.2
        for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 21:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1709097686; x=1709702486; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fmROyKZAI7KmA+rdiQojC4wyGpLEBAuSu1FHzziyWvA=;
        b=NrIzTEDng+zkU6r3i76urfdFjj5rFEWT7+TYY0h8m8DwNwAzsgVTtfpH6qLo3NZO+1
         m1K4YGEfgdo5ctjGjNs8XIC937oS1JhA5QfPvQr2FtZvsJp+tgyzCCkMQXBbDNt+YJFF
         dGwATg1K0O8iwDi0pjFO1ScM2yjw2e14sAn5j5ybXgIwU9RDUwLny8P2t5Rk7r3yNh88
         7PB8AIavT/Lf2weq2z0heuCeJcZGceYhw37D2D7res93Reqxx55iQ0gPI51zpJZnXqpf
         9QAMgj/zfXLfZZ/y77wxZv9S2ln8lciWZzEUzJQ9Y6rHjKhdfKlG72kKvE6j4AO13M76
         jVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709097686; x=1709702486;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fmROyKZAI7KmA+rdiQojC4wyGpLEBAuSu1FHzziyWvA=;
        b=cVPpp2RmUjuVvKU0Emz8bnydo9LDEMz6L5dxCujpUCIHik90WKzbQ9IS4BAdc4W/hS
         yn8Cf+tyY4FZ+XgTGPZgfAN0kt5zSnGEwil1M1KKDY+xVwae97uA23Kp3+f/mLWrSs04
         dpTbt5CpHTYbGaPqh7PGx6TqnaDHSn2puwTyDYO5xKHcx5iUiC1qDQNDyOOvu7V/R131
         05WVIhHKm97bBFiZjTE7mVV22yHqYuiqVPSkkoxCjeU1KYAL6T3HEtRdUL+GtoWvve6e
         HQ4961MxloMiNTOt3w56RGqL+kaa4Nt5TtzHjvXqi0G63Nq4+OAyvCo3wEW1hnpdwaGt
         SeGw==
X-Gm-Message-State: AOJu0Ywp+uGn4yyX1qe6ASDAYMN9iOj1DnS0G0OmkwBIbd37jl3BSedl
	OrlqetiqHSolIkstMeev0vfkfSxRXkR218FhFrcIu00exEl8q1gt3JawBDNl78c=
X-Google-Smtp-Source: AGHT+IFclcYaSnN44ZW5rtgIfiikiBlJ81S8cwS3wgUNyRdxvR3av+TTVAdhEF84IEjMhbCJSrMXNg==
X-Received: by 2002:a17:902:6f10:b0:1dc:c8ea:6243 with SMTP id w16-20020a1709026f1000b001dcc8ea6243mr676357plk.68.1709097686450;
        Tue, 27 Feb 2024 21:21:26 -0800 (PST)
Received: from [10.254.95.105] ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id v19-20020a170902d09300b001dba98889a3sm2434489plv.71.2024.02.27.21.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 21:21:26 -0800 (PST)
Message-ID: <cb7dc435-5502-4925-9df9-48fc0d59066b@bytedance.com>
Date: Wed, 28 Feb 2024 13:21:21 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-zsmalloc-dont-hold-locks-of-all-pages-when-free_zspage.patch
 added to mm-unstable branch
Content-Language: en-US
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com, nphamcs@gmail.com,
 minchan@kernel.org, hannes@cmpxchg.org
References: <20240227180415.6E4BBC433F1@smtp.kernel.org>
 <20240228043534.GG11972@google.com>
From: Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <20240228043534.GG11972@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/2/28 12:35, Sergey Senozhatsky wrote:
> On (24/02/27 10:04), Andrew Morton wrote:
>> The patch titled
>>      Subject: mm/zsmalloc: don't hold locks of all pages when free_zspage()
>> has been added to the -mm mm-unstable branch.  Its filename is
>>      mm-zsmalloc-dont-hold-locks-of-all-pages-when-free_zspage.patch
>>
>> This patch will shortly appear at
>>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-dont-hold-locks-of-all-pages-when-free_zspage.patch
>>
>> This patch will later appear in the mm-unstable branch at
>>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: Chengming Zhou <zhouchengming@bytedance.com>
>> Subject: mm/zsmalloc: don't hold locks of all pages when free_zspage()
>> Date: Tue, 27 Feb 2024 03:02:54 +0000
>>
>> Patch series "mm/zsmalloc: simplify synchronization between
>> zs_page_migrate() and free_zspage()".
>>
>> free_zspage() has to hold locks of all pages, since zs_page_migrate() path
>> rely on this page lock to protect the race between zs_free() and it, so it
>> can safely get zspage from page->private.
>>
>> But this way is not good and simple enough:
>>
>> 1. Since zs_free() couldn't be sleepable, it can only trylock pages,
>>    or has to kick_deferred_free() to defer that to a work.
>>
>> 2. Even in the worker context, async_free_zspage() can't simply
>>    lock all pages in lock_zspage(), it's still trylock because of
>>    the race between zs_free() and zs_page_migrate(). Please see
>>    the commit 2505a981114d ("zsmalloc: fix races between asynchronous
>>    zspage free and page migration") for details.
>>
>> Actually, all free_zspage() needs is to get zspage from page safely, we
>> can use RCU to achieve it easily.  Then free_zspage() don't need to hold
>> locks of all pages, so don't need the deferred free mechanism at all. 
>> This patchset implements it and remove all of deferred free related code.
>>
>>
>> This patch (of 2):
>>
>> free_zspage() has to hold locks of all pages, since zs_page_migrate() path
>> rely on this page lock to protect the race between zs_free() and it, so it
>> can safely get zspage from page->private.
> 
> Andrew, please drop this series as it's NULL-deref crashing zsmalloc
> (as far as I can tell).

Right, will fix it and test thoroughly before sending the next version.

Thanks!
