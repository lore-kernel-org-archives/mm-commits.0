Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2322815FD13
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 17:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718385367; cv=none; b=Hm5Qkbk3RqumLLzGIFnWrkTusEVM0+nF843Zu44oXs9KFndfFqM/8QxuW1+r9d1gRmeOHmga64uK1STYfy5e+sr7FXymTKYSMS4/ftY5Gc6zdDctXPiwxfxLFN/VDyrH4nkWTnxWjqTBjjiJd7TFe44vx3l4Ib4ns6mQa3pYca4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718385367; c=relaxed/simple;
	bh=hnZnvlH1F9BtabAEW8gYnXfd46ipF32HZ6cZcDYaLkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+NzOwsaanHMntsXOveVusLwrxX+BllVpN43sRCLxpwqHiJimD/GFEQG1ImZeK4gYuuGZSEp94oGSXjIJpcJyUOLtmD+nYIjhuNe99ElrfE2QEIC9o3lm7DOQzJQNnuam6CwEczwMt9KCCk2aMvjQwi6q5Gic9hMM1NNMRcSt3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WH+0BNrN; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WH+0BNrN"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-705bf368037so2148831b3a.0
        for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 10:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718385365; x=1718990165; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O+mSfpHubNlCrj8R4KCT0g4qNVzkbyera+J8PQovZx4=;
        b=WH+0BNrNTwfqREurqB/n52G8npkSwNNMWdGorzoCML72gVKxvF+Mcyqv+vmHNjnkEv
         0V3YYSn8SPKXBXgwTzxc6JfOay46t4wNrJPmYYIJ42L43nvQxpamtGwvpTd7C5tPAIre
         xCjNHlFlyDZJj9TcPkg/2MP/q9Nq1iaNGV2LEQ3HTfdbfFx0pPju62+eoYFQrLiZDUBf
         zFOwOOHz596A+Ey060UpV/uwV0wlqXFon/FYUBQNcFwE00NXaptxjceoTnrR37TOPafu
         kSKewZbO2ffxOSUVdo1XHq6R8zpMeJqx4i9ZawA876PtrWp6w8LoX1LQ0CkNEc4WpZYe
         k0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718385365; x=1718990165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+mSfpHubNlCrj8R4KCT0g4qNVzkbyera+J8PQovZx4=;
        b=nKnHuwES11zvSFTdWUu6vrHdbfGQtuVQRYQPOTRY/L5XPG1gWJkuqX3ilIFkv4Vw3U
         BD8G0Nv5avPdrpwiwHVHsIZ+zrlxAK5KiObFA/cefj9liP0ajc6N28x4zNRzZi7AUQTg
         709/6xoJEQVbQUz0RFHCfHobUMr9yvsVIpf29xSYRqniad8PtKLsDKk09CEeWOBH/IJy
         ZitYFLMKAiSl++9Ut90dtJ1CUC74AQU0HE59gE/HNEuTpp6ZKbjsGIFS5Qj13m3hXMoj
         tvFh65Qj/C61zU7+L4GWsvf3OZSwj2asbDXggUSZm5qhUUrbkD2TpikeqLJXyIWy5U15
         f6VA==
X-Gm-Message-State: AOJu0Yx9FmroPWegCpKgIZdQh2QNDanBWDbV/RPCOA//r0vKWng+/YAj
	1+732pEiuVWkNfnZHru7HSILWJrklGFDhWvyd8faKbOSjqg06+FY
X-Google-Smtp-Source: AGHT+IEASibLM7EhZoaKRrfHcwzkRbVtOYVjUvjIakTI7wiMAVK8wl4ea52iYRuezdNE/sJbdaBYiA==
X-Received: by 2002:a05:6a21:3290:b0:1b5:d143:72f2 with SMTP id adf61e73a8af0-1bae8291d99mr4056485637.57.1718385365146;
        Fri, 14 Jun 2024 10:16:05 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc91f6a4sm3406209b3a.13.2024.06.14.10.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 10:16:04 -0700 (PDT)
Date: Fri, 14 Jun 2024 10:16:02 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yoann.congal@smile.fr,
	vincent.guittot@linaro.org, rdunlap@infradead.org, pmladek@suse.com,
	nphamcs@gmail.com, masahiroy@kernel.org, gustavoars@kernel.org,
	davem@davemloft.net, arnd@arndb.de, aleksander.lobakin@intel.com
Subject: Re: + gcc-disable-warray-bounds-for-gcc-9.patch added to
 mm-hotfixes-unstable branch
Message-ID: <Zmx60snJwvBsgUNX@yury-ThinkPad>
References: <20240524030008.78A1AC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524030008.78A1AC2BD10@smtp.kernel.org>

On Thu, May 23, 2024 at 08:00:07PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: gcc: disable '-Warray-bounds' for gcc-9
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      gcc-disable-warray-bounds-for-gcc-9.patch

Hi Andrew,

The script said you've applied it to mm-hotfixes, but the patch is
still not in mainline. Are you going to move it in this cycle, or
what are your plans on it?

Thanks,
Yury
 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcc-disable-warray-bounds-for-gcc-9.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Yury Norov <yury.norov@gmail.com>
> Subject: gcc: disable '-Warray-bounds' for gcc-9
> Date: Wed, 22 May 2024 15:58:30 -0700
> 
> '-Warray-bounds' is already disabled for gcc-10+.  Now that we've merged
> bitmap_{read,write), I see the following error when building the kernel
> with gcc-9.4 (Ubuntu 20.04.4 LTS) for x86_64 allmodconfig:
> 
> drivers/pinctrl/pinctrl-cy8c95x0.c: In function `cy8c95x0_read_regs_mask.isra.0':
> include/linux/bitmap.h:756:18: error: array subscript [1, 288230376151711744] is outside array bounds of `long unsigned int[1]' [-Werror=array-bounds]
>   756 |  value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + nbits);
>       |               ~~~^~~~~~~~~~~
> 
> The immediate reason is that the commit b44759705f7d ("bitmap: make
> bitmap_{get,set}_value8() use bitmap_{read,write}()") switched the
> bitmap_get_value8() to an alias of bitmap_read(); the same for 'set'.
> 
> Now; the code that triggers Warray-bounds, calls the function like this:
> 
>   #define MAX_BANK 8
>   #define BANK_SZ 8
>   #define MAX_LINE        (MAX_BANK * BANK_SZ)
>   DECLARE_BITMAP(tval, MAX_LINE); // 64-bit map: unsigned long tval[1]
> 
>   read_val |= bitmap_get_value8(tval, i * BANK_SZ) & ~bits;
> 
> bitmap_read() is implemented such that it may conditionally dereference a
> pointer beyond the boundary like this:
> 
> 	unsigned long offset = start % BITS_PER_LONG;
>         unsigned long space = BITS_PER_LONG - offset;
> 
>         if (space >= nbits)
>                 return (map[index] >> offset) & BITMAP_LAST_WORD_MASK(nbits);
> 
>         value_low = map[index] & BITMAP_FIRST_WORD_MASK(start);
>         value_high = map[index + 1] & BITMAP_LAST_WORD_MASK(start + nbits);
>         return (value_low >> offset) | (value_high << space);
> 
> In case of bitmap_get_value8(), it's impossible to violate the boundary
> because 'space >= nbits' is never the true for byte-aligned 8-bit access. 
> So, this is clearly a false-positive.
> 
> The same type of false-positives break my allmodconfig build in many
> places.  gcc-8, is clear, however.
> 
> Link: https://lkml.kernel.org/r/20240522225830.1201778-1-yury.norov@gmail.com
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Cc: Alexander Lobakin <aleksander.lobakin@intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Yoann Congal <yoann.congal@smile.fr>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  init/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/init/Kconfig~gcc-disable-warray-bounds-for-gcc-9
> +++ a/init/Kconfig
> @@ -883,7 +883,7 @@ config GCC10_NO_ARRAY_BOUNDS
>  
>  config CC_NO_ARRAY_BOUNDS
>  	bool
> -	default y if CC_IS_GCC && GCC_VERSION >= 100000 && GCC10_NO_ARRAY_BOUNDS
> +	default y if CC_IS_GCC && GCC_VERSION >= 90000 && GCC10_NO_ARRAY_BOUNDS
>  
>  # Currently, disable -Wstringop-overflow for GCC globally.
>  config GCC_NO_STRINGOP_OVERFLOW
> _
> 
> Patches currently in -mm which might be from yury.norov@gmail.com are
> 
> gcc-disable-warray-bounds-for-gcc-9.patch
