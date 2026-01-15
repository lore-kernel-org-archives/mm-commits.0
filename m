Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6500C2989B7
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 03:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768447757; cv=none; b=BLYljDaW2lM6xljD5auUzJJFMtKhmcRmKvoER/kL/+Gnc1wHhgkj3JA76ro48A33TsKg1VQ+sjKo2fxPnJE4KSKwkCLg7zNweCynPmHiiOj/MLVi12cqRH2wpHNboBM8gWkPSO9PEyWNhd0d7CJwU1Osc82h6B+o3hbAr+P8+XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768447757; c=relaxed/simple;
	bh=GXzCucEP4U4d06YnwGx4swRSyNabUzq4A6TJU7ksbJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNPjTOp+Q3f8uN3KU8avfVc4Spp8LUG9rrvjRwCKB/RsPZ1ox6+Q4S7PZtxxsEl4dPn3oJXMaslWGB2z4Es+MyygDhw44WBzanYJE9nMw3ifBfMLeutUkDcfSifB6hYAGhbdUlPL5f+7KjkFq7GgpZxxcYjXm5fw7Y09UT/0caQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ORGQSnJ7; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ORGQSnJ7"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a09d981507so2553085ad.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 19:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768447756; x=1769052556; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fG3Vc3WiUBjc2KqNZ1L0gXK3bs9M6lOXFx+YeS/FATs=;
        b=ORGQSnJ7plkpUEPxghgCOOOb8KljvRrhDaclaO0Sb+o4doAX6ZnPBQ+nR49zJdBGPh
         PkZc21t21eg9eooq8Ol0DAswbTCx5rhZ7sN9tamPo+qbwkRRT24ALFN0pBoPxaYiPWmQ
         adv3tLNbtxDerBNALE94Qf4Mbizcq//6J4nik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768447756; x=1769052556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fG3Vc3WiUBjc2KqNZ1L0gXK3bs9M6lOXFx+YeS/FATs=;
        b=Hzf5QY2F+j7pmNwvNa4GBv6aL5/jdTD+5OrHHiljiGIa+CQGVuR04cp0G6DfTCArY6
         UDxjzDmKL38ykdGCA37sb2N8Sz/5zQSaWfgTqOhIAcTleyVgw+s+8edi4S+Mnrq0nAAU
         HtLySI5gVe4A6Be1+2gJHrVVMFSHjVDeKB2EZI+Vyoh+YIXw644EEFEOU859MpNpbw2I
         pkcKpVHQXyEu+lOdNfGjGkBBFNfEElbyLH+B38aL/yogkcmKYj0lv4BLJaFFdAx3pfLl
         vsyXUT+qgEDDp0zBmTbrRRonqOmkAMclPAJDRCj672JcYliC7oiUpfkX2B6WNjXF6xa+
         ok+w==
X-Gm-Message-State: AOJu0YwGhzMfOUQ4JGUfn05shnUzkJEZINnvEx3ryM4BI++m43jQCt6k
	SIOTTGuUmL4Z2c9wh3x9a/rs2mqHJ40Dr0tbZwrsecI/gur45+oHpsA315ikJX7rCQ==
X-Gm-Gg: AY/fxX73a1iaDB1hm9kjsRIgD+gIKky1tvJC6GVmOtO/Xb8nE09je6Vk5YSsfa1RSc/
	WN6425oxpSdV/9OiWDUze4iW/H0L23S3KuWW837IrPRBvXxWyqLqI+vLU9wj0zsza4DVYAr/+Fu
	hCh1UsokxfLYqvBhMXtsgt/FsEXAs2UG/JgICF+2FEoiL4tIrEHwboyJ0E7O3iMhOz/PyN3awj5
	UeleghKpYcMBUAJfa4wkghQL5zWfHDNse5NUm8d3m9S0FTIzSSxn/aNSjwkKn4ElXxDRsjoTwEU
	9r12Tf+hQI2s7aqWgoI122jNusK1gKTkscDN8qu3R5eAmIr5Hp06NIink6Lb5s8B9twQ8Nrl8C4
	Pd8IK0GCuQjpgTz10x1dPnm3/oIr5ATtldP0jJcft5tNsIE0jMtJ4/OHuzScx24J8r3BgBdv1me
	gsUZWC2Ay9aCXETinxwE9L537JMQ/rtOVAPWpSZquh1RlTzJE2mbk=
X-Received: by 2002:a17:902:f650:b0:2a3:ccfc:4de5 with SMTP id d9443c01a7336-2a700978f8bmr17471585ad.5.1768447755420;
        Wed, 14 Jan 2026 19:29:15 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:36c2:991a:5236:1fe5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352677ca922sm690837a91.3.2026.01.14.19.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 19:29:14 -0800 (PST)
Date: Thu, 15 Jan 2026 12:29:10 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stevensd@google.com, richardycc@google.com, 
	minchan@google.com, bgeffon@google.com, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: + zram-use-u32-for-entry-ac_time-tracking.patch added to mm-new
 branch
Message-ID: <rc4caal33f7sapv72owyykmvrdxbc4yp53tf26rkdyv7pz5lbe@ikt5l4ddmfrx>
References: <20251216022727.578BFC4CEF5@smtp.kernel.org>
 <aajymtsa6wesyjvh73uacvm76mi3qhn3nzqrtie3xu67y2sevx@5ntik7xg5n7d>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aajymtsa6wesyjvh73uacvm76mi3qhn3nzqrtie3xu67y2sevx@5ntik7xg5n7d>

On (26/01/15 12:25), Sergey Senozhatsky wrote:
> Date: Thu, 15 Jan 2026 12:25:39 +0900
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: mm-commits@vger.kernel.org, stevensd@google.com, richardycc@google.com,
>   minchan@google.com, bgeffon@google.com, senozhatsky@chromium.org
> Subject: Re: + zram-use-u32-for-entry-ac_time-tracking.patch added to
>  mm-new branch
> Message-ID: <aajymtsa6wesyjvh73uacvm76mi3qhn3nzqrtie3xu67y2sevx@5ntik7xg5n7d>
> 
> On (25/12/15 18:27), Andrew Morton wrote:
> [..]
> >  static inline u32 zram_get_priority(struct zram *zram, u32 index)
> >  {
> > -	u32 prio = zram->table[index].flags >> ZRAM_COMP_PRIORITY_BIT1;
> > +	u32 prio = zram->table[index].attr.flags >> ZRAM_COMP_PRIORITY_BIT1;
> >  
> >  	return prio & ZRAM_COMP_PRIORITY_MASK;
> >  }
> > @@ -225,7 +224,7 @@ static void zram_accessed(struct zram *z
> >  	zram_clear_flag(zram, index, ZRAM_IDLE);
> >  	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
> >  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> > -	zram->table[index].ac_time = ktime_get_boottime();
> > +	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
> >  #endif
> >  }
> 
> Andrew, I sent a fixup patch for the previous patch in that series [1].
> This chunk is not needed anymore, as this get_boottime conversion
> simply should have never happened in the first place.
> 
> Apologies for inconvenience.
> 
> [1] https://lore.kernel.org/linux-kernel/20260115031922.3813659-1-senozhatsky@chromium.org

Oh, no... Please ignore this email.

It's the other way around: this patch is correct.
