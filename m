Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B592C30FF1C
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 07:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760512398; cv=none; b=UJK/6hnyjk/TFYq5VjhLwsJI/oMTh/9Ib5zybesefGXDpJCPKir9wFPy9ogiR/pWDtrnPwRzXGrlRPLcUi6ytZgQPQvXHyAJRaFnh89+sCbdfrdgVs/Frv7936gAeVRmxlT2xeJwnE5xJe+sDC1YUdlqVGfdHTski3Tud80T+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760512398; c=relaxed/simple;
	bh=ylV+v6h9BtxlaH714arQUlRMjkah0bDOkbHexmIDeKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XJjgKXAvmdQijxPa3Xxd38YQsm9KbSKeQ3Y8WL5qg5wnMLSlvVpVvK4g4LRXG38Z15mgAvsyAsKIFM6GCwKWszV3ssii75ZKxY1GHRewY5rzma7I7ryi4r2seQdvtZ/mv7d13au51xE7ZFRUgXJwZIb9xxC4oom9CKr3xLL+VTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=irkkwNoj; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="irkkwNoj"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b679450ecb6so3423671a12.2
        for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 00:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760512396; x=1761117196; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=O3Dfcz+4jZSt2y1WN6yyu9hlb46+Zxh1T6+mmKkFiZg=;
        b=irkkwNojHppgXHnkHbikXHBdgR+hLKq3PmuOVX/aoMvPKECYMAhs3JII8yOXsMrk67
         E7yqorLeGNi0SNp06Uz/8bX4H0PMTSc6R9koew4yTAKe10oX6zBEJ2OtpXUJYRHDSwB2
         zdvDu4xPpwh6wPLN/aIACXVKQ6ZlG5rjm6GaVWGR/nlIJHv9vJQS/bqeEOE07sjttQRp
         6BQHc1lamTLlsgGYtW0EQhR3OsyrQQIXaKCTP67tERZjqrTvD0VLWniXDP0YNX4jyuh+
         2MFBCumTvpyYhS56G/GDTDX6lEyRwBm6+eKYDVK1kYVs5AjJ+Rd1TxJBxnaDVu7ofmZk
         v7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760512396; x=1761117196;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O3Dfcz+4jZSt2y1WN6yyu9hlb46+Zxh1T6+mmKkFiZg=;
        b=JA63KKeX53EERzcmrP7ISpddIoBgrVh3TUZY7UzL+oFjKWSdijmO7pxnyFH1JcY/M0
         hu8Xu91wIafPVfm3wMcD8MwporzcDTvX5VlsMObVZP5Sh5YdJIpoLxBA666rvzBNSJJ5
         91P+69x8cRhfsTWkj601wTjKlOs8B50BkZi1uB37P74fvye313efiykHvDl7YIB9ZzU0
         dImWKpVeCbEJzIrs1ug2Lkcvqhs9njsc/ifGOP/gF4s0gI0jH65lr9zPKItIAG91T3nd
         X82w/mtOvNzOpM/Cmg0/U1vK2IXu65orQY/F3QYjqgkXwAV0Ot0Oi7k3is11JXOKrUEG
         9Ymg==
X-Forwarded-Encrypted: i=1; AJvYcCV+DdxTLaqOAgv6CrLI/pODxaqsjR2FdYYGjq3HsOlt4tZtNqhrX3qDBJ9VEtC7l8ii/+GnvFs3nz8K@vger.kernel.org
X-Gm-Message-State: AOJu0YzQKIpSl38X0vt6TOIJE+2afpiFNqQsGgWLk2V0hMrOw9pO9zyh
	11ESm+LyVYvuxoOVC87CITqg/yzlt9ricojPJjvMxZ7lkI5i0bmTla1R
X-Gm-Gg: ASbGncuFEe0yroGiR11/dWYj+H7xI3m/T2DqNcSmkIT+q0rg2aOFfarNbsQPr9s+9a3
	DjhcxRAcT+/BDbEJGsuiuQJ9wj0Aut9H0L08iXEaqC2vnWGgKr3EMvIvx1wz6MmZUZandPTjEWh
	sglwIAaTtDHP//rsQviw223Y9fIoEoNFo/46p5J5ggD6gdXay1UhG3zUgDvz4JYtJ5IbUzKxtey
	4dq2f6grSwAZE15paHtkUMj6Onyfv+Xiy3rJWheDZlDxOF83ormctElxGXbuQFQUkeKm813KCch
	zmgBeajUslK//AISl8m65MQonh388zSiLQwibcZ8VbHiWdshRQtHCoRl1mMinJr2GISomjDwH99
	HuJCQa9J7wGqPuZ340OIR45+4kuLuSGkq4WUtrn4Hg/TTlARm3k1fwxCb6O1YHzjzt7P1hiF0TJ
	gFHPYI7YM7CKkCBaZ+bd5mM6alsK8=
X-Google-Smtp-Source: AGHT+IFdLwQgzYBZ6e4HfkBRabW9bDAIDM1P+0Y37kwV5e8QvCM/DOjGqqmVjLE+Wbx5p1YXzyy5rg==
X-Received: by 2002:a17:903:947:b0:276:76e1:2e87 with SMTP id d9443c01a7336-290272df714mr332480805ad.44.1760512395987;
        Wed, 15 Oct 2025 00:13:15 -0700 (PDT)
Received: from ?IPV6:2405:201:8000:a149:4670:c55c:fe13:754d? ([2405:201:8000:a149:4670:c55c:fe13:754d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f4ad6esm185497335ad.109.2025.10.15.00.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 00:13:15 -0700 (PDT)
Message-ID: <b0d02332-c24a-406c-b9bf-98b3e5ae1bc8@gmail.com>
Date: Wed, 15 Oct 2025 12:43:11 +0530
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + lib-xz-remove-dead-ia-64-itanium-support-code.patch added to
 mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 visitorckw@gmail.com, lasse.collin@tukaani.org, khalid@kernel.org,
 david.hunter.linux@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20251015030404.1E7FCC4CEE7@smtp.kernel.org>
Content-Language: en-US
From: Ankan Biswas <spyjetfayed@gmail.com>
Autocrypt: addr=spyjetfayed@gmail.com; keydata=
 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
 TRpGew2ozniUMliyaLH9UH6/e9Us
In-Reply-To: <20251015030404.1E7FCC4CEE7@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/15/25 8:34 AM, Andrew Morton wrote:
> The patch titled
>       Subject: lib/xz: remove dead IA-64 (Itanium) support code
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>       lib-xz-remove-dead-ia-64-itanium-support-code.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xz-remove-dead-ia-64-itanium-support-code.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
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
> From: Ankan Biswas <spyjetfayed@gmail.com>
> Subject: lib/xz: remove dead IA-64 (Itanium) support code
> Date: Tue, 14 Oct 2025 10:54:36 +0530
> 
> Support for the IA-64 (Itanium) architecture was removed in commit
> cf8e8658100d ("arch: Remove Itanium (IA-64) architecture").
> 
> This patch drops the IA-64 specific decompression code from lib/xz, which
> was conditionally compiled with the now-obsolete CONFIG_XZ_DEC_IA64
> option.
> 
> Link: https://lkml.kernel.org/r/20251014052738.31185-1-spyjetfayed@gmail.com
> Signed-off-by: Ankan Biswas <spyjetfayed@gmail.com>
> Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Reviewed-by: Khalid Aziz <khalid@kernel.org>
> Acked-by: Lasse Collin <lasse.collin@tukaani.org>
> Cc: David Hunter <david.hunter.linux@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   lib/xz/xz_dec_bcj.c |   95 ------------------------------------------
>   lib/xz/xz_private.h |    4 -
>   2 files changed, 99 deletions(-)
> 
> --- a/lib/xz/xz_dec_bcj.c~lib-xz-remove-dead-ia-64-itanium-support-code
> +++ a/lib/xz/xz_dec_bcj.c
> @@ -20,7 +20,6 @@ struct xz_dec_bcj {
>   	enum {
>   		BCJ_X86 = 4,        /* x86 or x86-64 */
>   		BCJ_POWERPC = 5,    /* Big endian only */
> -		BCJ_IA64 = 6,       /* Big or little endian */
>   		BCJ_ARM = 7,        /* Little endian only */
>   		BCJ_ARMTHUMB = 8,   /* Little endian only */
>   		BCJ_SPARC = 9,      /* Big or little endian */
> @@ -180,92 +179,6 @@ static size_t bcj_powerpc(struct xz_dec_
>   }
>   #endif
>   
> -#ifdef XZ_DEC_IA64
> -static size_t bcj_ia64(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
> -{
> -	static const uint8_t branch_table[32] = {
> -		0, 0, 0, 0, 0, 0, 0, 0,
> -		0, 0, 0, 0, 0, 0, 0, 0,
> -		4, 4, 6, 6, 0, 0, 7, 7,
> -		4, 4, 0, 0, 4, 4, 0, 0
> -	};
> -
> -	/*
> -	 * The local variables take a little bit stack space, but it's less
> -	 * than what LZMA2 decoder takes, so it doesn't make sense to reduce
> -	 * stack usage here without doing that for the LZMA2 decoder too.
> -	 */
> -
> -	/* Loop counters */
> -	size_t i;
> -	size_t j;
> -
> -	/* Instruction slot (0, 1, or 2) in the 128-bit instruction word */
> -	uint32_t slot;
> -
> -	/* Bitwise offset of the instruction indicated by slot */
> -	uint32_t bit_pos;
> -
> -	/* bit_pos split into byte and bit parts */
> -	uint32_t byte_pos;
> -	uint32_t bit_res;
> -
> -	/* Address part of an instruction */
> -	uint32_t addr;
> -
> -	/* Mask used to detect which instructions to convert */
> -	uint32_t mask;
> -
> -	/* 41-bit instruction stored somewhere in the lowest 48 bits */
> -	uint64_t instr;
> -
> -	/* Instruction normalized with bit_res for easier manipulation */
> -	uint64_t norm;
> -
> -	size &= ~(size_t)15;
> -
> -	for (i = 0; i < size; i += 16) {
> -		mask = branch_table[buf[i] & 0x1F];
> -		for (slot = 0, bit_pos = 5; slot < 3; ++slot, bit_pos += 41) {
> -			if (((mask >> slot) & 1) == 0)
> -				continue;
> -
> -			byte_pos = bit_pos >> 3;
> -			bit_res = bit_pos & 7;
> -			instr = 0;
> -			for (j = 0; j < 6; ++j)
> -				instr |= (uint64_t)(buf[i + j + byte_pos])
> -						<< (8 * j);
> -
> -			norm = instr >> bit_res;
> -
> -			if (((norm >> 37) & 0x0F) == 0x05
> -					&& ((norm >> 9) & 0x07) == 0) {
> -				addr = (norm >> 13) & 0x0FFFFF;
> -				addr |= ((uint32_t)(norm >> 36) & 1) << 20;
> -				addr <<= 4;
> -				addr -= s->pos + (uint32_t)i;
> -				addr >>= 4;
> -
> -				norm &= ~((uint64_t)0x8FFFFF << 13);
> -				norm |= (uint64_t)(addr & 0x0FFFFF) << 13;
> -				norm |= (uint64_t)(addr & 0x100000)
> -						<< (36 - 20);
> -
> -				instr &= (1 << bit_res) - 1;
> -				instr |= norm << bit_res;
> -
> -				for (j = 0; j < 6; j++)
> -					buf[i + j + byte_pos]
> -						= (uint8_t)(instr >> (8 * j));
> -			}
> -		}
> -	}
> -
> -	return i;
> -}
> -#endif
> -
>   #ifdef XZ_DEC_ARM
>   static size_t bcj_arm(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
>   {
> @@ -509,11 +422,6 @@ static void bcj_apply(struct xz_dec_bcj
>   		filtered = bcj_powerpc(s, buf, size);
>   		break;
>   #endif
> -#ifdef XZ_DEC_IA64
> -	case BCJ_IA64:
> -		filtered = bcj_ia64(s, buf, size);
> -		break;
> -#endif
>   #ifdef XZ_DEC_ARM
>   	case BCJ_ARM:
>   		filtered = bcj_arm(s, buf, size);
> @@ -699,9 +607,6 @@ enum xz_ret xz_dec_bcj_reset(struct xz_d
>   #ifdef XZ_DEC_POWERPC
>   	case BCJ_POWERPC:
>   #endif
> -#ifdef XZ_DEC_IA64
> -	case BCJ_IA64:
> -#endif
>   #ifdef XZ_DEC_ARM
>   	case BCJ_ARM:
>   #endif
> --- a/lib/xz/xz_private.h~lib-xz-remove-dead-ia-64-itanium-support-code
> +++ a/lib/xz/xz_private.h
> @@ -24,9 +24,6 @@
>   #		ifdef CONFIG_XZ_DEC_POWERPC
>   #			define XZ_DEC_POWERPC
>   #		endif
> -#		ifdef CONFIG_XZ_DEC_IA64
> -#			define XZ_DEC_IA64
> -#		endif
>   #		ifdef CONFIG_XZ_DEC_ARM
>   #			define XZ_DEC_ARM
>   #		endif
> @@ -103,7 +100,6 @@
>    */
>   #ifndef XZ_DEC_BCJ
>   #	if defined(XZ_DEC_X86) || defined(XZ_DEC_POWERPC) \
> -			|| defined(XZ_DEC_IA64) \
>   			|| defined(XZ_DEC_ARM) || defined(XZ_DEC_ARMTHUMB) \
>   			|| defined(XZ_DEC_SPARC) || defined(XZ_DEC_ARM64) \
>   			|| defined(XZ_DEC_RISCV)
> _
> 
> Patches currently in -mm which might be from spyjetfayed@gmail.com are
> 
> lib-xz-remove-dead-ia-64-itanium-support-code.patch
> 

Hi Andrew,

Thank you for applying the patch.

I'm adding Shuah Khan (skhan@linuxfoundation.org) who was missed in the 
mail.

Best Regards,
Ankan Biswas
