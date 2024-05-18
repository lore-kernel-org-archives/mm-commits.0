Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8856D199B8
	for <mm-commits@vger.kernel.org>; Sat, 18 May 2024 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716074428; cv=none; b=X1UJQ+LigbN0QBmGYPCnxCUqwO02BDSnDy0miASwtnFiap1t30UUCaKm46DZPSlU3awxslUvH8IQgwrftp9YiLtsY8tE+bUb+qc2LqEo78VwObs6uJAbMlnHaK58ENHE1SvM2gDJeBBvS+9XzHZHgPDU/X9wADzr3p5pGwJEGV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716074428; c=relaxed/simple;
	bh=TY3e1QtF3gSbfSJCBm1xr2bUZqU9MRdJwP0CWJlya24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iZhKl1Z+ixDrr8cBxNNCXITeq9Esf3ek2d/NWcrEp+iUnr7KvEmMDRFi6WVLumGWTWnoHXdQR8v9xn15gGsuvKyphAlb2OGZOX2OyZ2w9hvH+DqlyADTd6E3HTiPDABp9yX/6uQAPYlNpY9QX4dhHD06y4kbCwzgOjKOgbvLrp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=YBtekxzQ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YBtekxzQ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e651a9f3ffso41822645ad.1
        for <mm-commits@vger.kernel.org>; Sat, 18 May 2024 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1716074427; x=1716679227; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6p59kltDMFZoVHEYOd2Sx8M4cyUpYnclyK3vuxw5Y4s=;
        b=YBtekxzQp96crFNfS2e+/1w3bWndixwJtz+S4eXW8vNNe8ZbDIDeX95o3j3D71QU9Q
         j31ac4aDvDskBUfYH8icJvRwIX1Sez7H1y00a6B8u6ECPU3ZQwf0o4krmwQ+KiGQhNHx
         YvJ+wYK2TSxML82gzUOsDIcKmzu+mjazf47xU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716074427; x=1716679227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6p59kltDMFZoVHEYOd2Sx8M4cyUpYnclyK3vuxw5Y4s=;
        b=ZRgQX+6zLL2ZRAJDyHiAYNF47DRxaXohkTXO2HhTdw/JOjlGVAi8myoDvYMXD6CFIP
         F3T4Ohl0hNDIGvHUPacGUtdO/VXC8c9DxSeUcnZOryeKXW7/dqoSKfG9wOgB3lT/PIGx
         dfhQXmR+KnbFxNOT0Ze8SMGYID2+6kM2dPVpClipGrpZciH5pXCxRnn4L9ZTlr0rR4nu
         zXAmFv552C5auxJU+zGESS8PRuo+3aBRDsE0Zeq8v405bY5dB72+mv/N9vef1fLwLHnZ
         XrZPQ9H6mRigauafPXuS6ABJYzvFjhfjGUjkdis4qZ5BJpb3UplPpvHeVucwE5sSSBzN
         TmXg==
X-Forwarded-Encrypted: i=1; AJvYcCXnxSY+2aBLlz24hc7D/Hv77X7Ln/Iw1rVT++a9vHbYz2ONFh+2Vnk2eB7ViNPYoRZltC8Trcn92GYvWDBlNeDU6vN/0n/0XTS0Aw==
X-Gm-Message-State: AOJu0Ywp9ri4xhr+e4yDr0u+OtTE3L7ugoaYejb5/H4n5FvgIhWc2L64
	0blBUVF8j5FZU3M655gh8wchO2HvMhQFb42Y1SuPnwo6wO/E2DLbPKFi1LuMEgnubX71ZLMIFNk
	=
X-Google-Smtp-Source: AGHT+IF72GWsCylCsv3CTPldKxT3xhyI0CTP3imy13hKHAMgYYivlLUGIuS6m/F9Iq6hnlZptcONEQ==
X-Received: by 2002:a05:6a20:d045:b0:1b0:597:627a with SMTP id adf61e73a8af0-1b005976677mr17924361637.60.1716074426829;
        Sat, 18 May 2024 16:20:26 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bd5ee10120sm1848996a91.51.2024.05.18.16.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 May 2024 16:20:25 -0700 (PDT)
Date: Sat, 18 May 2024 16:20:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	pasha.tatashin@soleen.com, kent.overstreet@linux.dev,
	surenb@google.com
Subject: Re: + lib-add-version-into-proc-allocinfo-output.patch added to
 mm-unstable branch
Message-ID: <202405181618.4AE40B15@keescook>
References: <20240514202009.2FA52C2BD10@smtp.kernel.org>
 <5c047df0-266e-420f-9bcc-fdec16c9b16b@suse.cz>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c047df0-266e-420f-9bcc-fdec16c9b16b@suse.cz>

On Sat, May 18, 2024 at 11:03:52PM +0200, Vlastimil Babka wrote:
> On 5/14/24 10:20 PM, Andrew Morton wrote:
> > The patch titled
> >      Subject: lib: add version into /proc/allocinfo output
> > has been added to the -mm mm-unstable branch.  Its filename is
> 
> Hi, I don't know how mm-unstable/mm-hotfixes-unstable is handled during and
> right after the merge window, so maybe it's already the plan, but wanted to
> note that for this patch to set the userspace ABI with versioning right
> away, it should go in before 5.10 is released, and maybe even in the merge
> window itself so the version line is already there at 5.10-rc1.

6.10, but yes, agreed. :)

I'm really looking forward to seeing the allocation profiling land!

-Kees

-- 
Kees Cook
