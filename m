Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D114C85
	for <mm-commits@vger.kernel.org>; Mon,  2 Dec 2024 07:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733123090; cv=none; b=QWKNkjegQu3lhrVg5bCC00CpqAptkPa84iG6W1WNhTdN3DmCHwrL7FvS4ZYmS1/wuZ+LwWy27lZeKSYYWPAuWgLOh52Y1t+TbmxUEKstF0+W0Q/KBmz/PjQk7ecYltL75HvhcrJDfhJKaaRIl9t5EYJWRVzlR1KfCRQUG6g1xIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733123090; c=relaxed/simple;
	bh=SiD06DObmbaiVaqIGJ//yBG35vOfhSodL/Rn6wtirkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=onetUTCS03WlBCbDb4MHYow3W1ntbpA+Ty1963y3gjd2D6ncYe+WRAUqP/w+usI+Va2UC5P7UWyeyyHxnl5AJxRA0pVm/viladGOWjgzmFrp1cWwLQVLQ4PHn5+oeAwFEzbI6hEH+DyuxUzVguMCpQzcV4azxYh9fKKeYqehU2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=NI1hGi7k; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NI1hGi7k"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-724d8422dbaso3198016b3a.0
        for <mm-commits@vger.kernel.org>; Sun, 01 Dec 2024 23:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733123088; x=1733727888; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLfqXZJQxFx0ID0d+PIfJYDOtZpIex7MdVuGIY4Sd5M=;
        b=NI1hGi7kSHxkZVpv2eNq8bJwwai4S9NRjL84x+6YPfE4I0Sg0ZfefAfTx5niYFxthG
         tM49Mfn5p0M/heyBTy2Pb/XBYjEtkc+CQDH3U9MZFR1zbILvPDb9oDTMa2TXriInJKFh
         85PrEzTbjA6d7wyxcCYEr+9RW3KGF7dWbbOXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733123088; x=1733727888;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLfqXZJQxFx0ID0d+PIfJYDOtZpIex7MdVuGIY4Sd5M=;
        b=X37xTxXxpVBiUsH2U3tSKaWMOGCisHC6RzB3NP1LfKx425gPxXlxrrfL3Y7S5Q7y+c
         hiApnUeqXFeex7YvgKV74gNIzDirnEe4W4LtFXbRpmebNlTmiUj9SibYz3Pc0WahX3dL
         Q5NqyI+Tw0+RiIMYBB8L3Aii0UhTcm32cjgxeKJfJKYzkcq4gQxOWLi7vO+B+LSUKK5u
         xr8j4pQKIKE62ULEfXyjjSnAsY5ykYcIq1as5734EnEry6xUgyu72JxQYCmeKWVM/cJl
         vXvIvXwCvqSRiBoKKQAA35YjT5OJCB/KqEH+3/MriMXZuUox7xJCM6tBK9B+ytmySkqX
         310w==
X-Forwarded-Encrypted: i=1; AJvYcCUxCrpXzAIJ4uk24+YrmA1GkvWKF1K6bKN8WDnHBmgzDeUmPS33gnn3oPdNJi5Qx78eMkH2N0cwbPNS@vger.kernel.org
X-Gm-Message-State: AOJu0YzAUFVzhLFodwP/tcf/NINzCcmRpi+p9HTEOywEmaB857/H0o8i
	dVIjNDPcAr2DsUhUlt7nltYPUJ8CPySJ1ZceIg7JOcBlaaRNzpu819bOiKSp8g==
X-Gm-Gg: ASbGncs0JHQnH1Y7FRSXKRC8T5LrCukaf3fRbDpF0nQbsdHDipypXqff+Gy+pp8NwzK
	nxzUR7BoTgN9URjgqIwqgsT+M/81BhCW6jpF7Sg0wK/67IqULCKPFf3r/EZmVAt7aw2sbRJNrga
	dTl3cfvQ725JWRszt65dwrf/O5bYkct+wM7THlB8S1zSCfOxmpN1vDvo5stkB5j1dCL79m/chNF
	ZTpunzQD1yr5zc0mn3eqHhX3U/4kOZ6bxuCmD1JOrDBHQHNBhlMdA==
X-Google-Smtp-Source: AGHT+IG7WekOhmsNbMHO0RZ+HaKfaWeRpfQXGyWiDRhgKbaMjv+o0zn4Fj9YOFjE1iV3ncpCeRcmWg==
X-Received: by 2002:a05:6a00:1396:b0:71d:fe5b:5eb9 with SMTP id d2e1a72fcca58-72530042098mr30436395b3a.10.1733123088204;
        Sun, 01 Dec 2024 23:04:48 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:13dd:b39d:c5ab:31c2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7254176f634sm7727920b3a.59.2024.12.01.23.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2024 23:04:47 -0800 (PST)
Date: Mon, 2 Dec 2024 16:04:43 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: caiqingfu <baicaiaichibaicai@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org,
	caiqingfu@ruijie.com.cn, minchan@kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Message-ID: <20241202070443.GA886051@google.com>
References: <20241130053247.GH10431@google.com>
 <20241202060632.139067-1-baicaiaichibaicai@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202060632.139067-1-baicaiaichibaicai@gmail.com>

On (24/12/02 14:06), caiqingfu wrote:
> [   46.560092] page_owner tracks the page as allocated
> [   46.560101] page last allocated via order 0, migratetype Movable, gfp_mask 0x148c48(GFP_NOFS|__GFP_NOFAIL|__GFP_COMP|__GFP_HARDWALL|__GFP_MOVABLE), pid 1769, tgid 1372 (a.out), ts 45588110160, free_ts 45123127760
> [   46.560126]  prep_new_page+0xa8/0x10c
> [   46.560143]  get_page_from_freelist+0xa44/0x16d0
> [   46.560160]  __alloc_pages_noprof+0x150/0x290
> [   46.560177]  alloc_pages_mpol_noprof+0x88/0x23c
> [   46.560195]  alloc_pages_noprof+0x4c/0x7c
> [   46.560234]  folio_alloc_noprof+0x14/0x64
> [   46.560254]  filemap_alloc_folio_noprof+0x100/0x14c
> [   46.560272]  __filemap_get_folio+0x21c/0x38c
> [   46.560290]  bdev_getblk+0xd0/0x2b4
> [   46.560304]  __ext4_get_inode_loc+0x11c/0x53c
> [   46.560320]  ext4_get_inode_loc+0x44/0xb0
> [   46.560337]  ext4_reserve_inode_write+0x40/0xf0
> [   46.560354]  __ext4_mark_inode_dirty+0x4c/0x1f0
> [   46.560370]  ext4_ext_tree_init+0x40/0x4c
> [   46.560388]  __ext4_new_inode+0x790/0x13b8
> [   46.560406]  ext4_create+0xdc/0x1d0
> 
> and other list this:
> 
> [   47.683962] page_owner tracks the page as allocated
> [   47.684012] page last allocated via order 0, migratetype Unmovable, gfp_mask 0x148c40(GFP_NOFS|__GFP_NOFAIL|__GFP_COMP|__GFP_HARDWALL), pid 1309, tgid 970 (a.out), ts 44091572544, free_ts 0
> [   47.684056]  prep_new_page+0xa8/0x10c
> [   47.684090]  get_page_from_freelist+0xa44/0x16d0
> [   47.684109]  __alloc_pages_noprof+0x150/0x290
> [   47.684127]  alloc_pages_mpol_noprof+0x88/0x23c
> [   47.684148]  alloc_pages_noprof+0x4c/0x7c
> [   47.684166]  folio_alloc_noprof+0x14/0x64
> [   47.684184]  filemap_alloc_folio_noprof+0x100/0x14c
> [   47.684205]  __filemap_get_folio+0x21c/0x38c
> [   47.684223]  bdev_getblk+0xd0/0x2b4
> [   47.684240]  ext4_getblk+0xac/0x300
> [   47.684258]  ext4_bread+0x14/0xe4
> [   47.684274]  ext4_append+0x90/0x1cc
> [   47.684293]  do_split+0x88/0x9c4
> [   47.684307]  make_indexed_dir+0x580/0x688
> [   47.684322]  ext4_add_entry+0x37c/0x420
> [   47.684337]  ext4_add_nondir+0x38/0x11c
> 
> It look like only the file system metadata has been modified.I'm not sure.

What's your use-case, what apps you run and what data is stored
on zram disk?
