Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F029917BB1C
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 04:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734064091; cv=none; b=jUNCGAGccCeRw4a2kWcVWSXjPD4n+gVexst+RdaM6CbR742+SWvVrh20hE33LxlPmqzpMZWC2Uv73BX7NvSBzr+TO0lt1vCN9+GoY0iAVeKn7vplhi80cutUY8KoB2eXDwmO54HxRL9NvgJP5zXF4+9ilyTMwl3bAXOY7tqufzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734064091; c=relaxed/simple;
	bh=C34HmViexd6pC4Q47HYURGyZS/KpgGPi0NINujjjSdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z37hQgZ+InJfsoZN5mouVWxv/QCyLYq0AGsn/KFVCmmPNaW8PuzofpuXe6abT+05YbJWZShvLUFe0DPi6jjhLpvvHgAXEmmYaRje08XhQ56foNdJSBDg1RGo7YY6Qxjj/GgQsDmOQFMY0d+pCagwAdmfkgZYra82C8AVu6k6pbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jBO+NfAd; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jBO+NfAd"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-728e81257bfso1104267b3a.2
        for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 20:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1734064089; x=1734668889; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fycz0Jqpx4aOSEiJrWv0ZWbaFdp57efmCepw8Y45Yq8=;
        b=jBO+NfAdkofSuFKlYMVV62oYCmR89Ehu4cEX31J87+nCYpfDou2VWKMTl39VVrNjNl
         vGsavFgD92rBMK2Jt0+MY6hCsCYPZSoypbS9qcmbFI1p3dlObt+j7+PVVeGRYdTKA/za
         SAXHnBKOoUIIoPm2dvBSkKA2jJ426QyNau8bI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734064089; x=1734668889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fycz0Jqpx4aOSEiJrWv0ZWbaFdp57efmCepw8Y45Yq8=;
        b=URA8J7ik2KsJVQB3HnUk/vN0lo9vxMXSNepGvpyuzPeqRtKj+3qu/SjyoEyLpAI+4A
         +Sb17g57Jd5ohIBeGFDiqEYn5yAZp+mz8oar4rHIPuH6oMR48ODHMM948lQC9DGYuii2
         P8YfZIETUit9l6O0X05S1/U6KoqlA344i/3RFga6BUX3htcU15/+YtF+IMvpbfXhC2wm
         Hc6VqtawDVS/lSk/KId9u5cKDgpaJYok6NEkdCUjyH8fnp5dYsA+3ww/HP471KNBYvmE
         AhZ07Ct6h6rL/eDm0ACAct1Jcmc1PefQJ9oimnbfCR9FxWPWc1mLJCONfGss+leSlf7R
         tHAA==
X-Forwarded-Encrypted: i=1; AJvYcCWoeHUdexhRfrl49iIeLeotOgATOyw1iuMI8iA0iVIPW62hzEYOkYZC9N6UVwIPY6bQLZVoqxeB0nZe@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3+0wuP9GEqAOcYS9V4ur9SB33sMnT4cZ42ofYoRA5kKAlbVqI
	ai76oGFKINIupJ/p7p0ziuOVwLQ1dapYIkwp5oko30GMJjohMmDUM9aTTs81eQ==
X-Gm-Gg: ASbGncuhvGeSHOLnA9KmFF1KhjLK+8eebqxdqhRGG/pnbWnn0atn9HlmuGpXYmxniHN
	GYlSfVHielpT1dinMhIlfElucghyegR4fIKj9sDdIzQlPbcRYVCm0miEoW04ydtEVWe8Vv04vzR
	1MaONE7aZuShlfgcc8ymJZg997IiCvi1Y8sTRfwa/NHVlRMJtfsQV1X+dIRYLREGES5JHQju0An
	XnOq1Epyz7aZYN/QOIf7zaphLZiM07X7EDV9S/GRM6KK17KQxtcTZKVYbP0
X-Google-Smtp-Source: AGHT+IERQzzg2q97AC1GoQrvJPFrX81ojeCfE22exlpUpT47fDXnKagocBJKz9dOsYdBVzGfWjozYg==
X-Received: by 2002:a05:6a00:400d:b0:725:d956:aa6f with SMTP id d2e1a72fcca58-7290c117a24mr1975800b3a.5.1734064089267;
        Thu, 12 Dec 2024 20:28:09 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2d7e:d20a:98ca:2039])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725ec805ca1sm8218924b3a.195.2024.12.12.20.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 20:28:08 -0800 (PST)
Date: Fri, 13 Dec 2024 13:28:04 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: caiqingfu <baicaiaichibaicai@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	caiqingfu@ruijie.com.cn, minchan@kernel.org, mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Message-ID: <5qmps6mcifydwtnsynxdtipaoerjrnjlpo6gztxfdryn37bvws@fp2xqjmiews5>
References: <20241211110414.GF2091455@google.com>
 <20241212095530.162164-1-baicaiaichibaicai@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212095530.162164-1-baicaiaichibaicai@gmail.com>

On (24/12/12 17:55), caiqingfu wrote:
> > I see that somebody posted something similar on the bugzilla [1].  Is
> > that person you, by any chance?  If so, can you please post your
> > findings to linux kernel mailing list? E.g. linux-ext4@, Cc-ing
> > linux-fsdevevl@ and linux-mm@ would be a good start.  Bugzilla is
> > not used.
> > 
> > If this problem is in ext4 then I'd really prefer to address it there and
> > drop this patch from zram, simply because it covers an issue in the upper
> > layer.  And it's better to fix issues that to cover them.
> > 
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=219548
> 
> He is my colleague, he reported a bug

Oh, I see.

> In any case, zram should ensure that its data is not damaged

zram cannot ensure that, it's not zram's job.  Nothing stops
the buggy actor from modifiying the page at any random point,
zram might not even be able to decompress the page in the end,
it's not only the zs_handle allocation slow-path case.
