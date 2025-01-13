Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103861474D3
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 03:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736740788; cv=none; b=d13LZUjCOFfMAY216T4wRuICg4kreBNCbh3oPhlFs5WYLaou7Qf9fjT/lmZ4YY6DFH1ZHNvQ0aad8UyOx0peSGXiMppBd5HQeIfm/f0A71DZsqc0O3IGyBNQ38mr0KUt/2yxE0Lu+JNCJ3sCazd+CnvTRD50+c8iQHEKwwKs8Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736740788; c=relaxed/simple;
	bh=PtJptJ1ys9sGlrEilTRPtOW+x308JYg7f/BLBMiclMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jls1T9+Rp9lPxplgorJMBDj2wDBrjpIBXmVKZckf6mkOQHaRuXakqLSOVHKtO644wkZ/diN5jTM6zf+9h6DF7PYy6K2QRlYHTdeW3W7uf40GOgq4wgqIXAq6iknkXcg3gxA2eUjLkVkSEpPtwUWC1qPeN490KIS0hk0Xy4Pj+dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=oAmiY9ya; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oAmiY9ya"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee8aa26415so6501547a91.1
        for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 19:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736740786; x=1737345586; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UGB9WKm15VLQGLRZ19XO4Q6ETFq3q7buwNEAgKH0mSY=;
        b=oAmiY9ya9DXk+WoBaQnTo2mqcfvMLlq3RKfYxKwdbTasXBZeZfutAWu+ET3HV0BvOX
         oRfrNzSI+WRgYrvOPF2usyzIM/CWd03FSWw5H+xFMK/6rqINoJ7C7SRJwMzT9Qx+YmLE
         1HKkMd/vsxZT5TPC/Kq0kYB3QrCJm3SsqFgyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736740786; x=1737345586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGB9WKm15VLQGLRZ19XO4Q6ETFq3q7buwNEAgKH0mSY=;
        b=a/n0VPnvxbARu0Er5nohvTf0zLXMc3d8gTNVxTs5ipOUJRHs32twASPTf7yHtTvw1B
         oP1smQXP99q2cN+JNClvr0A0rpBsBtDIV3NKOeXVsPX7JI8fF4aLxQZN4eB/9RrMbSbD
         wuZSm2ImRYF3GX1l+a1IeiB3+dmWFhxIgXph9+U6ewSucLH3UfBqcV7Tfimafj2zGzJH
         xn7UTulHcSDP5cE4Egi7LITbCZhMu8F0/Ja8E/cgk3CA0yNb2A8tFIemG+hsJbAfijvb
         lVJOfU9DOyekVAeG89KBp6ERci/NmKvhcDGQAXQJ+Oi/kT+9jn+eyClFw4+8jhNESHHP
         y0Cg==
X-Gm-Message-State: AOJu0YzzvSjRFQJ4Z7tCXVTw2h3rVPBi/7gIwG6MA99LsWEjQCQuS41D
	rSmOTYGUwZ+AtgU1J4zAZk8vZbbIhljyzZuEAP0FI1LfsWFrOXUnMYaSNbQyFhBvyIANmZAKls4
	=
X-Gm-Gg: ASbGncteLuAaM3IxwBO84faBCgBKT02qh+JGDMwSQjiEvFn3DwsbAV1iS91dGp0ix1W
	YJp+0TQSc9dz4dnM/2AB4jYUDBWfylqGWkJ9lKoGHBClLgNMReksB6tW+XAaScQn/WsgCIzjo4J
	LS7QxUY6US6SQs40PbmZRo0PR+MneA6fTC7VRbFOw8UsUWaLJTseffQb36ocBUvGzTfymMjnIGQ
	1kEVFBDZl8VGEMK1XMVUPtd9zOizskWvjxfv4clcwMTmKfLl3YUqXTEe19Z
X-Google-Smtp-Source: AGHT+IFnRiBXOrzEYBhWOF9WEdr0dpEXG/8dCr3tGtHxRuRs2xRWMZn/GN+ldz5VN49Hc0w2jF6Fkg==
X-Received: by 2002:a17:90b:274b:b0:2ee:8427:4b02 with SMTP id 98e67ed59e1d1-2f548f5f941mr27186469a91.28.1736740786398;
        Sun, 12 Jan 2025 19:59:46 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b4d5:730a:a151:6449])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a34d91bsm9929715a91.32.2025.01.12.19.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 19:59:46 -0800 (PST)
Date: Mon, 13 Jan 2025 12:59:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, senozhatsky@chromium.org, 
	minchan@kernel.org, rdunlap@infradead.org
Subject: Re: + mm-zsmalloc-fix-function-parameter-kernel-doc-notation.patch
 added to mm-unstable branch
Message-ID: <wrox5uoknvnsqhifnqddrdipdgkmjr5zy4yx2obzyugh7hof3z@247jib2lble6>
References: <20250112053211.D85AAC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250112053211.D85AAC4CEE0@smtp.kernel.org>

On (25/01/11 21:32), Andrew Morton wrote:
> Use the correct function parameter name to eliminate a kernel-doc
> warning:
> 
> zpdesc.h:90: warning: Function parameter or struct member 'zp' not described in 'zpdesc_folio'
> zpdesc.h:90: warning: Excess function parameter 'zpdesc' description in 'zpdesc_folio'

I think, techically, this can be a fixup for [1] which is in mm-unstable
right now.

[1] https://lore.kernel.org/mm-commits/20241226214651.8C5B9C4CED1@smtp.kernel.org
