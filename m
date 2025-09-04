Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABD71DF248
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 02:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756952707; cv=none; b=LvGctF9pbVX/4Ca6e2DCT9TBhOiCoLYOSNF/hUu4WdLDbjt/OlIIFnmGb11KilLvNF782clUBxK/0eghjVgKQU+ISR+2yBx/mJPrj5hcpabqEiW8t5cXZUnuPVxfLU48/a6PjvVaI93htnw/rg2wyvSJOvwLm6mJzjJLmfR+hDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756952707; c=relaxed/simple;
	bh=FWcue33TY8PgAl26oXotZ5Ai8c1zQ4Mspwc4i2MNhto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2hL/Za2bnErO251eAkuSwyx/Jh5TigVe12HVwy/QrSg24iw1RYK4H6dGVlowVaV5FNidipPaCSmdZHz9fwpgz+4TIy2QaYP5fkj5h1YcpVVwGTpb5OuH+UBgFMi5petta4S2lUQm3jDTq+7j1IIGLc/mQ75oqs+KarVmDImGKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=iULBgfQM; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iULBgfQM"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24458272c00so6934145ad.3
        for <mm-commits@vger.kernel.org>; Wed, 03 Sep 2025 19:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1756952704; x=1757557504; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AHncV3BamV2GlyriNmJ1l80uuhrV9MrFV/di4u4PJ5k=;
        b=iULBgfQMYgmph4pF0mQ5oNI/CCIjKa7PSFayzGoZY6U0M9NQS+/PdQjHg4XYlihHf7
         mItoz9I35ljRyOQm9k6CccZRGyR/L6w1985oMlurHMXM3BP6uQZQkcVgUspRgJAeV+J6
         pS34uwTDSUyVQ7bJyemxAnksRSamXVdc1zs5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756952704; x=1757557504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHncV3BamV2GlyriNmJ1l80uuhrV9MrFV/di4u4PJ5k=;
        b=HC462JRdby8gdbzBs1CZfgLx8vwJu5yZbfdGxZDeebeMbG05JogMX2NDxK2YOPuqwB
         alJIO0iVMTAk2jfPKSQ7bNSM2IKaFgTM0yajRgCHu5GRW+Xta8wag/UHrGtxDP9t9Tp1
         H2WNxAcBIctNXenJaNslthh3XmDKeMOkgk/J5WI28Y7WYzwBu5ZOnLe9lvvIPse94DkH
         lqiLC1IK9tXR+mZC/F4YSxyD7Lva1IWVkivfO7GOzBgWUks3N+h8Sje1nA515qu5cg+N
         aJaPbdClS+Khh3WHjB/R66X/ev5dEr9jZ96Qz129WTaEAlWUX694RmU7GsSwoxnP4mhn
         vdXQ==
X-Gm-Message-State: AOJu0YwuMDSRvBb9lYfDUUs6hDuPtDUS4ucE5a1oG7uts00CWGFgLf0n
	Z7NRa+VymFVNfDvoK2D4BBTxMyozXYTakd5IDqCYgmEwiRMUeUt9hDnufBm+cUCjgQ==
X-Gm-Gg: ASbGncvUhW//Q/gel0vxyToisvWfP+CfkbL1D5Snlks+ZKijc3/8EusWMa2NfQ5LI5s
	itriRLS0T5sMaXDTAg8Mkaz9IOuweNX9JctkMAfwUaGfRdUtaZ7H+pPZWX6a9uyUZD7Ho6S3LIc
	ok5tCLdpxobK3ov5U2YeKtC929nhhYRjquUPh3+aYlhI35NOXWGWoa+NHzWe0qALfo2wu4F23A1
	9AaIULcBVy4G7+k1sTBPV5QTSdwkxdjuk0Xi+fwNpp0Ap3UVan7lMIAGJxlyhDBGxaM/MUnm/hI
	xbJUalvPUhPVf6YkMt7tAtjq2nfTfx5JES3P1gRUd/7zjiTJZp5y8+fiCqHjm9hLnrjn/zaQ/Rm
	nupAckBbGM7aThGtMXvMDGaatAQ==
X-Google-Smtp-Source: AGHT+IFAyvo2I1dFcgbtttn7brZ20/mICI4FD8oiu5CdqCBo8lU9u6unGDj/yiuGtxJRzGL+yVvpMQ==
X-Received: by 2002:a17:903:3bac:b0:24c:8b45:d9a8 with SMTP id d9443c01a7336-24c8b45efc1mr57213175ad.33.1756952703910;
        Wed, 03 Sep 2025 19:25:03 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:fc16:2361:9d73:40e4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cc919880dsm4063365ad.51.2025.09.03.19.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 19:25:03 -0700 (PDT)
Date: Thu, 4 Sep 2025 11:24:58 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz, 
	surenb@google.com, sj@kernel.org, senozhatsky@chromium.org, nphamcs@gmail.com, 
	minchan@kernel.org, mhocko@suse.com, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, cascardo@igalia.com
Subject: Re: + mm-show_mem-show-number-of-zspages-in-show_free_areas.patch
 added to mm-new branch
Message-ID: <kgljrwhjjhcmvj3sgkm7hr5ek4ms7ntso4ic5owl3plnmrhv6o@yjhb7dalw4vf>
References: <20250902230419.1B179C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902230419.1B179C4CEED@smtp.kernel.org>

On (25/09/02 16:04), Andrew Morton wrote:
> When OOM is triggered, it will show where the pages might be for each
> zone.  When using zram or zswap, it might look like lots of pages are
> missing.  After this patch, zspages are shown as below.
> 
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> 
> Link: https://lkml.kernel.org/r/20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
