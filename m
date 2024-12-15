Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F19C13D297
	for <mm-commits@vger.kernel.org>; Sun, 15 Dec 2024 09:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734253968; cv=none; b=fc4XgXYBTcb08vAlgiCOL48InZztEqbMJPvXrYhWWf5qhio0I4FVnIaSQI02Xm4s9DWS81GK27jKid3SwzCdodVG5FMPxSkrocFdUCdhiaepgN0MpkUGUBHk13XY1ITmkUqeUJQaCRw4DoSnciaxmizgkfdSakX/dMOU7x7PHEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734253968; c=relaxed/simple;
	bh=hWLJImvCSM4sKYc0tlGvsVbVEuMlaloCsFue2hyDyKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqqwrmbLzUXhFjVBD2CRQQiziFUAe4jCQQgEwDU0KPubmkN7QMD9kOuXqT7TCnsYBkeDWK2AnE0OFPYbmlAc0rvHiUTU8wWYRHcz13nmwCJIUgegqAEkrWZ8394aNKfEvnQJV0IoQlU57AgWteuf4yKXr2YrmEbLymxj4qJ++PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Tr3YSS1c; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Tr3YSS1c"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7f46d5d1ad5so2309896a12.3
        for <mm-commits@vger.kernel.org>; Sun, 15 Dec 2024 01:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1734253966; x=1734858766; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A7xV6bdPVq0jZvolETcgtjwxOUlKzgqRK9J1418AwoI=;
        b=Tr3YSS1ctFPjM+KqxPMZAI5dYzO7MkmfSZsn2mVZd4iI1p3rMctbuzpZWIkhkEtHqr
         XT3F2QDMBJILYOXmajSedQbiE8SpVShYEeqmXQn+tEAyGOH1wPvfTKBfkTxuSNOgWf17
         Xbt2/GU+/muVl03ENowI9LKxI+zme5r4pncS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734253966; x=1734858766;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7xV6bdPVq0jZvolETcgtjwxOUlKzgqRK9J1418AwoI=;
        b=CESXzsWRoeCdoxzbpLTmWFkvTO7obZOio9WWCoP691P2lPxwgZZ6aoJKSlrjPryWbi
         anVzwwpzdG3Z5+/tUQg4amQTFEntGbUTpFkzUx4DjAmwvxQ15PWj9/VszHCO44BN2Flt
         R3cJgLLd0YpkpEY7eE50/t+NZgXb8ax1wAgZd+/9nLhBUXcu3ylxmNcZqUy0EbFMtB7s
         2y0SxYZPXiJJZ15o7qAV7UqynY4fvJVlfGJYZ9hHGn7/Jm8xI8ow0mLDmtJKO9jEPD9A
         vAvJV6EuOU3uDIHLBXvdrJg64OFKoqRv4+cBlk5oYvBoxUPMseKEK62/kvH1aWe49KBR
         8pyg==
X-Forwarded-Encrypted: i=1; AJvYcCXBdQtBOije3jsLidP62/UVwF1LaLaSHw8K63laHP10Z2jYBqThv5yeNd9mL+0nrvgakrK26aBE7URE@vger.kernel.org
X-Gm-Message-State: AOJu0YyDV8HI8uZO5fy4PLnS5wjL3qsrSyFaeLvhHvx/isnkWAGnOBJq
	BwqnYVuRUjJCbjN8TC1ctz4p7wZlfRiK6N6AAInTx/kG35A0BK2PP1ZPKS861Q==
X-Gm-Gg: ASbGncuAkseNigGSaAi+Gy+YHDiPHjv3moJ15P68nweKesPYou1fyiVXG7wAQsbyNgs
	6YMUa2JSnd9303hKvYYv1yd33eP8uTQYCuVpvD8Y0ihY7Nsbhm8MNFJe8+enBtX/+oluM4Kbws1
	pevVGrEKKM96SJeXcPiJkF3xQd+zblfVxqq2bqY6O8/nEw+NMAEzMgP6o7uhZ/RHox/ekXGeCc0
	lABzbgcvqKcBzXECgG1VuQw8le2QiSg3LXD7r1e/vyReP9K2h2Qb4GfeIlapYuRle04FYar6TwZ
	5I3UKR/H8U2iG/baJa2uYQ==
X-Google-Smtp-Source: AGHT+IHQOBJXeycTt1nVwufqo5loREN45qfiUBCW1ecr9NEsls2oe/mhcdZJS0sMRbSgRyYDDCIjYA==
X-Received: by 2002:a17:902:ec8c:b0:216:5e6e:68c7 with SMTP id d9443c01a7336-21892a67299mr106996025ad.57.1734253966639;
        Sun, 15 Dec 2024 01:12:46 -0800 (PST)
Received: from google.com (KD124209171220.ppp-bb.dion.ne.jp. [124.209.171.220])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1e50356sm23494455ad.136.2024.12.15.01.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2024 01:12:46 -0800 (PST)
Date: Sun, 15 Dec 2024 18:12:40 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: caiqingfu <baicaiaichibaicai@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	caiqingfu@ruijie.com.cn, minchan@kernel.org, mm-commits@vger.kernel.org
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Message-ID: <ycujhiaogiwqx24m6fsr555tmvj7sjnhsmg5vl4x2p4tnuobkg@74nrwkugcdqf>
References: <gxxr7y3honggqff4fgmss3v3hcnwplywkhce7al47ji3rzql5c@l3g6c6kpzzwg>
 <20241215085715.165430-1-baicaiaichibaicai@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241215085715.165430-1-baicaiaichibaicai@gmail.com>

On (24/12/15 16:57), caiqingfu wrote:
> as you said:
> > zram cannot ensure that, it's not zram's job.  Nothing stops
> > the buggy actor from modifiying the page at any random point,
> 
> It is not zram's job to ensure that data is not modified.
> As long as there is re-compression, it must be confirmed again 
> whether the length has changed.

zram recompression will go away soon, I just need to finish my
old series and send it out.

> This way we can avoid zrampanic caused by upper layer problems.
> So I think this patch should not be discarded.

Sorry, I diagree.  That's not the right place to fix that
problem, that's not the right way to fix that problem.  There
are numerous block devices that set BLK_FEAT_STABLE_WRITES
bit, we should not patch all those drivers to "make sure that
upper layer actually respects BLK_FEAT_STABLE_WRITES".  It's
the upper layer that needs to be fixed.

My opinon - we need to drop this patch, sorry.
