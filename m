Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290292BCF6
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719258401; cv=none; b=EZMtIYlDWOGTuFXhZXq305rMThV4NygXKLpEEo4AHDfKgMp72E4ld8bXSLC0zgVva3la7y1NDEr8MAcbzroxqEwSrfd3MUh5LaU7Z/Ww0kRX/CPe6iXstSmafhUxulh8yACmdveggOjh2GOTuy//lrWyJqFyyTBRMfQJ5EVirME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719258401; c=relaxed/simple;
	bh=HtGM43dsi9u/WxjopXvLOdvM+OlLyRYok3YG97+KrCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcS//8Fpk8sW5VIh3yJqmId6XjPSw0O7XQL6g404xUcTTyJjUK6oL/AvxmkcuyF23zbF//gQRNktSLrwMw7OkNkeHubwwLiyOCXDvSntW56dL8AX01aaDYAdW5ElAVpOIFPFdn+oQj8OB0RN2McKEsso/E2gc1A2APEI+845VMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lF0peY3o; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lF0peY3o"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70670188420so1578221b3a.2
        for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 12:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719258399; x=1719863199; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HliUZ1r9wILuofOMWBLq8b0miO7pn1Zfha8wO4fxzJY=;
        b=lF0peY3okz9KohBqJ7H9pE90m7oPILDoyIBnQSaPR2UKHh0H5NW4vIzta21fQqC5GI
         I2z4kCEvPJTqF0iXcQQZVDUdxlhk8QnG8P8BVXqP6gzj5EnHrzR2JweNpCxDMiqNS69y
         PJjl0F0s5xW+FX3O0A4jkNSQvGq3NEUgerwi/1S79bvYhj1xjY5Rl5Ud2OuK7u535Cgs
         pFa7enyDeTiRtve892h9gunIZOVLODUfDE0qJJAwGShvT22lkwFUsxeK07mP24DeyCVY
         FyucTlwBYK846mE7t5jsLaDhyRl43BNg4ohWImvN0/0QkMX2PQUOpZe7oJOwfCdEl6hZ
         I5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719258399; x=1719863199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HliUZ1r9wILuofOMWBLq8b0miO7pn1Zfha8wO4fxzJY=;
        b=F8T/isxRqxn74JFT2UbweLxR6VoAY8DNzpt5BChT4pN7Nk3qX7hInhkwSC/zQ2oBcw
         r93Swh/Fa1/wlgkfXTyyswlh1cRLlVuBCx82CHRVNKYecaltlkjTYewZV4M9xnoy5LTU
         IWWfKVS9ZoDk48VrZAHOF7+58pJ3usv2wvv6/LWFutJ0QnoXvpnzKYaaF83Mnzcv3ARk
         wRE2bytd5o7myd1mjiMCdrckyIMkwJNPQ/qBWY1l/ff+ca7fViUKk84e0UiX+onCSc8n
         gJesRI+rMJLJUQoed/nQfbrGPyDtwd7uc+Iu2o6otssEISLPXoz9S0CnWBRbhooVqDaI
         Lt0w==
X-Forwarded-Encrypted: i=1; AJvYcCWNJocUTKOPVmmS2GiDv0MSTDnTOZfdGNL8f58NiMfS5j1iS6gBxc5r41fWuEWGtNdv5Old5tqk2qbG1rcNEK4x7bAgYXCdAfWbmA==
X-Gm-Message-State: AOJu0YxeOpjI5dCwVrGDo5ohz+bxlx0SxTqAKel+yWmu7MWPrJSg5J3t
	PnCIyxYH2f79NjNDyFBEatAcPGffF2qkfT+oalxRhpzpyYrb+RBP
X-Google-Smtp-Source: AGHT+IGQczr3bz+qnpLT57LDv7qsC35fNL6YPk2tFcJNOCvBpMWQBevkwhjlSknPomxtfiVH/d3h9g==
X-Received: by 2002:a05:6a20:1aaf:b0:1b6:3fc5:d08b with SMTP id adf61e73a8af0-1bcee9507aemr4929032637.40.1719258399162;
        Mon, 24 Jun 2024 12:46:39 -0700 (PDT)
Received: from google.com ([2620:0:1000:8411:8de:a598:e093:aa31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-706706058dasm4055961b3a.69.2024.06.24.12.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 12:46:38 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date: Mon, 24 Jun 2024 12:46:36 -0700
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	terrelln@fb.com
Subject: Re: + zram-move-from-crypto-api-to-custom-comp-backends-api.patch
 added to mm-unstable branch
Message-ID: <ZnnNHEwKObM8qMiW@google.com>
References: <20240522223141.2F4A4C2BBFC@smtp.kernel.org>
 <20240624033323.GA3130923@google.com>
 <ZnmRDl_mZOP2XxtO@google.com>
 <20240624155132.GC3130923@google.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624155132.GC3130923@google.com>

On Tue, Jun 25, 2024 at 12:51:32AM +0900, Sergey Senozhatsky wrote:
> On (24/06/24 08:30), Minchan Kim wrote:
> > > > This patch will shortly appear at
> > > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-from-crypto-api-to-custom-comp-backends-api.patch
> > > 
> > > Hello Andrew,
> > > 
> > > May I please ask you to drop this entire series?  Apologies for
> > > inconvenience.
> > 
> > Hey Sergey,
> > 
> > I didn't catch up all yet but why do you want to drop it?
> 
> Hello Minchan,
> 
> I should have provided more context, sorry.
> 
> The reason being is that I want to rework the series.  For example,
> I don't really like the way I handle zstd C/D dicts and the whole
> ->init_config/->release_config for per-CPU compression contexts.
> We, quite likely, can move compression contexts out of per-CPU area
> entirely, and have a single context per alrogithm.  It's only workmem
> that cannot be shared and hence should stay in per-CPU.

Thanks for the clarification.

Yeah, then let's drop it.

Thanks for the help, Andrew!
