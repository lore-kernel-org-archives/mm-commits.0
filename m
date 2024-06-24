Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7231EB48
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243027; cv=none; b=Hv1C6QukBbtTDtS9zkc2iSf18/n5+HilHZ9T3KvQPAvtFRo1WDxEszYC1eFLRpNcFkkLOpwBiag2+uvXT5/noBwFyHWAKMdwXlbpeqAb/FKeG9ibPELVixtoOX24poNpX2JEvlaJGdkG1ougIfPUKl0WfElDF+WaROOc7ktD+iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243027; c=relaxed/simple;
	bh=y1kcVTNbd8eoBuO5PoQ0ocONMaP+k/OgIzOWQpJGznw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAaFIJZcjmKMEKIo+SwgTMfYfFSLWsvit9CtA1y/vqfDjmwFDkGgnQ5rjsCbHiTYyoFCZNMb/Sd4FVmC0PZz/l3inzyjkl8lmF7mjjdWxwSWwNPkj1O9eO9jufYBZqAoqVqE9mUaiLHzVHdHna1zV1fIfLBdnMa7Jd9F2x1sud0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ub2saVup; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ub2saVup"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70670fb3860so1273809b3a.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 08:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719243025; x=1719847825; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/O1oyJ8YBa2/FXWzhfogUi+H37oPDIopdN+4LetOLQ=;
        b=Ub2saVupLFXlN4oF06PTilu1lduAL1O8u1qqI6LxuU3bC2kRMAYyabV/pScXcmOJ81
         /hnDKoUTW7SSVUWbyQUB5zUaxci1v4upkl0pfT3fv0f+P6knpqzFrFXQh/k9PaIVYk5B
         sNxxDCkhc/q10k02WUNcChAg0GhXgKoMqeL9vvwXpOFLLMBajNchffonqhHwCruvYfQC
         FQi1Xj0fgsiepvnSwQdoJZ2U0KZBw3AePKHAKQUMJCDPA36N58LXavzzLPB0Dx5tRugU
         BAnUnkmTD3XOQGsp577uW+Ov5jzdl496lHhuvP17GzG+wG/g1GbHYRQSIvBTs6xTdDcC
         rdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719243025; x=1719847825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/O1oyJ8YBa2/FXWzhfogUi+H37oPDIopdN+4LetOLQ=;
        b=UNx8qbpSzudODr5AejY9tFs0pD0PVamGGiUW7Xmlp/7BdiZb8rQRps1OkuygA1LqMt
         Rd1kV7DrigGthRbMROFML++64OQC+MFWdEEDoNVP7lTMepETK/w3DJm/7ofon3WarMUs
         6RjB1CLHiFoJORPyE6FHmIxXL3l0ny5wy5fxPg2ny0DqFwsdxo0HScI0LUEc0/ZCbAFv
         WanOggt5WiB7y/TJ8ICmE/pMMy/TMu9CMQiWeZBk+EWUeXli0cc0L6t7AYcsxcYPKcYf
         FmQV+UzYL2AcU7+PSO/lCIe7NqEqLTGUUPDftdrTiROypdVOe3UureuRM9mhmMg2Svp6
         RqYw==
X-Forwarded-Encrypted: i=1; AJvYcCXVrQgY2aL+Zox9PAWaOZlrj1GAiFxUImsJ4fu4MEmWeocappNYKt+UGe6AFaKgISdzSnN/KmCqJyl6Vg4OZ1jkYJpxmpkJk5ZcRA==
X-Gm-Message-State: AOJu0YyWhblCpBAWZSlE2jKgJU8rH8DekPfWU0xmaIKEFok3hV8iXtvT
	AQ8vQc7SC7OhVwk5aFgPZmC1ZjPfx4j7BHyRIaA6Za5+GmN1nxeWeR2CWQ==
X-Google-Smtp-Source: AGHT+IGosR2r2/xqxr5MU9PSXdJJNqFZpc6KNAOgdIOkm/g13S1U0z2+50DnuvechELCegXgKxamSg==
X-Received: by 2002:a05:6a00:139f:b0:706:3204:fa4e with SMTP id d2e1a72fcca58-7066cbd0820mr7269590b3a.0.1719243025373;
        Mon, 24 Jun 2024 08:30:25 -0700 (PDT)
Received: from google.com ([2620:0:1000:8411:b764:aad:15a2:873c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7065b9c4bbbsm5571821b3a.57.2024.06.24.08.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 08:30:24 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date: Mon, 24 Jun 2024 08:30:22 -0700
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	terrelln@fb.com
Subject: Re: + zram-move-from-crypto-api-to-custom-comp-backends-api.patch
 added to mm-unstable branch
Message-ID: <ZnmRDl_mZOP2XxtO@google.com>
References: <20240522223141.2F4A4C2BBFC@smtp.kernel.org>
 <20240624033323.GA3130923@google.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624033323.GA3130923@google.com>

On Mon, Jun 24, 2024 at 12:33:23PM +0900, Sergey Senozhatsky wrote:
> On (24/05/22 15:31), Andrew Morton wrote:
> > The patch titled
> >      Subject: zram: move from crypto API to custom comp backends API
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      zram-move-from-crypto-api-to-custom-comp-backends-api.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-from-crypto-api-to-custom-comp-backends-api.patch
> 
> Hello Andrew,
> 
> May I please ask you to drop this entire series?  Apologies for
> inconvenience.

Hey Sergey,

I didn't catch up all yet but why do you want to drop it?

Andrew, Please hold on.

Thank you.
