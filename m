Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943D514901B
	for <mm-commits@vger.kernel.org>; Sat, 19 Apr 2025 21:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745098722; cv=none; b=uGfkzcIuZfOe27TKFbkaVaquDYVEDUtq8ZTDLPia2vSfkQkCYt7e7AXi315LIIWocRALaidi1RIbO16e+IG2e88W0LWlPKGjbIgMU0zqDCAvY9bDq2jVFPsXQcHhxzcck78ZXlWEmCmoLvt/fkiHCAFhtZ2Pk5ZKRSWSjloZCEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745098722; c=relaxed/simple;
	bh=9h3/bLUDFF94aTkyO9sr/pk/6EBIW8lX0LtzR5hogok=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KlU6NkXJQfd6i2Us//u8X0PbezDmFaopuamxG+3tqGjfk7qkZeXYZAb/nzLXJeUsWFsot/urppTCeNJqBRIatjODgJ5uYP4CkBY5xg0FJ0mRf6O3MBEJqjZLXnKIq3X4fduhaNmNmGMeA0tmqjXbutAmBifdY4BsbNn2S40rcRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jCmNgyG5; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCmNgyG5"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3085f827538so3654988a91.0
        for <mm-commits@vger.kernel.org>; Sat, 19 Apr 2025 14:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745098720; x=1745703520; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=qeOz9nTjExTmJCGVi2l8XsCmr92nL7KMcEiEg/A5MtM=;
        b=jCmNgyG5qTu9yEjPB/iFcWCB0YHq9hZZJRQVL4JTpBpc4dcVd3KN8IS3ybbuUa1KXK
         gzCKqIlifi+73YPeKMQF9RgXCnyOIpty/pSrUAuKpRBxIzIaJdGORLaKZnkRlqgkyimg
         pml2r5nnPZyh9eKmi2tw8DozAegAP+ytJEAmVQ6WZGLGfT3Ioh3PW/PX0+e7gSSNVq4Z
         FDPGkiM5LZ/Rb0gLFY5Yvc9mOyc4X5Fh5s7YZDABanQscdr9cae/Tiaa0D+augdW/Qig
         AD62LWiLLJvF2/35zcZnCJMW/Ks5mgOTFRI83OwMBDrysdfPcCj5I77Vhr1P79CRZ6qR
         b3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745098720; x=1745703520;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeOz9nTjExTmJCGVi2l8XsCmr92nL7KMcEiEg/A5MtM=;
        b=buzIbLyJYnjrhGKKyfvws/8t3u+KWmbasc/v3Z3p5dDN2vEUpc+q8h2QXOC9jaET9Q
         xOhTynA43tSDEG4nvoYl3t8rvtOaJOSu7poiimTxEQoaIkWn9tZWBKmKmttJDDMrq24j
         aGyDwGInirWD3HEfgO93Q7ihv5aVoI/FnX0KxpyQMEPmgYBCRLuCpid1+hLL699/ak9l
         KnEULB66f/eDKudKtFASO50hDn+CSPtice7Qrr15kP0iFsZQUY5S1QwbpiKHuTSRh0cZ
         HIpV8UWtRcpzwiKJR8fcmBRdNLSHvJjkpmip7kimGpJ6seVQFlRDxjkNQpb5huXD7e3k
         1ZsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGRUiP13vlvVahmViG9i3gzVor00VyGGSAYemK881H4PBMLq1gAmjdmF1WOBCo2+P7GANDjA9tlEDX@vger.kernel.org
X-Gm-Message-State: AOJu0YyM3L8/TZEiehushQUK+aK26MZ7Szpdqtg2VkrpGStp4Fty+PoZ
	BeMyTg7J24xzkj2wWepqnpCZwY49UwBekAg7mi9je7IiCv7ISXlp
X-Gm-Gg: ASbGncsNAVD1TRhbYlVBD6PKmIGIbi+kWCxGg4gAQA9m/EmMRpSvYASismDb6zM0wCt
	8K1EKQcfxPI4su4DCZzNuyyaIreB5rBTjnPIbHiJEo5m170viZlTYhtiSAl/VimNiTl+2bru2cx
	KjnGZfckPFZeVy6LuIGgPOPv0gEUCtaM1hpcQwNWueeo4FndXy3LIwU//KISfZQDgExcEjAUcDb
	u78krlma/9jV77GztlaDF4vshb6XVv5vrsEVZtkEPg11kMMYHTP1LxzRl6wt7EhAVZJsuWCjrkV
	5TwxiMj57o29XScxLXcYSIoPWuG/92eZEBQoPYJ6W6Rt9kyWR2IpXDFrMuNb9jRhS75aQKgwmAV
	kmr3uYuOjGXWI4Q==
X-Google-Smtp-Source: AGHT+IGXpODXTS7mrQHkanpBjNW32M5eUxLtmfXt6eINOiIjYEBknzjsGkWJFBMqBrlQkvLgtjnFRQ==
X-Received: by 2002:a17:90b:2d10:b0:2ee:8ea0:6b9c with SMTP id 98e67ed59e1d1-3087bb53f92mr12058403a91.12.1745098719661;
        Sat, 19 Apr 2025 14:38:39 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-309b9a8cb27sm740981a91.0.2025.04.19.14.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Apr 2025 14:38:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <aaf72884-bfd1-4df9-879b-eaf082502848@roeck-us.net>
Date: Sat, 19 Apr 2025 14:38:37 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + x86-disable-image-size-check-for-test-builds-fix-fix.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 lkp@intel.com
References: <20250419205551.A8FC9C4CEE7@smtp.kernel.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250419205551.A8FC9C4CEE7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/25 13:55, Andrew Morton wrote:
> The patch titled
>       Subject: x86-disable-image-size-check-for-test-builds-fix-fix
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       x86-disable-image-size-check-for-test-builds-fix-fix.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-disable-image-size-check-for-test-builds-fix-fix.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: x86-disable-image-size-check-for-test-builds-fix-fix
> Date: Sat Apr 19 01:54:50 PM PDT 2025
> 
> fix comment snafu
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202504191813.4r9H6Glt-lkp@intel.com/
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   arch/x86/kernel/vmlinux.lds.S |    1 -
>   1 file changed, 1 deletion(-)
> 
> --- a/arch/x86/kernel/vmlinux.lds.S~x86-disable-image-size-check-for-test-builds-fix-fix
> +++ a/arch/x86/kernel/vmlinux.lds.S
> @@ -473,7 +473,6 @@ SECTIONS
>    */
>   #ifndef CONFIG_COMPILE_TEST
>   /*
> -/*

Makes me wonder where this was coming from. It isn't in my v4 patch.

Guenter

