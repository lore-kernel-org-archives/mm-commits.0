Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A621D53C
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 15:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719244298; cv=none; b=TJgb+PrQWBCmgGzwrl2cZxthWlN/bEiZb+zDgWq+/cszj+Jm5a51Qdm+ymP72LBG+4241wesPozwy2xKXQPaqvc2boackOXX0HAIbfSjjQ81nghLEkjaLjzhV8bktovpS8nNxCPe81NsqLfnp1x6bEwv5GkDg0+VkeiajrwhzIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719244298; c=relaxed/simple;
	bh=o3KUwvtG0oKLGyCJwkpAXGHMmFvfZG1bJDmq2MWu7L8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6qVYCSJhi6Yn2FccNDo3cwCgIabN9J4akNKzZa+ajubhIxrTxkqmSq2f+wIPEvjmOF2M6AQEEr8PlX9/n1LGllfWNXVcrjQeou4sNrCGZ5YhUoxYK7+cnGkLV4eDAmUN6KJrK5XaQIKGXISENI7bGJN69etJ5SBNlzoLhuNx5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=O9TjPacG; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="O9TjPacG"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-1f6fabe9da3so36650235ad.0
        for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 08:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1719244296; x=1719849096; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=APJP8MRWRwr/vX/WiQGpc4yWOw6FfBq6TVL/JNxin4I=;
        b=O9TjPacGvYlWtGkV3drD0HuHNzqMWE92xKdpwBQMCEB4hKGojcXicsW1z6cE4oOW2C
         UNnQp7u+VXgxoPqXEq3iO3C9olg/gJrITAMlAFIbvhXM3aFQBVNwwovD/MGrsORQ7P5Y
         yYv4rfLJnmi1C1gjcgVS/ciZ9rLMikSIzKVH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719244296; x=1719849096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APJP8MRWRwr/vX/WiQGpc4yWOw6FfBq6TVL/JNxin4I=;
        b=iCtzC+OEWhJgnZEdLwi+HVtGYUgvjfE4elSKaBtBueGws2uZAEi03RFoKeTRZ9UwxU
         ZEr3yZ8/esarsys65hEWrCWUIGSEJAFEVA8bIxwUfZV8hpIASfDcDjO1SwRaJGTuiXLP
         pF8fiVHH3ZEonRD51yATUb/2SHuZyr5uozIy1gxo3Mna+cdIj69KPcSfRg/mp5tK7OoT
         Rli0GbARITTS/N2hoQxZ0KnzhgqNvg960IaMe9H8yvddKs6rmQSxO2jAxytfKXARyUJg
         jtcpILtqO280q0KaOx4hFi4wCcvUowwqxK7w7S5d9pnU1ePmlRKEZvl3arPbmNT8yFec
         1mDg==
X-Forwarded-Encrypted: i=1; AJvYcCUUU+HdIbRuqOu25qib5bYB9/EQ/d1k17ErTlqUTZ35+eMcED9OqjaJ3tmnvp8XbSnCAyVoXYknnhW3zFwfGWenH3U28scJ5xHlRg==
X-Gm-Message-State: AOJu0Yx3zOgMwjA+sd/v87VTDuShju+ztIK+zzPCjYeo+L5KRdXOGS8K
	IN7L9ba7b8xYdfkxBQdS78O8RVxTU+m7g5zu0tdtw8zW1lfRY7l169X5AyusYqcADjfMPUNhdVi
	O7QDn
X-Google-Smtp-Source: AGHT+IG1JPO2czQeAc1JjcxnO5q9dmTnI1fR3uioyeLDOKlLWiko5Rgb8ksABsz+kZbSQ4Rdpul7Lw==
X-Received: by 2002:a17:902:db06:b0:1f9:c3e4:4c0f with SMTP id d9443c01a7336-1fa23ee571amr43172375ad.34.1719244296432;
        Mon, 24 Jun 2024 08:51:36 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:4e6:bef0:f574:7d51])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb2f02e3sm64549975ad.62.2024.06.24.08.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 08:51:36 -0700 (PDT)
Date: Tue, 25 Jun 2024 00:51:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, terrelln@fb.com
Subject: Re: + zram-move-from-crypto-api-to-custom-comp-backends-api.patch
 added to mm-unstable branch
Message-ID: <20240624155132.GC3130923@google.com>
References: <20240522223141.2F4A4C2BBFC@smtp.kernel.org>
 <20240624033323.GA3130923@google.com>
 <ZnmRDl_mZOP2XxtO@google.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnmRDl_mZOP2XxtO@google.com>

On (24/06/24 08:30), Minchan Kim wrote:
> > > This patch will shortly appear at
> > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-from-crypto-api-to-custom-comp-backends-api.patch
> > 
> > Hello Andrew,
> > 
> > May I please ask you to drop this entire series?  Apologies for
> > inconvenience.
> 
> Hey Sergey,
> 
> I didn't catch up all yet but why do you want to drop it?

Hello Minchan,

I should have provided more context, sorry.

The reason being is that I want to rework the series.  For example,
I don't really like the way I handle zstd C/D dicts and the whole
->init_config/->release_config for per-CPU compression contexts.
We, quite likely, can move compression contexts out of per-CPU area
entirely, and have a single context per alrogithm.  It's only workmem
that cannot be shared and hence should stay in per-CPU.
