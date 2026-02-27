Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6FF240611
	for <mm-commits@vger.kernel.org>; Fri, 27 Feb 2026 03:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772161490; cv=none; b=ItvN5DEw4O7cQ24erbIUs9vmGU8vwaAYHDDKbMNJHM+9rkjFmrem3Aifq4a2w6USd15oWM/jOfz/n1BS/Y5SxHhIzjBoiH0KWHR88Nb1/PTfP68pUp2v+jkhbA3hhezsb0tSlskiXB6ClxT0+aaD/JlORCH59dShPgKrZYkzQPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772161490; c=relaxed/simple;
	bh=2EJwN6DSGXGMGqaB2YEmUs2BAY+MUSSpkMLH+TpdjZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guLFE/Sa+d1SI7QGi2EX0kU1hIXDHVJI3t9KOYPpaWEkdyLsbqEBlerZuQ+kF9tuMYf5Xxq+AwM4rRrcsJPH5EbhiEL1BLkinGMHzZqxvLNtG0rgb4LIDGlhvfyyOdDijL+n5ZYqCuTgqyIeqsNGt2JoG3UiV19jCu9x9AQ9rnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=X/TZnzt+; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="X/TZnzt+"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a962230847so14821035ad.3
        for <mm-commits@vger.kernel.org>; Thu, 26 Feb 2026 19:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772161488; x=1772766288; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ntbjsjy+0/DmmooK18iXTfGNQ+doO2mHVc7NK3zTZiA=;
        b=X/TZnzt+NSVP0AeI9orqH5tLCI02J2xcxgn6RDgL9EssrNwjm302R6gtQBDmoQN21U
         PY289ttNnhzTjL45AaSpO2ll/SsqwCIQRR4Tgqi1R1bY2MjqdvY0J8V4pFdtZFr+PwCk
         6/ytoG6mTq7pSjbXXDutyOjnk+yABi8iaV51Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772161488; x=1772766288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntbjsjy+0/DmmooK18iXTfGNQ+doO2mHVc7NK3zTZiA=;
        b=PTBgegtEB8/1IwLcZQQ5M5evN8bg4IGc4I+Fy9A5bCXZ2v6GdkmWGexuGv91J267Ic
         3ghBCNf9B54Kg3mDKmDEN5lTHKf5VSVtlVjut/vZq8C+igN7JZ9/myLngY2hy0tdD+Mi
         mmzl5DJxX5pyXSyZ8VJtcw67ycI7AC198oK0ugUwAiTPSi3JUfcGLGnUX7hYyAHlQ7B3
         tshHCJm4E5Iul1AGuUEFatXTdfCZB3zrYkTj/JaIdfsHJfdWUtthG/nKEh1LNBlaIhki
         r6YR1EtJfZx8dAE1FkTd69pIJ3frc6CwNyAlphiuGoklahD9soqsMYXoyF2eeAAiJqeM
         ZQUQ==
X-Gm-Message-State: AOJu0YyA4l8Yxpz32EwosmRoUU9CdmFVA3dF79NQG7nRkvzUUyp28HiC
	AhLcabMCPy/x0EdHKtqUs8x8D6xLCBdR1K4NGW8BjTdFpqzIt7kq5naomEjVqQGcEw==
X-Gm-Gg: ATEYQzyRNmwQAHKMPIAocnmDY5rh7fqCNRBU3d3Wcc08oSlC7YNMN3GQlotaImPbNty
	JdDiUxRzAafSZp5RaNxqCqRdY6BARD+zHcEUdvN06vMsDCKsm3S9C5GtTZymUurlSrJAQVD+JRY
	hCOHQdsj3AK2ZSs22bp/++TsVYzY+FxjtxjERgku3PdH1iLoUzhrVlNfFwaV/9VeJMbzHKDW2Y9
	g3onqLa3I4eIeTkKRzbBmxrWSllAidwhVRILJyRva+P2ETEIeF1ZhInK3S3OfuemAGNgl3jwQMj
	AAU3ShjgoAIGD33pKB+irifKOe6hPOYiG7SAhKCkyFGJfPXdPt6I7jL/s/xN9EE9dIdH2xr09Gl
	sJdGUqQ33uwS2DckJU4WdmJg/bCWyaufE4waZRXmTsWNBnbLoKgIH8IZ+j3yekMTmToWUm77Ydy
	Vuq1uf8N+Hi+w+wn5k70YYniwP3vKC/VpGSiEAmg0mNuSlsn8LpWXQVDRL2NOUN+jVtXN3CEXJH
	g==
X-Received: by 2002:a17:903:41c6:b0:2ab:1dad:e500 with SMTP id d9443c01a7336-2ae2e408246mr13907825ad.18.1772161488250;
        Thu, 26 Feb 2026 19:04:48 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:280f:e47e:6718:7698])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b2268sm41059855ad.6.2026.02.26.19.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 19:04:47 -0800 (PST)
Date: Fri, 27 Feb 2026 12:04:44 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, surenb@google.com, 
	senozhatsky@chromium.org, minchan@kernel.org, axboe@kernel.dk, gaoxu2@honor.com
Subject: Re: +
 zram-use-statically-allocated-compression-algorithm-names.patch added to
 mm-new branch
Message-ID: <rmumbso6umvp3bopvkrxgv2nan6bsxqj7h4sgw3urx5nhoxgyq@6wphu5i25zvk>
References: <20260226164516.21CA7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226164516.21CA7C116C6@smtp.kernel.org>

On (26/02/26 08:45), Andrew Morton wrote:
> Currently, zram dynamically allocates memory for compressor algorithm
> names when they are set by the user.  This requires careful memory
> management, including explicit `kfree` calls and special handling to avoid
> freeing statically defined default compressor names.
> 
> This patch refactors the way zram handles compression algorithm names. 
> Instead of storing dynamically allocated copies, `zram->comp_algs` will
> now store pointers directly to the static name strings defined within the
> `zcomp_ops` backend structures, thereby removing the need for conditional
> `kfree` calls.
> 
> Link: https://lkml.kernel.org/r/5bb2e9318d124dbcb2b743dcdce6a950@honor.com
> Signed-off-by: gao xu <gaoxu2@honor.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
