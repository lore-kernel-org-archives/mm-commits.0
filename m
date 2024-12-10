Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8866C78F39
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 09:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823522; cv=none; b=ncF3C2dTyFp6g9Pq5+FrabEFfC+n0qlWyO9gi4jnH9kEoQOU0eOHZHDPCogMSvpAE3/M6rYKPeG+VRwT8GENUv7AhUOEbJ3x/hL3gXS17KKwqGqZFmnwMuI9RMgmOx1tRNhtdf69qtPgZGQ6ZJnTDhXsVtj3eHkgoBLtQvTD3gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823522; c=relaxed/simple;
	bh=WjpOIojkgkWpnxEyPeZp1Q6fKJICHzTILcB2Enu3sis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTK3/1zQTzoV+bi13pAsIWfxB4qWzHCS25NjpBBsuKVcPiLWK2RJ/G5LN2IuRIZR+lV3gI1mwv2//9hMb6WotpMRnTs8qhwNOlu3kRpNMOs8XRRjukttyobrNTBzbjJlaGb5bVJnXOE40QUYoVFCPbzKWcDKcUvKdYB1fMrBtso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=aZ9Feg5c; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aZ9Feg5c"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-725ec1fa493so1511911b3a.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733823520; x=1734428320; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BjRmYQvTA7kxtBMUl5Qo/AdAWgQX/9nORXlDtE64dqs=;
        b=aZ9Feg5cA5krq2QVYQ4vaC3v+wWyBzJjfq/7fojXi2oHjZm0nPOepWuA85yP+Z+xsj
         74Mc/QB27hWUHZK9lRGPNA9WxnbrbR4HsBA9e1xooxs3NFOcjrH+YSN4NbQTzloGfJOp
         rhK3xjbfmOzOWXnbBRJwh6qiRug4ED7na6/LA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823520; x=1734428320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjRmYQvTA7kxtBMUl5Qo/AdAWgQX/9nORXlDtE64dqs=;
        b=oNB3yRbB6UIvKf16oCZGgDNfYSmh0YxdFsB9JWZYM71iX+hbGUXrPNv0CbMsE2tTjL
         EbgA46Fa88jxsg9Zy0CrIDaclM2iCZ7hq9R70hhjdr65uPYDVNhOxRJL7Db5gMYhlDmj
         r+rw0X3VyKQgrCMi4Z/Uz0TBENZ2WfK4xkWkP8054tuBAv8PgwwQ53d+J7QtR8AMAA2U
         RudrdW5KUy8by0OS0OxALiX6ZAJGJICOnGkrnPXQYl90vAEDfA5djBdbkYQ5uupIB5Ty
         MkQhMiy2C8rae/FMMeMRc9ILKF0Uo2oKq8h5JY4U+/qG6FA0nM3X77wiOl1KAwru1cYY
         zpSw==
X-Gm-Message-State: AOJu0YwnxdQjKzHAMWB9J+MkfVC+9uWepxTk9jQducIuBL/mElYA3H+b
	UFNHFrQcDa0ecXYE8mTXJNG73M5WaKbVL1LBLJMUfFR70Du1zciFY8l0WltUYA==
X-Gm-Gg: ASbGncsJtfCofZYQxXJxx7VXkoQJaWZ2ydc0N7tDLsCswVqtjt0CLcqB+1pnG8/o40H
	CWxy+BUrNiIK4RxLpkYtVKjliGyHFnIHhJfbTYYgALJH79jD34AYAtaBpZXUYwsKlxz97PShjey
	k0uphmskGaOfgMQfd4NRLJ6IKPSnUJo160KVboigBkanTUzHN2BrUIZw2TKo8vFQOdZTaHx9s2u
	vM8Zqwd9NIlD7sS3gWInnek0MEdpOs0hFAD1hRgYGRMK9L/XBbdSVAtGg==
X-Google-Smtp-Source: AGHT+IEb8ACl2x/OdhBgRMdOW1Hd76kamKMN7FQrKTcCyTM28/YAs9JuHDB/QXd6FPDBowYh+y9YTQ==
X-Received: by 2002:a05:6a20:d487:b0:1e1:a693:d5fd with SMTP id adf61e73a8af0-1e1b1b1bdb5mr6797786637.25.1733823519939;
        Tue, 10 Dec 2024 01:38:39 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:4d97:9dbf:1a3d:bc59])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fd3a268449sm5256997a12.45.2024.12.10.01.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:38:39 -0800 (PST)
Date: Tue, 10 Dec 2024 18:38:35 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org,
	senozhatsky@chromium.org, minchan@kernel.org,
	caiqingfu@ruijie.com.cn
Subject: Re: + zram-panic-when-use-ext4-over-zram.patch added to
 mm-hotfixes-unstable branch
Message-ID: <20241210093835.GN16709@google.com>
References: <20241130030456.37C2BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241130030456.37C2BC4CECF@smtp.kernel.org>

On (24/11/29 19:04), Andrew Morton wrote:
> --- a/drivers/block/zram/zram_drv.c~zram-panic-when-use-ext4-over-zram
> +++ a/drivers/block/zram/zram_drv.c
> @@ -1633,6 +1633,7 @@ static int zram_write_page(struct zram *
>  	unsigned long alloced_pages;
>  	unsigned long handle = -ENOMEM;
>  	unsigned int comp_len = 0;
> +	unsigned int last_comp_len = 0;
>  	void *src, *dst, *mem;
>  	struct zcomp_strm *zstrm;
>  	unsigned long element = 0;
> @@ -1664,6 +1665,11 @@ compress_again:
>  
>  	if (comp_len >= huge_class_size)
>  		comp_len = PAGE_SIZE;
> +
> +	if (last_comp_len && (last_comp_len != comp_len)) {
> +		zs_free(zram->mem_pool, handle);
> +		handle = (unsigned long)ERR_PTR(-ENOMEM);
> +	}

I don't think this needs to be this complex.  A simple -ENOMEM should
work, that's the default handle value in this function.

Andrew, can you please fold this in?  (Or we can just ask for v2)

---

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 52a005face62..5de7f30d0aa6 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1674,7 +1674,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 
 	if (last_comp_len && (last_comp_len != comp_len)) {
 		zs_free(zram->mem_pool, handle);
-		handle = (unsigned long)ERR_PTR(-ENOMEM);
+		handle = -ENOMEM;
 	}
 	/*
 	 * handle allocation has 2 paths:
