Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255013AA1A8
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 06:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778652989; cv=none; b=cwDl2DE20sU0H3WyuVFZ5ixg6kKBdvKW47b+JiMMXST5gz+Lnossz27x9aEPc8XYKJZJ2SchCN5vhN45WAS2ZzWwtyo0FNExyKJzAZ/3teHFTcVjf1gnH2Sv3E1EdCafoE4wG7JkUjydjz11jbRkkm1ssB/W+iGQYf1tk6WqZ6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778652989; c=relaxed/simple;
	bh=nMH9bltGHRhs/AbTtr4aKYbvb984xhXoh9kz+aCGdq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loIj9zzmlWaj9/exf6awWcefIjt2vcZK9tmzkuL2LzNWZ/u7ir1VFPU6XWm2ImjKuyrukDnAbSetEGAQHkUD5Zjy4F9wrq1FwlGm0YRQyR4OjmdV+lIQg7FrmkawfjjOgydg9ccKsYaiMZJQzWOBJMseIZn2vKfdI9co+dNZoFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mAumR7Sr; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mAumR7Sr"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-367d88b9940so3015067a91.1
        for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 23:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1778652986; x=1779257786; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M3/NmllfS+SrHzBU2sfiASJiEbjQXEMBJ1jiZMSTpf8=;
        b=mAumR7Sr8eux0/mOniFATpvnCHQ8ketH88GUTpEQNHLcgo7wp+/Q93NnMjRTDvabd8
         hS36UCKddn9kw60Nvon8hirmAfLLq9Qp+Jn7oKH2aovMiuStt2ePARiSpP4BqAuK1EsK
         vKsTyvboCVsi2A2M8YccZzUfzB0UQHtIVKDC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778652986; x=1779257786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3/NmllfS+SrHzBU2sfiASJiEbjQXEMBJ1jiZMSTpf8=;
        b=HwfgMRAWQeni2B/oqmQZEIgiPFkV98dK3iikX6dnzlZ9P2InHzJkXb3P/jaWH6mIX5
         6/JBCcBenJY4a+DmtL7fi2YLU+K1IeYr0wxq/brvQez/OOsCIV02izP58xi0vC34dhce
         2HRXIDBVIGaUlKShn+5mrttZDq5sXXgAAGY7lrIAHzKbmLgHV5uVJ8oMZ+LNdszm7Iw/
         RFq+cyyErfVoAFpjAG3LmWJGVUuXPJhrwhtftz7svd5W3spl52lkfw9fDdriEo8OFN+9
         maSGSQUAFgbdggJlasTAXgM9hlywrJitqedvNfanC29ZRBGbzPdFLAz5HVZ6ylcCuZny
         /S0w==
X-Gm-Message-State: AOJu0Yy/dg0CpmlU51jstL5BgGbQ/PQb8S2mXDgVvN1R4HPf3+bnsZXm
	QvydJgFq/F5JfWfT4XvxQ2XopmgKRCUt9RYZCfmAlhDcyOkVlxzCGlVKgs9s17BrUg==
X-Gm-Gg: Acq92OHB41YSgwyxxyztBhM13kD3Xif2MLOiDQBh9XzRTjMkDfGixt1BEGCMBWMj/MP
	VlsMUHGWEZFllFJ/qZVLjbEjP9Paz+HPAqc88+/jdbt5QZlrBL9mLLjx+VaS2vSXfAc4D2ebsSV
	MmDVGJdlzVAEqtn0IKEES7PRXfJ0ZkGEa5dzF5dEEpVsNU2+fLMIQ3eVim5TOOYMjQmCnqOdIXV
	5sLR4YDwCBP6mEkXKrMPnEyGXgccKxld74Hvr2PreXQmqwntT/ojrnXYE+oYX10Va1pm2paU96e
	scPQIfRY1wgmaVQQPB8abblFowkYbq2m6D3a5f7vDYlu6jthhiYytlM8W72mL/+NEE0/7sWi0yD
	YmG700frXyZDo6DQ5N9J9NX1XSLEMRceeCANTo008kDGFWRmPDev9GmjdW99F1Gdb+pj9/+DiqY
	p+U5H8rhkal3UOW3bHilvzU63jMPMtD/0luq+Ztz2MWGbNdv26wmfMgh8kop05RNM=
X-Received: by 2002:a17:90b:3c0e:b0:35f:bfdd:f5a1 with SMTP id 98e67ed59e1d1-368f3e680femr2025227a91.13.1778652986403;
        Tue, 12 May 2026 23:16:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:e541:a7ed:e8ee:843c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368b04b2138sm1740198a91.9.2026.05.12.23.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 23:16:25 -0700 (PDT)
Date: Wed, 13 May 2026 15:16:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, 
	senozhatsky@chromium.org, minchan@kernel.org, hannes@cmpxchg.org, gourry@gourry.net, 
	dan.j.williams@intel.com, chengming.zhou@linux.dev, contact.kartikn@gmail.com
Subject: Re: +
 zsmalloc-zero-initialize-zspage-memory-to-prevent-kmsan-uninit-reads.patch
 added to mm-hotfixes-unstable branch
Message-ID: <agQWo3GZfuGMkgn5@google.com>
References: <20260512214850.3AE80C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512214850.3AE80C2BCB0@smtp.kernel.org>

On (26/05/12 14:48), Andrew Morton wrote:
> The patch titled
>      Subject: zsmalloc: zero-initialize zspage memory to prevent KMSAN uninit reads
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      zsmalloc-zero-initialize-zspage-memory-to-prevent-kmsan-uninit-reads.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-zero-initialize-zspage-memory-to-prevent-kmsan-uninit-reads.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Kartik Nair <contact.kartikn@gmail.com>
> Subject: zsmalloc: zero-initialize zspage memory to prevent KMSAN uninit reads
> Date: Tue, 12 May 2026 03:06:58 +0530
> 
> Pages allocated via alloc_zpdesc() use alloc_pages_node() without
> __GFP_ZERO, leaving physical memory uninitialized.  When a compressed
> object spans two physical pages in a zspage, zs_obj_read_sg_begin() sets
> up a scatterlist pointing directly at the raw second page.  If the second
> page was freshly allocated and never written beyond the object boundary,
> KMSAN detects reads of uninitialized memory downstream in the decompressor
> (e.g.  sw842_decompress reading the CRC trailer).
> 
> Fix this by passing __GFP_ZERO to alloc_zpdesc() in alloc_zspage() so
> all pages backing a zspage are zero-initialized at allocation time.

This is very unlikely to fix anything, we should not have out-of-bounds
reads in the first place.
