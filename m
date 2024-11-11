Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5989A142E77
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731338060; cv=none; b=VtyUC3tdfsV8RNZWUBJ7jvC01drFCw7+eQ2FkONkBXu5NVCar9D9DevPgpKgCGAZ/KLJ29riyFvC8KfaHjTqfqooO0bZ0WmFL8+9BjdjQJZyUOVADJDjDOSvaTjuTDZXeNC+jpBOhyUeO775ZkXqKemiqFw+pP+iDrzkehF2A5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731338060; c=relaxed/simple;
	bh=A3odoqc8RtFcWDGmG+7FqUO+KCU9oenTB9SJRPKuob4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hsEaFZhO349YEzcXil2hniCtGMrUMy5d0cLndMrJZlHw9FEafvY/eSaBs4j7/c9Kfg0c26FaA2T+/FAp5iUq6YSCY/jLtbNg1rfBdtt10feSE+okE8KNC0ufD3KCAoO1jTRr6tjG5iEM1WpXyg+WLkw3YfpyowhjpKwxFi28oi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=saDyjF1o; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="saDyjF1o"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3e600add5dcso2119251b6e.2
        for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 07:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731338057; x=1731942857; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iTacGNA4ubyqkMVNi/cE9nmeMeWyRjCbYUn5PSoszts=;
        b=saDyjF1oQHQJa9CCJbbKscDIFOy/FURoIM5UK6hr1VMkFW1no2ajCrjzTDn+o+ILa0
         WfOJINPx/PHd6shbBgssAOX7vVNPCeINIPmroHChC0kNBQk5GNfaDSvcAscS5d66AWNQ
         jCq6D+Kea+j3ifBAJwZJnoqiXFM0wtAlgdzdyskuuDjtOYzSPYFpoT/b1Mp4qrO69nO2
         B3mtA50XA4FeVCmr5PX4Y768n7CvSPQYgToNlIfSIo9PM6nR66FT4ilC1QAwqQKD+ZVY
         SJ/b6yQ9aauzXP6WLzzqiQsEKcw73KXXCa4Jn2AWgcBW+je6Otd0Dd/dy0OH/mCRwXmj
         oWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731338057; x=1731942857;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTacGNA4ubyqkMVNi/cE9nmeMeWyRjCbYUn5PSoszts=;
        b=Vjro+0vfyluh4EUnEnShLbu6TLnEj/DeRMtZob15WTZ9oTUxIdHIY3puOkuYt/MeRe
         3RAqVWH5tmoLz/d/ylNHQyDzgfe62ZcyCJD0b4qup19Azpk+w1EQeXiEznbvPeryDOyv
         O89ULWmytARFj8bWnnqPHTkp7Lf0rX2+uvE5WV3MNJkXqvYlxvXfTENPe82O5cuYDoiM
         a2fuyXpI2M54DUCs05Dd3ty3A14mjl4sKCKMpLST7eadRCFoZyawrZMExXx0KyAzPqyA
         ymrj+Duw5ehVyWgJdl5CjvzqrwbqEdacUEu1gW/8hoB/zM7YJ6zPmDwz19gHduzWEVAJ
         3pKw==
X-Gm-Message-State: AOJu0Yy6nF331Moy8LDG/rGJaUoKAOqJlAQb9NDCJTdl0bRVyuT6Y7zL
	QVc8XahcZtoz0o/fP0tbCXMdCdXSEVoDf5K+/4TzmYPfhYe6S0oqslshGajdaoA=
X-Google-Smtp-Source: AGHT+IFB15RhG7XG9O5WQQmv1h8oWUtwZFoYKsn4s0G8rE4QDmUkKariel9dNYf1AkSBB/+fy7rbOQ==
X-Received: by 2002:a05:6808:15a7:b0:3e0:4846:594a with SMTP id 5614622812f47-3e79477173bmr9687866b6e.38.1731338057425;
        Mon, 11 Nov 2024 07:14:17 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e78cd294afsm2112870b6e.43.2024.11.11.07.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 07:14:16 -0800 (PST)
Message-ID: <7a00249a-8a5f-4a14-87e6-f084c35884a1@kernel.dk>
Date: Mon, 11 Nov 2024 08:14:15 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + zram-fix-null-pointer-in-comp_algorithm_show.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, senozhatsky@chromium.org, minchan@kernel.org,
 liushixin2@huawei.com
References: <20241110061637.2A885C4CECD@smtp.kernel.org>
 <d720c44c-455e-4d02-b1f2-02544d48a68a@kernel.dk>
 <20241110181253.0ed6a90d5962edb1a8edb9be@linux-foundation.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241110181253.0ed6a90d5962edb1a8edb9be@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/24 7:12 PM, Andrew Morton wrote:
> On Sun, 10 Nov 2024 18:26:14 -0700 Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 11/9/24 11:16 PM, Andrew Morton wrote:
>>> The patch titled
>>>      Subject: zram: fix NULL pointer in comp_algorithm_show()
>>> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>>>      zram-fix-null-pointer-in-comp_algorithm_show.patch
>>
>> Andrew, can you drop this one?
> 
> OK.  It will generate a conflict with one of the 11 zram commits which
> are in mm.git, but this is very trivial.

Ah indeed... I don't have any merges behind that patch, so how about I
just drop it and you pick it up again? Seems easier that way.

-- 
Jens Axboe

