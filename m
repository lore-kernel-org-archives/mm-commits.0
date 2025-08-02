Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148C318CC13
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161152; cv=none; b=AuEqTlgExHblp3zDcmMP7EroZgOJ1iCKWyrtj+aa/i/xbKjO0rtd94pTSq4bV40e2lXWi4NaIebTyJMVPRRPvFOib2Uq4Ijeu8NtU8BtdkPOM/DLe81TpjP+GSQYMng4KBE/1YtXbxlw4IAiwySzQALunfoRFnKyeOBOq/9Tm1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161152; c=relaxed/simple;
	bh=Z5LBJ6AYPODW3GOLA9CyeIhnRtEakiUcruhR6AwKBBk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cYIPZorfdK3k38m+e1oQILjYgfdFjWZKey75gzm/Ez5NXYL8cHeVbFMRW8aLrGoZbpjoPJAaBezpMSkv8bxrAO2vdul5CkcODTRHQx9e6Z1bIHr+DqXtN/yojUjmDoe+dwiZAll+Vtx5vO9Edzc0Fo9RlpDpku/wUNpYnvQBhHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P/RcCHOu; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P/RcCHOu"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71b73225060so17738917b3.3
        for <mm-commits@vger.kernel.org>; Sat, 02 Aug 2025 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754161150; x=1754765950; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4scQSul3ARtGxHu87XAzmmQ8A2/n1omySBRxCHtF4zg=;
        b=P/RcCHOuKnyCpmqARQGP25UeKUpG84oJTe2s07UWvfTrm4P22MbPJClk+dvxrucMrn
         WhuJtkkuuHc5yGGgy2cMMkYQzkMaxhe239oxW5iCJ6ey7ZdyNsW1d5et+njaKkHbCagu
         KhIQLFmbQkg2ept6d97fa7asf8bJCpGMwXJsAmTzwfpa0fHsshuiqvk4c6HNOZQ5L1NM
         wS59ngCGsVxZo0GS8VpdxYcVgfXmJ/cy5OSpV85LYFDgfrBSy3DEpUtCk3RcxgZQ6cLM
         RX/t4CpT3XcdFER0Vni5RFCnu3GJUkT7EgivDaYV8Lrry0KfAxwMF+TCzqghO45/kMfN
         pDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754161150; x=1754765950;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4scQSul3ARtGxHu87XAzmmQ8A2/n1omySBRxCHtF4zg=;
        b=aa4ln2b7/VxovHW9aywfb0+R8Se9mhUiKHQcSvnhaKkOXP59pyMudfUqQkAcg9lxVd
         ms5XnKI2onpKN2xerbymluwENjUJ2S0Rg5tyiKCjvo7DQDp6DaVJi5To9MgI2qEJOKRh
         G6r26Q/FTklKPMukb45/cxRTl34Ak+zvZ1BmE+aNDnEt+mDF75aDfCF6w3e8t54rGju1
         PpCxAz9lwiZhgrkosZyCah+TfWIT2mNikwhPZxB8rLYpC2mDhKk3YYC1pkCLkJOtKsvT
         CGmYJaDo0gCHNRm4B9mzys4wTDZdKD1kO/7+7LSXje1hFmgHic3xPlw3PoHf3GdVerKn
         vHcQ==
X-Gm-Message-State: AOJu0YzpWQC8kq3wE0b/e5FmVD5tp/wSyDanTQPvg7qquKmfjjuNpgKc
	BklGxikOC5cYiHpS5XscdxNskyk94R0YorY3rtqAW4UX0ZmIGWMUPYP4Z8ZgqfkKSg==
X-Gm-Gg: ASbGncuRm6GyykehPNyVQclsBdk/+LOqr06xxKPuXgK8IpsodpR+xkWyOjp6PwwZS/E
	rivKzW5gcJIpg3PCyiITKIt96T2uc0Sa8RJTpLLZUp65swclX0iXD01LTAlK1b5Ti4HKbJgKEUz
	fZTetqzN5X3PNRT1iPPO15tDilhful6sbf6gNilH7B8TUt/Fa9qBJOfoC2v/aWtBwA/v1njSXtR
	7d8yJabXpI2jpq82XwlECcf2v7EGl1cpr19Q5siteX1SnyvX53bnSiLtrmiWEQWArPolFi0pABS
	ODbRHFkJfRE07dDeKr/czyvkXVVg5buUkdhwWvyxiLehZ3N+V/pO03VO4JmhXD6WMTsHeBznZ/n
	vZQHHzOQ7vMAcsJO+eXihBKFtaoq21r69bLugAetPjwIMtPXGnVbCGf/zp6dEM1h1b96RYwHFlO
	9LesQtfJHF8+ot5o/DDw==
X-Google-Smtp-Source: AGHT+IGKoQLgNPvQe36GxV43YbpPOsGqxqpuoUDaPCheBhU9vnJmQXW+WCH8F/imrS0n1Ug6sxyMjQ==
X-Received: by 2002:a05:690c:4486:b0:719:dbb5:e76a with SMTP id 00721157ae682-71b7f92968fmr48009317b3.42.1754161149682;
        Sat, 02 Aug 2025 11:59:09 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5fa3c6sm17260157b3.85.2025.08.02.11.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 11:59:08 -0700 (PDT)
Date: Sat, 2 Aug 2025 11:58:58 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mm-commits@vger.kernel.org, ville.syrjala@linux.intel.com, 
    patryk@kowalczyk.ws, hughd@google.com, baolin.wang@linux.alibaba.com
Subject: Re: [merged mm-stable] mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch
 removed from -mm tree
In-Reply-To: <20250802185352.DAA62C4CEEF@smtp.kernel.org>
Message-ID: <1afd8dae-1665-ce19-9464-d993c8e1e6b2@google.com>
References: <20250802185352.DAA62C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sat, 2 Aug 2025, Andrew Morton wrote:

> 
> The quilt patch titled
>      Subject: mm: shmem: fix the shmem large folio allocation for the i915 driver
> has been removed from the -mm tree.  Its filename was
>      mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch
> 
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
> Subject: mm: shmem: fix the shmem large folio allocation for the i915 driver
> Date: Thu, 31 Jul 2025 09:53:43 +0800
> 
> After commit acd7ccb284b8 ("mm: shmem: add large folio support for
> tmpfs"), we extend the 'huge=' option to allow any sized large folios for
> tmpfs, which means tmpfs will allow getting a highest order hint based on
> the size of write() and fallocate() paths, and then will try each
> allowable large order.
> 
> However, when the i915 driver allocates shmem memory, it doesn't provide
> hint information about the size of the large folio to be allocated,
> resulting in the inability to allocate PMD-sized shmem, which in turn
> affects GPU performance.
> 
> Patryk added:
> 
> : In my tests, the performance drop ranges from a few percent up to 13%
> : in Unigine Superposition under heavy memory usage on the CPU Core Ultra
> : 155H with the Xe 128 EU GPU.  Other users have reported performance
> : impact up to 30% on certain workloads.  Please find more in the
> : regressions reports:
> : https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
> : https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845
> :
> : I believe the change should be backported to all active kernel branches
> : after version 6.12.
> 
> To fix this issue, we can use the inode's size as a write size hint in
> shmem_read_folio_gfp() to help allocate PMD-sized large folios.
> 
> Link: https://lkml.kernel.org/r/f7e64e99a3a87a8144cc6b2f1dddf7a89c12ce44.1753926601.git.baolin.wang@linux.alibaba.com
> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> Reported-by: Ville Syrj??l?? <ville.syrjala@linux.intel.com>
> Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thank you Andrew: but please add in the
Cc: <stable@vger.kernel.org>
which you corrrectly gave the v1 patch it replaces.

Thanks,
Hugh

> ---
> 
>  mm/shmem.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/shmem.c~mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver
> +++ a/mm/shmem.c
> @@ -5981,8 +5981,8 @@ struct folio *shmem_read_folio_gfp(struc
>  	struct folio *folio;
>  	int error;
>  
> -	error = shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
> -				    gfp, NULL, NULL);
> +	error = shmem_get_folio_gfp(inode, index, i_size_read(inode),
> +				    &folio, SGP_CACHE, gfp, NULL, NULL);
>  	if (error)
>  		return ERR_PTR(error);
>  
> _
> 
> Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are
> 
> 
> 
