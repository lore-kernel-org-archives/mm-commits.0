Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434B0DF49
	for <mm-commits@vger.kernel.org>; Thu, 11 Dec 2025 22:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765493991; cv=none; b=DFXV74zTRUIFe7O+CT4jAzkF7etx2q18GmHy3ZJ78vL/B6OZGGhkeh7kcPzuJQgPV9Q89sYHe8jm4FqMA8n0mkAq/uEu9EIBUt9KuCuG0JsnGuXYcOg0AHUBidPUVHk7euBV/tE0FEYvrnHpE1kPV3V3J45k8qpTPPFQhOKjEFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765493991; c=relaxed/simple;
	bh=H0Xz/irq7FmyBN3PvoRZF5cfAE/b4bJI77DZGILjm40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IluOIJmSTaB3MXdALj5iFtNUpLL/C3mermcoFgr7xU9RtCuxD2VJ+qJY7rsteuZSgvcODfANPVg/1yyI3i8/DAO9MXlua+z1RFyLuh58+KjCjLy+0MNDDrNx+TvU/R2MkGNBYmetecvy+Mm9hHYxytH190ymn2JU6E3QzmE4Pkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hn399YuG; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hn399YuG"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-78e2fe1f568so6725477b3.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Dec 2025 14:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765493989; x=1766098789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlR5dyPRStLA8uVUCn+GxTt6FuED+oaJ+jr0XhGSKT8=;
        b=Hn399YuGaaCCDN37LI9i2MU/3WqFtj5VeDb3ABSAx/pBRQj605ClEjwvxmhHBTvmiY
         Vq3/Au+yWAkzmfb6wqa06QVYip5S0YZX7WWPdsVioE2vKnmKQxV4lPgrQbvojWVLtKqD
         Rcn4tWnR/ZCHgrEUCoXBeRdxMuCoBRK1rGC/ed3MtQwsD93sH6z7PmCmrrUl1Gb7Nizg
         NR3s0zlkc85m6F1G03yvoMAva2zKx/o7jxLg+E5LvMBLVwH1JLpkczT1+cFjIPTW+n0R
         /5bAqslCQk6q8WF50Ri5ylsyncGZRPD88sXP+JzTQs7HdMxVyOdX1KW9PeftdjM7gB3j
         Ya5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765493989; x=1766098789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SlR5dyPRStLA8uVUCn+GxTt6FuED+oaJ+jr0XhGSKT8=;
        b=fj98HQ3J6DNWGrG/ehoC1P+8FOGE5oulFLCZJSb9eBhdcjtcEOHipODlImFQQs8MWk
         TMacC/sYwRd05zAOQriMYWgb/hFFSfYW/PfE1Y05FYDATLx0W4zLdzV0Wi+GtqGerUFx
         hjcRkWxzg62JIkyW5ZdgYxlihd6w6/uqeQrUZCP+MacJv1pQejaExNVQ3cgjey7+3GWT
         IWZe/uoJgIDDKmBNKcpkf2O8jnXnhNslYZI4J5+QsmO4Vy26kOqwQYDIE2KRSJSz7qHj
         uPydj2UFGXliDwgG5nZsXU59qaAqQ91jta2Yt+7uyxduQWarzQUW0TeXxAxFwi6eDwDL
         +5Tg==
X-Forwarded-Encrypted: i=1; AJvYcCWiFDApEQeA41MTmbZbus4fr4PkcjAhxwBk566cKCudfc9WqnhfZe7otmPW8QGemai7o46/fdOTb7U0@vger.kernel.org
X-Gm-Message-State: AOJu0YzDbB1R/PlxZzQb/6DFrCOFLnW5RI2CH4dSfs+Xcwuiw0hEgLSo
	9Ugsfi5qdGK61nebCYdwglyrD+UFCRz+vWIwyEKiHAEdtqo/XIQcjsaN
X-Gm-Gg: AY/fxX5cgG29lQHJCSvazvs8LM5YcxaNEE5fW6AoEGCQlhUt8CnpeUq2erG9OgnbF1l
	sX+ESKsRGbhBk0UUz06RTXItDFC8wsGHCMs0GuxeMm/q1H447W40ztwn2lAYxEdJViKylGKEOsw
	jWWj4cVlTdzItf6nqAXdndufnqodGDL+P76fM/3XbEzmKxwou+5cIEDOB99amN3iieDLHdC1rga
	4tXwY48uFeqeszoFDal2BdLdEP2RCFHkxJ/fNUeYJ5OljYQT4aIC5XvOxleqWrDOGwHj4QCTU+e
	LmVkssUx82WomOjg0tF57i6d03T5U3DFurdlNfCSJV/f5kKEzRmuHtdaPqtAjFVXSfdiPBmB2qM
	bZExz7wKcEChUOK8TrmHqkqGfRWOidTW70SUytEd/81oygJFo61caKZ/PNVuaJTO5dVq5YGSG7C
	XhEPQuvb0J6KlDKcihtnki
X-Google-Smtp-Source: AGHT+IFw2vGNNjjj3/jRl2oZ08zme4Jm23Xg+NsVTpZN7KhFXaP5tMl5DMXggaKmd8kLUyaK9fttPA==
X-Received: by 2002:a05:690e:2441:b0:644:4f94:c530 with SMTP id 956f58d0204a3-6446eab09a1mr5210641d50.39.1765493989052;
        Thu, 11 Dec 2025 14:59:49 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78d69c60507sm13907097b3.17.2025.12.11.14.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 14:59:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Daniel Palmer <daniel@0x0f.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
Date: Thu, 11 Dec 2025 14:59:46 -0800
Message-ID: <20251211225947.822866-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 11 Dec 2025 20:12:18 +0900 Daniel Palmer <daniel@0x0f.com> wrote:

> Hi Andrew,
> 
> On Thu, 4 Dec 2025 at 14:29, Andrew Morton <akpm@linux-foundation.org> wrote:
> >       mm/page_alloc: prevent reporting pcp->batch = 0
> 
> I think, maybe, the following part of this patch broke nommu.
> 
> -       new_batch = max(1, zone_batchsize(zone));
> +       new_batch = zone_batchsize(zone);
> 
> Before this change on nommu zone_batchsize() returns 0 but the max()
> changes it to 1. Now it'll stay as 0 and anywhere that depends on it
> not being 0 won't work?

Hi Daniel,

Thank you for taking a look at this and finding that this was the source of
the deadlock. I took a look, it's definitely an issue. The problem is that
the patch gets rid of the max(1, zone_batchsize()) and handles the MMU case
by ensuring zone_batchsize never returns a value less than 1, but the
NOMMU case always returns 0.

I think your solution below works. I've also come up with a simler workaround
which doesn't change drain_pages_zone:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d0f026ec10b6..9d638697cec8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5919,7 +5919,7 @@ static int zone_batchsize(struct zone *zone)
         * recycled, this leads to the once large chunks of space being
         * fragmented and becoming unavailable for high-order allocations.
         */
-       return 0;
+       return 1;
 #endif
 }

Would this be enough? Then we don't have to worry about handling zero values
from the callsites for NOMMU machines as well. But this has the opposite problem
that I was initially trying to fix, which is that NOMMU machines will now
report a batchsize of 1 in zone_pcp_init and print it out to dmesg, which
may be confusing for NOMMU users who expect there to be no batchsize. So
it totally makes sense for me to drop my original patch completely as well.
I'm not a NOMMU user so I am hoping to receive some feedback from folks who do
who can chime in on which approach is better.

> I'm seeing a deadlock on nommu:
> 
> https://lore.kernel.org/lkml/20251211102607.2538595-1-daniel@thingy.jp/

I would also like to take this opportunity to ask any NOMMU experts out there
about the apparent disagreement between the comment in zone_batchsize under the
NOMMU case, which suggests that NOMMU is harmed by batched freeing:

	/* The deferral and batching of frees should be suppressed under NOMMU
	 * conditions.

And returns 0 here which makes sense, only to artificially set it to 1 via
the max() later on and still do batching anyways by
<< CONFIG_PCP_BATCH_SCALE_MAX.

Thank you Daniel again for helping root cause this. Hopefully this fix works
to fix the deadlock you mentioned! Have a great day : -)
Joshua
