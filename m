Received: from mail-oo1-f65.google.com (mail-oo1-f65.google.com [209.85.161.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69056623
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 03:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719200010; cv=none; b=AlVqBkrUfg1L9Z6YK0EoHULlwHb5tR5PgLsBbz345/6Wo0o6hb6Xk3RbA3fkl6UIIRe45GUbp+qKSEkJA4yHiksckEcXoY2UdlMcIX8ZVDAqsxzpeJ8N/lqaycokz9Rk/vETq4NTTZcFISbuaj1GL4bCjj1dtj5VyTNefLYwyYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719200010; c=relaxed/simple;
	bh=S7tgILDIgBxGBpgUu8J4lD31GuJnH7oolBuqhWAXips=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vfi2OKR8vqQ0nbds2OKCf1hA5b1cxbk2TYFUsEcPLoLT1SMRhMer8S9vO9aVUhcscY9G1u5cC2Gj7rMHl0eju2IRTR1uGPv7Ui/IBiPwnqpyKDLT2cobMUfp/2azoUG2XPIsosKQRDHePck5+HnLrF16dwgCPqeyrv71/vEMNjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ayqb+gis; arc=none smtp.client-ip=209.85.161.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ayqb+gis"
Received: by mail-oo1-f65.google.com with SMTP id 006d021491bc7-5c1cabcb0c1so1879834eaf.0
        for <mm-commits@vger.kernel.org>; Sun, 23 Jun 2024 20:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1719200008; x=1719804808; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JyM6sTWYuAXEkJvXlDi1RIyeyoXNAsvYRNoybQqFplI=;
        b=ayqb+gisgxdnu++vHyfhDKYDi6sqjBm37cR4M9lJU0igTqof0rmrGapXls+Q/VC1sR
         IAGdUUJo1Nj6sFJYf8XD6tBvaGn7loC3TRwrpF9P2pWoazEXX++cnebW3Ll/oKhBrYQp
         6d3espicAFlKEEC7sThucYKihtEP/NCU2jJxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719200008; x=1719804808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JyM6sTWYuAXEkJvXlDi1RIyeyoXNAsvYRNoybQqFplI=;
        b=pryEpln6LmaceLpGwBzy+N349DxG4UGT6hZ2Y6f0Lx/Ep8NcV8m0sdPB8JGSfww8xQ
         WO+thymkr3rKUgcHD4g51iI58in7sDvsb2kRAU+9hMXKOMsblD+gGbpS1MdXFpp7qjVA
         1VAEiDYtAfNikSB37lhPX0tCXEWlerlGQoCQT0iLNxmYpwboy7f5s12vev+YLDbEPKZs
         LE7bwyYwhUm6JqT9bE1QjMW34saNKjB4/HGrr7k0t4f4GrD55FydlOgvviPLzTRgupAy
         t+PU9XdcU1gnZw2pCtTqVXB9fN+xJRCaTFtRIyNSoBEKzalKjTmQWGPTTjFVF78aJT2C
         pPBA==
X-Gm-Message-State: AOJu0YxK8Qqf2E2K2YstyHxXvVkZ9cH3ZKlCCzoIZqyaVK9tsoFhhL83
	iS7t/bZ2o0F9AbQctydU7oSQ62qK3oM96SfN+p2LyPljtpLND/M3M/D75l8HMA==
X-Google-Smtp-Source: AGHT+IFBZ6BLOxjupsz9IgTbRMpT/kpksypkjRRN+tx52DyDLPq2jcxMnLKGqxK0r1BKB7/DLm+pBQ==
X-Received: by 2002:a05:6358:7604:b0:19f:45a6:4965 with SMTP id e5c5f4694b2df-1a23fb2b837mr437984355d.7.1719200008379;
        Sun, 23 Jun 2024 20:33:28 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:4e6:bef0:f574:7d51])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-71e1314dc83sm670308a12.56.2024.06.23.20.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jun 2024 20:33:27 -0700 (PDT)
Date: Mon, 24 Jun 2024 12:33:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, terrelln@fb.com, minchan@kernel.org,
	senozhatsky@chromium.org
Subject: Re: + zram-move-from-crypto-api-to-custom-comp-backends-api.patch
 added to mm-unstable branch
Message-ID: <20240624033323.GA3130923@google.com>
References: <20240522223141.2F4A4C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522223141.2F4A4C2BBFC@smtp.kernel.org>

On (24/05/22 15:31), Andrew Morton wrote:
> The patch titled
>      Subject: zram: move from crypto API to custom comp backends API
> has been added to the -mm mm-unstable branch.  Its filename is
>      zram-move-from-crypto-api-to-custom-comp-backends-api.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-move-from-crypto-api-to-custom-comp-backends-api.patch

Hello Andrew,

May I please ask you to drop this entire series?  Apologies for
inconvenience.
