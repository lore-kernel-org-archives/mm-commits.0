Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEBB17CA1A
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 17:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719423085; cv=none; b=WDK2g1gtNmnhYgaz+iwvrRqEWAijZzkepRCYP5UWv72yYB1ea0rQY41+88iNoxNrf+X1xn/6SWQqsjRCTIY3wy4+ETI95csHLH91Tgv97U6xJcZBDfBZ3Jq04BdcO7rxaOhB8Alf7/b8YS+MxcNPyNvHC35FFD9RH0yMzFnDXt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719423085; c=relaxed/simple;
	bh=BYND7w7CYvTs+fNRMC8M/NOHo4pTZDkbGJq2SfsqAaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQPyWrifqBCOC/MkwEcjU61I2Nx3qp/zZidYGAPx36qeyEDipQGNpU7JDQ16H9FHn7FlSwjkVNpZ3sFanUA57vGhTGAU9jFPIVUcpyoj2i6cs9gu5bdKUTSRAhyhGoV20HAxCvOLgqJmy6YGCzf3M451PKQn6/06EliGZrYIIEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OhEUoOLF; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhEUoOLF"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f47f07aceaso54338075ad.0
        for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 10:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719423083; x=1720027883; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rXu7hHZldXtZU4G61Jy39xp2+aXNIwQza7/PnXeMBqQ=;
        b=OhEUoOLFz4WNRZtkp87BfcYvAWTcuqDI3QWslxxmePmNDfxgzCTBB3h/XL1UXhG2YX
         AFeweXky6wC9E9hGAtbEHd0g8XQQdCaeXgZ+DTb+Jl1Ex0Iy5bedO6WLUfMNOjwaC0ei
         M09Q5XIwzlQjqKZ5tSaifNq+siXz7BwGA+K7GxlSLcZeqxEd3zLhXbQ3BuDxQE/CkjnG
         He677NvBAK1Llu9hYzlnFeZljE8eLpdm9RLnjuaj7gNSH56UtIgPwMjn//2Wr5nTxwGi
         vu2mW1Z5r+AABQy4io9rCsoOZa8XfKhXyegec8yME66t8g1JHGl2RFGr6V7TjkWK1z71
         j2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719423083; x=1720027883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXu7hHZldXtZU4G61Jy39xp2+aXNIwQza7/PnXeMBqQ=;
        b=p9e6eg4gYciNPNWvu1JC8Mi2d9hP9lN3UqOzaoiM7bwlP50p+mXLYoWEHeg2Fq4c1W
         9JIWR2tPvq9dUuS6nAmhz/+S9pcz0qlw4ixObhIKXtcSE5Uh3NM1tTqoLNabHMQ71vWf
         l7zOySj3ELNEXUORXSRSQ3A5iO/3gIVExcyXazzQ36f4dYIPILoo7jkRtzqzyQjDbsmV
         UiPU8BKjQ3OGCQtHHlaJLHgS3gazo6jCJ0n+QUtn+Tmwm4HqEdsl6zJU0F4aqtG/wZR4
         P4hFDNyuG3m6YIUv/RJOdKiBWLHkfQWBdyDlmmNpMA3P7GQG336rYLtz2hqw0iMAqXl7
         7n9w==
X-Forwarded-Encrypted: i=1; AJvYcCXE80O1lBIhUKcroTEud7WGeafwcxoTzW1WI7tQy/KHXCkoIoI/U3LkLlYNI9ZZYaprVdfPtLYvnGlNcWyohRYY6djepWQwOTQeYQ==
X-Gm-Message-State: AOJu0YyD/VjZ3fAFAsh1wNUv/zgSe0NxGNO3UD1F28YrM478ugDnzW06
	N62yXIe/CGsRDAGuckZNqKTYbEyYPGbbUwW3QD2/g98CFFhG2EuoUXezBKvE
X-Google-Smtp-Source: AGHT+IHWtLntQptqpMER7SI4vMHnpS8DKFoMS78Qw8x6gSqxMiWuQAtd9rEffN23u0PFVBRghlHSKw==
X-Received: by 2002:a17:903:32d2:b0:1f7:1931:7a8f with SMTP id d9443c01a7336-1fa15944201mr118216635ad.64.1719423083060;
        Wed, 26 Jun 2024 10:31:23 -0700 (PDT)
Received: from dschatzberg-fedora-PC0Y6AEN ([2620:10d:c090:400::5:6774])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c5ef4sm102538035ad.163.2024.06.26.10.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 10:31:22 -0700 (PDT)
Date: Wed, 26 Jun 2024 13:31:18 -0400
From: Dan Schatzberg <schatzberg.dan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
	yosryahmed@google.com, willy@infradead.org,
	wangkefeng.wang@huawei.com, tj@kernel.org, shakeel.butt@linux.dev,
	shakeelb@google.com, roman.gushchin@linux.dev, rientjes@google.com,
	nphamcs@gmail.com, muchun.song@linux.dev, lizefan.x@bytedance.com,
	hughd@google.com, hannes@cmpxchg.org, findns94@gmail.com,
	david@redhat.com, corbet@lwn.net, chrisl@kernel.org
Subject: Re: [nacked] mm-add-swapiness=-arg-to-memoryreclaim.patch removed
 from -mm tree
Message-ID: <ZnxQZkREehawir0F@dschatzberg-fedora-PC0Y6AEN>
References: <20240625210334.0BCA0C32781@smtp.kernel.org>
 <ZnuxTAcFbW0mI5uD@tiehlicka>
 <20240626101137.135997396b4e184643e045a4@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626101137.135997396b4e184643e045a4@linux-foundation.org>

On Wed, Jun 26, 2024 at 10:11:37AM -0700, Andrew Morton wrote:
> On Wed, 26 Jun 2024 08:12:28 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > On Tue 25-06-24 14:03:33, Andrew Morton wrote:
> > > 
> > > The quilt patch titled
> > >      Subject: mm: add swappiness= arg to memory.reclaim
> > > has been removed from the -mm tree.  Its filename was
> > >      mm-add-swapiness=-arg-to-memoryreclaim.patch
> > > 
> > > This patch was dropped because it was nacked
> > 
> > I do not see this being nacked in the original email thread.
> 
> Sorry, I thought I sent an email about this.
> 
> Yu Zhou didn't like and the submitter (Dan) didn't participate in the
> review discussion and the patchset wasn't going forward.
> 
> Dan, please prepare a new revision, attempt to address review thus far
> and let's fire it up again.
> 

Hi Andrew,

I'm pretty inexperienced with upstream development, so probably this
is my own misunderstanding. After the patch was accepted in
mm-unstable, I contacted you directly a month or two ago asking if
there were any next steps or if it would be sent to Linus and you
indicated that you would send it to Linus as-is. More recently,
Shakeel asked about the status of this patch[1] and Yu Zhao said he'd
take another look but that he didn't remember having any strong
concerns.

Perhaps I missed some other communication - what changes would you
like me to make for the patch?

[1]: https://patchwork.kernel.org/project/linux-mm/cover/20240103164841.2800183-1-schatzberg.dan@gmail.com/#25887688
