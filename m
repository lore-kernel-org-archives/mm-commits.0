Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C161F61C
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 01:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731288380; cv=none; b=dIbLAeAs/rzU5RMJrks1TKZ99gd3jmzNT+Om/oFnc+NllLcjTwSWJAQICBisdxTh487eRF8DdO5IDcgkdTmC/U56OIht8BIUqn2RIB5V1vRH8QjicX1YvCllC+opz0V83QQozDepTKB+kLhkM9675hw8+//mt9QgHacdmWeqMk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731288380; c=relaxed/simple;
	bh=HLwteaUOsdwW0khk77SX+UGPZ/yaUCGf3EagogIy9Kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=huKb748zAJGMJe10x9A42amzny0Sx9qt2KvLE8Kt1JQVDB6sHkztLxUyEh/egG67ifnX2Hn8ElOpL8ICLvrkd1WebkS15AsTJ3dlH/ERkyxMa12h2oNplA5uNQ4m9UXO2D9so3HDcwgArDXihXdN/nX1HqIQH2NYv5skr3Mbmco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YWhZzYxX; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YWhZzYxX"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20c77459558so36425835ad.0
        for <mm-commits@vger.kernel.org>; Sun, 10 Nov 2024 17:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731288376; x=1731893176; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q8aEGIAuO6oQGirem2ibvbg073YRGTjEGPv98s8D9es=;
        b=YWhZzYxXYTVEoU3hFBKf/Q6tFvQngGkkMs500wx/WcmhMQeVEWqfMeIrp1q/NN5QMe
         ba2yNdGSLmoKHyEL8RBZnaNAIUsEFnoyhhdnXdPt3I5NRxcni1xUcWBPikkT0OaU6i3G
         CIYYB0pmGdRqMWdIoI9lVwuE/SdLphcEdi1bDDCcw9JO7mfLVY++8EtsW2mHqd8QvYh4
         lHDrbdjzkoVMKij1AxIRcibYgNfw2zyaXERwDmP55g+Fwl5C3CKp2B8tSnda+0P6+F5K
         QcOofBc9UZXBy1sVMuEGfCoyqW0aLJkx9nZ5/OXuqbTz+hW40Z2TtTJEQXQ/bTdxp5ok
         dILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731288376; x=1731893176;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8aEGIAuO6oQGirem2ibvbg073YRGTjEGPv98s8D9es=;
        b=BLIAJBILgtmGVcO0JE9WCnB6ErCTj7r68TL7AML/hR3Bez+1iQUA0vC+N3SyqHKpAR
         rpHsz0RlZRv5uKeK1PNTBLiaHbP16qlGMBINpT/XhL2Y5P2ad2hQ75PpacxaNxUZrs3j
         MJmSyi97CTf39XfRtsrJxHifd3B0+w0S3MXnqrgaye9sXu8FzLhjkwPmR8yM38W4hJCf
         LEdlqeSw/66mJKGH9LbwZLONkNA5AcZls8SA924XhC+t8VnKYSs5B+D5bwaEcMwQCQG/
         sScJcmsTtNYsICKbHiDyyO3iJ4kix6X0JikrgNa18QHr1JYGFomCXuiEA4+8MxDOaMjc
         6ZIw==
X-Forwarded-Encrypted: i=1; AJvYcCXMTIkfMLj6NGbtLaptraHPHAM+JilF5/nB7dXmgR0rN0XFsxi/e97d8dXdkTTv9c1Up/hQU7lX+6Rw@vger.kernel.org
X-Gm-Message-State: AOJu0YxKGdz0e3xbe02vMxfLVk9/VbgVRuQwFR+tSAnAJIUkO0DrHI+v
	j9RuHU2KRm7JQfCZPGZqd96BcRgoCHHlpl428SnfpJTg7ylcwM721ROgdn1w5Nc=
X-Google-Smtp-Source: AGHT+IEaof2EMc0hSKInZwOLf961KSPKvHGk+64vyWqD3XoaBuHigNoQ55K9AyBsDfsULwHE+n3aGA==
X-Received: by 2002:a17:902:c40a:b0:20c:ecca:432b with SMTP id d9443c01a7336-211835d9f48mr175401605ad.35.1731288376061;
        Sun, 10 Nov 2024 17:26:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9a5f5fa84sm8321564a91.18.2024.11.10.17.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Nov 2024 17:26:15 -0800 (PST)
Message-ID: <d720c44c-455e-4d02-b1f2-02544d48a68a@kernel.dk>
Date: Sun, 10 Nov 2024 18:26:14 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + zram-fix-null-pointer-in-comp_algorithm_show.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 senozhatsky@chromium.org, minchan@kernel.org, liushixin2@huawei.com
References: <20241110061637.2A885C4CECD@smtp.kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241110061637.2A885C4CECD@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/9/24 11:16 PM, Andrew Morton wrote:
> The patch titled
>      Subject: zram: fix NULL pointer in comp_algorithm_show()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      zram-fix-null-pointer-in-comp_algorithm_show.patch

Andrew, can you drop this one? I already queued it up earlier in the
block branch.

-- 
Jens Axboe
