Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8542C2E630
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 03:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708399086; cv=none; b=RaM6qrsxlvOxcYoecxfq4SsykJs6GvM6OeYmBBxJZJagPotzarnsYC1U1m6WiY2Kf/l5/uXFbsIEZSgqZh+myG6APM43ro+eyJPoMVU/dAVOUP7wh0kz3xS3jBXVttjJq/+JmbTIJruZL++hVL2ibX3OtFCzRg151VtOoDrO5Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708399086; c=relaxed/simple;
	bh=fO1jopjl4SxRkXFSZkk8QaBWsW9bSgeFc3pNTuOys3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pObr5ulSfV8vpsWp4FH27Kx8k0EpEAxzaxD86GYHxo35Qo2m+4+tf+9eVx2tOwO2nL4NNo/esVDXctJERR4Z8qakAr0RUrxxgsWUqxyoOhQq58j/7fj/F/LLeNDaGteAMAO2j/rtaM+CrtQKGIfjwmOAUCc3cB34izf8vx42ArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=RdWn+fYu; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="RdWn+fYu"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso3346012a12.3
        for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 19:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1708399085; x=1709003885; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wwoWyzzGbvDhYLt/HHNinqCKJIPrnZWwDw+6HpEjgRs=;
        b=RdWn+fYu+g0Jb6j5FqnPeMlbNwOCR/0nAD8oxmY+mGRI7r3l8JqzbpRg8+SE3Liuuh
         9D2IKgrrUFqYp4XdQruIS4/LSSd9iF1oqDmXLq/QfQm0B3Wrx3b6tyCbalf93/KI/JZw
         3KENznYiFi4do0Wt9vLFRcUQRfevwMZrYgdYRquFo2Py/7wftzuFtm1T8xDSB9aKGaWY
         b5nDeJ7FmtBwGPxC7VNYcp2BqTh74NCKWvIBhY3ExegD916+HNIoHT1RoeNdrriyUgxm
         zVtRJjrolHK6Hd8EIhQrGRlp23khruSuwgEzKCN1JfjfqwF6MWqV6gM0epjMiz86JFA5
         CHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708399085; x=1709003885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wwoWyzzGbvDhYLt/HHNinqCKJIPrnZWwDw+6HpEjgRs=;
        b=Ur9PS6453so9IRpHG0GZPCvxmOsRNFbuFo6PW2aMOtcjbYV4K2qKdWLI9OhDh8OuHj
         elIud94QD+SqpaZq3+untrBW1nj3nmNK/DZSN80UgH5y1gtw7+lP1i9BDUzMOtRy/kcB
         shGAuwCyP9xYO13RR5d6VmMn5BvxVJo7Su5T2Z6OkTZmilNlEoDmrGJ0X82Mj+bD9Bfz
         txygbfMIJhfkRXmvGDm1/8K0Bv10M3/kBDgmScEhA/dg20cVJHUkvtnepiwsT0xOaejC
         V5hcI51xu0rfyDeMzQuoi+xrcjtSo3itMKZ2zT4Vyy4y77WR6uCTi9QxK624u2gZ4Iuf
         hfwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaa2ljnQD4DY3J3aAgI2yxz1zsN1URgxOlspOzmTtROmkiK6WRNr7xQFnylWj8UISYR4xQXE7Tzd45QNCnyNgesg4nfBke8KYxOA==
X-Gm-Message-State: AOJu0YxN4BWtoUh/rr3PORxzt221v7w1BCNJcTs7gUcZS/ZC3b2F+5e/
	fCelhyRj4fzdjqiMJa6PQ4fx46ux8IHGNKQvNiup5+vfHDMslUc3eM+NM1i/vx8=
X-Google-Smtp-Source: AGHT+IG1+Xy3E9cePaKNkq7ca+AHo3EUSaVva4nyvFzkDnYkEwINOVdtTXwUQRSg8ii6ycStJkS6vA==
X-Received: by 2002:a05:6a20:9f08:b0:19e:3a94:6309 with SMTP id mk8-20020a056a209f0800b0019e3a946309mr18748257pzb.5.1708399084826;
        Mon, 19 Feb 2024 19:18:04 -0800 (PST)
Received: from [10.254.117.3] ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id x11-20020a170902a38b00b001d8d1a2e5fesm5295753pla.196.2024.02.19.19.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 19:18:04 -0800 (PST)
Message-ID: <54f0f0ff-12dc-44ff-a4f0-6e207cec7b64@bytedance.com>
Date: Tue, 20 Feb 2024 11:17:59 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-zsmalloc-remove-unused-zspage-isolated.patch added to
 mm-unstable branch
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 yosryahmed@google.com, nphamcs@gmail.com, minchan@kernel.org,
 hannes@cmpxchg.org
References: <20240220004051.3CB77C433F1@smtp.kernel.org>
 <20240220004939.GB11472@google.com> <20240220005324.GC11472@google.com>
Content-Language: en-US
From: Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <20240220005324.GC11472@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/2/20 08:53, Sergey Senozhatsky wrote:
> On (24/02/20 09:49), Sergey Senozhatsky wrote:
>>
>> Interesting, none of these 3 patches can be found in my inbox.
> 
> Okay, so the series is in the spam folder
> 
> ```
> Be careful with this message
> 
> The sender hasn't authenticated this message so Chromium Mail can't
> verify that it actually came from them. Avoid clicking links, downloading
> attachments, or replying with personal information.
> ```

Ah, sorry, I should add the signature header, hope this will fix it.

Thanks for your review!
