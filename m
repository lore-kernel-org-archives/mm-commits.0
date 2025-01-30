Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937C21A9B32
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 10:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738231225; cv=none; b=pbI7LFUcdKN6qbt9zdrKPH661gF3wt1PUKy4nUsu80V7zQy4gtvX6GoPll+dgO0pT4joeQg7hs3EAeGPnW3h7rxCgtdgsEHlZM6F/Nf2vEQ5CHV7wSbtDgltElEfAz0Xa9foizNVlqo4zoG3dTRQK7OT1O4j/4V7GhcGTvIj624=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738231225; c=relaxed/simple;
	bh=IjfjX3IWGnvXsrShKKI2OQfOkW03kgMkH45/dn4dPdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHy0jeF/7DYkTMuVbQMyS5MTTCTYOsXzdvWmIkjcgW9ESdW6gbPhpkDUvgJW3hhJNdbRviLoF0z11WylD/goEC9vri76zoaVRk5b7V1rxzBdq6TMSZl8g2srFNWIUJ7DnGYDjwd2obnIodX89SVIKlfhp+vfdDvoD9NbPfRNM78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FOoBxMoz; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FOoBxMoz"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2164b1f05caso9356735ad.3
        for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 02:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1738231223; x=1738836023; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WvenoTkhgQzEL2zCtyILe2clcCBWkMDI6DCmhrVMj/I=;
        b=FOoBxMozsdnwgdBvuH+HsYcTa2Tc3G8SRkuE83O246wadeth6+NXGWdbjWutcMgPPL
         m5xQGcddG/RpQRmU+yPMK3g6x7Jalx3QGHpGw2wG6WIk6ilQK+eLMlH4xHa4WcNnt66e
         cA/QmEymdyBo4aQISJysbe7QZLpI7vuU9OggE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738231223; x=1738836023;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WvenoTkhgQzEL2zCtyILe2clcCBWkMDI6DCmhrVMj/I=;
        b=qail6ChaDkhHFB3FAwBHAfiIxwtToISMA5F0BZH5n3FlhV6a0Znvxx17I4AGKzp6Zt
         DcthQmDGEdAjDf60SETMQUBpxDl0JXxLAsws3aIV+bCwu2xoGZoI9E+YuDd0WFl0tJAN
         pw7FQ/eYEQPpEkCbbSP5+NclKLW5huovMtn0F/w7LSSmjF/BiyHgfa4JA1HVJ9nIFIaj
         89+su2pY6cKxRaxh7B8PcHmjAl1+tWiN/Ihufb948YiQlpX/C9xMFXTlLJz+mFZV8+qR
         9C6lMUUN4ECkj+1kypzBsyQGCpcyRb1SZFr5c32kdKOsrelhp5EknpOhH1BuVMa9WzMF
         HNOg==
X-Gm-Message-State: AOJu0Yw19/lNlpSF91Y5PxItB76xLHBcViKr3Pfa10X17Cbq2epLSz2K
	M0B8GoMHpOiYMIDz3XWD8B4GsxchvAiP5meI1VtF9GxnujVf4aW1UhLjYKUXerCcPD0W4LVJGDM
	=
X-Gm-Gg: ASbGncu77JkuIadcgbIVr0uwC2MpRdgOwWtr3lAkoPEaxuqv9EzRTt5Dq1YjDZec01F
	M0U2QiScJTDuTcKa4GIjbSz2onfIH2Psg+/LUJWtVgzqngfxTYjuGYkvy+PzG0KYISLa3cGK/8s
	X0feIA2gtIWJlLQsEuvpRwhoJT6BpCMJFPD33QHUxAKif8o5E+sNyCFMIO1PtNEqMcga9jAQXh5
	+qcyfFC//vg+gdX2Pfuk9mJTM6yKJiSGka/PhQAmFofPC8+YUJQhznuvCnq7/vCcm4zc/QgOujP
	ACY9MXBonPSonWE+ag==
X-Google-Smtp-Source: AGHT+IHr9iHGJXQeRBlom8zLbEm8fjZNk8P89Lv3Irzy1UrvxZB2udNkcFauNcJeWxEOBCjqdP8Hvg==
X-Received: by 2002:a05:6a21:9983:b0:1e0:bb0d:b1f4 with SMTP id adf61e73a8af0-1ed7a5efd51mr9416896637.11.1738231222502;
        Thu, 30 Jan 2025 02:00:22 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:d4ce:e744:f46b:4fb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acebe3845e6sm957780a12.22.2025.01.30.02.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2025 02:00:22 -0800 (PST)
Date: Thu, 30 Jan 2025 19:00:17 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, minchan@kernel.org, 
	senozhatsky@chromium.org
Subject: Re: + zram-do-not-use-per-cpu-compression-streams.patch added to
 mm-unstable branch
Message-ID: <zzhpdqj7igkjc5zx6yqe5wiihyc3czioyhzvfwh6vgax7a2vjs@rjw5koj7xer2>
References: <20250127205812.44896C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127205812.44896C4CED2@smtp.kernel.org>

On (25/01/27 12:58), Andrew Morton wrote:
> The patch titled
>      Subject: zram: do not use per-CPU compression streams
> has been added to the -mm mm-unstable branch.  Its filename is
>      zram-do-not-use-per-cpu-compression-streams.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-use-per-cpu-compression-streams.patch
> 
> This patch will later appear in the mm-unstable branch at
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
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> Subject: zram: do not use per-CPU compression streams
> Date: Mon, 27 Jan 2025 16:29:13 +0900
> 
> Similarly to per-entry spin-lock per-CPU compression streams also have a
> number of shortcoming.
> 
> First, per-CPU stream access has to be done from a non-preemptible
> (atomic) section, which imposes the same atomicity requirements on
> compression backends as entry spin-lock do and makes it impossible to use
> algorithms that can schedule/wait/sleep during compression and
> decompression.
> 
> Second, per-CPU streams noticeably increase memory usage (actually more
> like wastage) of secondary compression streams.  The problem is that
> secondary compression streams are allocated per-CPU, just like the primary
> streams are.  Yet we never use more that one secondary stream at a time,
> because recompression is a single threaded action.  Which means that
> remaining num_online_cpu() - 1 streams are allocated for nothing, and this
> is per-priority list (we can have several secondary compression
> algorithms).  Depending on the algorithm this may lead to a significant
> memory wastage, in addition each stream also carries a workmem buffer (2
> physical pages).
> 
> Instead of per-CPU streams, maintain a list of idle compression streams
> and allocate new streams on-demand (something that we used to do many
> years ago).  So that zram read() and write() become non-atomic and ease
> requirements on the compression algorithm implementation.  This also means
> that we now should have only one secondary stream per-priority list.
> 
> Link: https://lkml.kernel.org/r/20250127072932.1289973-3-senozhatsky@chromium.org

Andrew, I will send an updated version of this entire series.
