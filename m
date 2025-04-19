Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62CE18A6DB
	for <mm-commits@vger.kernel.org>; Sat, 19 Apr 2025 21:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745099613; cv=none; b=bKKD/g9cG5eyOJlwdzP54gVJ5HdMkAycx6eQnNbWrx6IyKULkJFKZ4jwBQfj+FiGYVI7UKR06GDCrtPORcBAXV9s7NU+Wb6/aAcd9GvblYFm6TXj0KKGIotiMrXznYNGbD3xYaTJPVTQpA2EJ+xEZyrY1nAfoEeU0nNVrxjWg/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745099613; c=relaxed/simple;
	bh=YDUGmYkH+ICUtdulz2sgYzWnOcwzh8FavXAuQaA7Vc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2BN6T0qAp2yjHtd8a8eNht9wY2yap4pHuBftPZhdCHeJn8IOnY9/gXeu6dMd08AxMteAUwEN9YwMsGwRgai0Qu573DSR+Vrf/HSHmlUSFYNOPYR5hKNlHQCBJH5RnBP/qyDSQYxToQv7PKeIhLhIiq6VzKKSroLURR6QOlCZFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlHVF4qH; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlHVF4qH"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-736dd9c4b40so3515773b3a.0
        for <mm-commits@vger.kernel.org>; Sat, 19 Apr 2025 14:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745099611; x=1745704411; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=hCd5xPpYlPZEHr4G9CggYUgwenUkI3tZiN3dGj+k/80=;
        b=QlHVF4qHT8kL8nLqPYx7qjRal1Wtc+y9SuAgUkroU2ZKbF3aH6MkzD0FCjZHLOWvhq
         sLwmbqZJvV/oOf/tuT3bIhxUnis+HdDUXi14iu56mRdMHi2yqHPMR6JlgoQylQWEoABF
         RkqXeSI86obioK/ZnexaLrFWnhtrM0hSoNODLDcKynWLxd0rQd/nYD2dEPycBHfpQyhY
         TDLWP94wffscfhVefCTcy4co/cV3WsUyCacnklqSFCj0RKjvQttWtXK4745NX2rw5GTM
         CqJ4rkCzLvfTpXxC428hYta3GbCJBbA8KeEtw4oOwJ5gWihTo9Ev6nG6kTQivG/sOiYH
         O4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745099611; x=1745704411;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCd5xPpYlPZEHr4G9CggYUgwenUkI3tZiN3dGj+k/80=;
        b=n3+sCi7Y3hysTLFsSMmDoMgIqWK2lN2W3w5fowBnRFr1KkyaqYCsCjEQ1QIcX2C0BE
         FrDIX8YFS9GpuP0WJeR/v1qUgC/iYvX6u/BZ/kJYpkjQNdg52X08uswPAQTLmen1hae6
         t5rly/81ejHgByjNNLVedF/UbJ5ii8edjKYERKC+VdaF1mny47CuMo12rFNuhIxUipJb
         cgUsezul2gfubXa68XE09IcrPTDUiMngKd8LdBInEXfA/BkNH5zVy6AZ55T5gZs7WPR5
         OmDyVOKUXxTsEdw9qRVcRXyXQxmVSCw+boW2DKXxpTkouHKHB2C9WtEjoGUtz5SUsPYb
         PMgg==
X-Gm-Message-State: AOJu0YxbstSEOg7aA/7dAzHfwwyCqNeCx/P6z+/BA8dIvDsEOvqnrzap
	q8X9w/Y80DeknGOjX5aTLD4z658ybP4rmyi4sZEt7vpNg95f7eQmvy/ZiA==
X-Gm-Gg: ASbGnculIR+NsX+rHdfEgdF97FUkAYkK0C4eHNHptKYFwXViMbXffXu6VCreJgfhBNX
	QvrwB/PhFj0Yfe+q279J3vkZr28hT8AM6GQSs2ZCW9Y6nXkju8tBalyY+TwBtKKqQnVRRKhfb9/
	fRwJjHxNZW9rh6EU3kjG147Lw2TDq9HGoAIqIZVyNqu5tfFHCmbFM2gscWkXLdYfNGsEKiTr/1T
	iqQMDXsoM546uV58mMS6HQ2g3XijfldhUzZca7GUiG/7dMfJuxRfcnkQXu91FR8nBCk2e1MfHrF
	c4kzmYgR7Q3htkx3kDblOm+RGyhr26aeO10ORfLQSg76jgB+qRLqKoRmKlT5NFx9jJ8kDaQSDYW
	Ryz6DeK93TWa0tg==
X-Google-Smtp-Source: AGHT+IEg4rJ3xingcm6w6lmrsP0aJgn/nUhykv05SI/rYTjLhGRD/ipNadDob9KqELaTDBEqGBfO+w==
X-Received: by 2002:a05:6a21:6481:b0:1fe:61a4:7210 with SMTP id adf61e73a8af0-203c94fc959mr10247725637.2.1745099611000;
        Sat, 19 Apr 2025 14:53:31 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b0db13c76f6sm3257302a12.40.2025.04.19.14.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Apr 2025 14:53:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ac86db8c-3c24-4e7f-acbb-7c40654c24b4@roeck-us.net>
Date: Sat, 19 Apr 2025 14:53:29 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + x86-disable-image-size-check-for-test-builds-fix-fix.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, lkp@intel.com
References: <20250419205551.A8FC9C4CEE7@smtp.kernel.org>
 <aaf72884-bfd1-4df9-879b-eaf082502848@roeck-us.net>
 <20250419144921.4753e30db8bd36c21108e522@linux-foundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250419144921.4753e30db8bd36c21108e522@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/25 14:49, Andrew Morton wrote:
> On Sat, 19 Apr 2025 14:38:37 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
> 
>>>     */
>>>    #ifndef CONFIG_COMPILE_TEST
>>>    /*
>>> -/*
>>
>> Makes me wonder where this was coming from. It isn't in my v4 patch.
> 
> See https://lkml.kernel.org/r/20250417230426.AA502C4CEEA@smtp.kernel.org

Ah, ok. Thanks for the clarification.

Guenter

