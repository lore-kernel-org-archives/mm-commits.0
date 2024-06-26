Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE1D19005D
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719423400; cv=none; b=WdcOWOssuAN3L75sdqWx8uTOPqaWtYplbmcqSVnk9IvVPrKyjGdUYqcOxOxO8aLskEqYoDPCIpCySp1YvlTbwmJmJvXORjUoxZL0ktwT8BjdTn6PZuLwneQQnbdpjL6fCJcmz32E2m48OQhH5i60c5QGPTbJRYWBPUa4xCnKtr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719423400; c=relaxed/simple;
	bh=wWzhqpHTVtLsVD4iQ+TR3LikY+F2UwyjT1MrHMsTOZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvhqKacWIE9ObxRkupFEPgkodYk+ohVOiKyPxjrthpDIXwLu59YRt8Cyv287gZYnBve5PDe4YZ3QGUDsWpJUuWN7uqmjti13vNNN3pvm24TkgxtT4WNZUj8NDUBfeaBKt1LOnCRyXWelCid+v8VMFGZ8DGeYHEy9bBuiQCcXMwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=fiFb4KFD; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="fiFb4KFD"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4ef33a09a3aso2016445e0c.2
        for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 10:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1719423397; x=1720028197; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mfevt0G32wciVUdnWUpueR27fCiqAh3u1Fs8waVishY=;
        b=fiFb4KFDQLsaKN/Vb6h8VY+n2KBIN9+vOd8cZIp3sosUXOclFzyR+c4EMK1rgdcu2g
         Z6oIFQ+son4RC6xUvPE6EAeLOrqJD4mFT+RXp5Hki3V1NqO/yCdJ5J9h9so68S7+VXZc
         ybGG/nldLAdImBwP/9HHUB67misqsA0uDuIMekosOYu9nWXgRuL7kPV6Je1gBHi1UJS/
         eqtr9roG4v5qgXyLzQviZ52xBh6YX8UU614kFyZhjs3eKMuT2fQZ3gQdjCzNHN3WPfaN
         ZZcDQzjRbt9Saqvjlup/eREGfYGNxDfVgEURaP8+435feEf+qQbDxRAMpZR49yNgR57U
         sneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719423397; x=1720028197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mfevt0G32wciVUdnWUpueR27fCiqAh3u1Fs8waVishY=;
        b=oRDaJA8+MzgkeQ+TsCcjA7czdRp9Qtt2HyJiz6VwZcTq+ec+6FxiWO6an3R++gTuoh
         0fp+L3bUpPeEAdi2ItYclThxuS5cxzivG/jh6/e/G3kuP0eH6UdgATGruEEbQCHDUsA1
         801TylhrlQa5S2UiVL2HG1cylY8bmK6JYU4OOTkth9hXkq6SkO/dqWf44LxUFrmENXID
         vq/1c0fNA+3nSRvxYJCyOxUPrvlt/pEJqBhQLwOzlE2oBpAdCXy5GXcQca2uhB0FrAJn
         hjubptT1nzmol0W6QbN/qaMrXnc2lM7e2Qv32pHUql1RzVLMigNpSvOMdkcfzMA5oq7n
         dYyg==
X-Forwarded-Encrypted: i=1; AJvYcCWn5a5vA24av+GKihdRwBjVAwhrHfoklM6NC/Kljwv8nUqGMrFjGiWqwxcX4GWAUfbA4xGYxm2MZu/4LJFoX4BGL4ysv/815KIFWw==
X-Gm-Message-State: AOJu0YzrNpXSfEgdKv+pgo1+syl0y+WWT46ohleE67ldRxxgRwk3pfzm
	vP4uGYDvo0jRCkEQUTzqdYZo1XW+Q4NxKGl1nWkaFJoudPFBfzX6tCY5qloR3rU=
X-Google-Smtp-Source: AGHT+IEb5UpWwuEQ/V9Yp5iARPlgKGws2rgx1647y65D3HPx88MNCt7jpZuFKfsQZBxSwl6xz6Wx6Q==
X-Received: by 2002:a05:6122:2188:b0:4ef:64a8:c61b with SMTP id 71dfb90a1353d-4ef6a61f825mr9272522e0c.7.1719423396954;
        Wed, 26 Jun 2024 10:36:36 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:da5e:d3ff:fee7:26e7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b51ef694fcsm56032936d6.131.2024.06.26.10.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 10:36:36 -0700 (PDT)
Date: Wed, 26 Jun 2024 13:36:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	yosryahmed@google.com, willy@infradead.org,
	wangkefeng.wang@huawei.com, tj@kernel.org, shakeel.butt@linux.dev,
	shakeelb@google.com, roman.gushchin@linux.dev, rientjes@google.com,
	nphamcs@gmail.com, muchun.song@linux.dev, lizefan.x@bytedance.com,
	hughd@google.com, findns94@gmail.com, david@redhat.com,
	corbet@lwn.net, chrisl@kernel.org, schatzberg.dan@gmail.com
Subject: Re: [nacked] mm-add-swapiness=-arg-to-memoryreclaim.patch removed
 from -mm tree
Message-ID: <20240626173630.GA142260@cmpxchg.org>
References: <20240625210334.0BCA0C32781@smtp.kernel.org>
 <ZnuxTAcFbW0mI5uD@tiehlicka>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnuxTAcFbW0mI5uD@tiehlicka>

On Wed, Jun 26, 2024 at 08:12:28AM +0200, Michal Hocko wrote:
> On Tue 25-06-24 14:03:33, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >      Subject: mm: add swappiness= arg to memory.reclaim
> > has been removed from the -mm tree.  Its filename was
> >      mm-add-swapiness=-arg-to-memoryreclaim.patch
> > 
> > This patch was dropped because it was nacked
> 
> I do not see this being nacked in the original email thread.

Yes, me neither.

And IIRC, the "disagreement" came down to one person's coding style
opinion (one which didn't resonate with other reviewers).
