Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2680F2AEE0
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 21:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731359541; cv=none; b=QCY6Ycw1rd1sa/droK/q+RTRO7BLBFQJ5sUU7DVWYibTOmNukpBLZRxt2/QKa4govQ3bR5nXvW8X6ZccLaki0gU7/Eik9diGMz8qk3kojz7hOfGqdnpE8JnBRqxvbkurig1XPfwqrJabZpJKbocCCdM/r/WMAPXJgwPrdQ7e3U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731359541; c=relaxed/simple;
	bh=ZWPjPs4pNst+Oca6YiTKqKmVnwdqhj45Awkw6cTJV0A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MiBeNSQ8dT5/tTn2o6UsB0wMrE60IXTvLO/VXs1Wyh4rfwMWaTEl2kqbpYoZdDKKa/RBGMVSR/SjZfLgzsVk5Hl8oZ9ofqjZVjVPN4RcBUhMN2VQ9tEZEBpCEBolhd/gCFGFYUlUlq1KnUyuDOS/tTsm6/JWdKXP6QxyHai1puI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bqKZw4gC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bqKZw4gC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92593C4CECF;
	Mon, 11 Nov 2024 21:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731359538;
	bh=ZWPjPs4pNst+Oca6YiTKqKmVnwdqhj45Awkw6cTJV0A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bqKZw4gCO3lU7qDrzwXxzTPRFqEPQ+l7ZDE4rtsyvonsXCeSG48fahO6NM2vqp/EN
	 liV3uxSyTL6Re0V2i1vjWFdrZ6QOQBD3BjF8DS7WSpGDRGW3+1Ht3B2tRvoVDLEW87
	 WLvkbG2yXevVMRaB8JMPQYkm5VzR6qLdQCZFyUc8=
Date: Mon, 11 Nov 2024 13:12:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: mm-commits@vger.kernel.org, senozhatsky@chromium.org,
 minchan@kernel.org, liushixin2@huawei.com
Subject: Re: + zram-fix-null-pointer-in-comp_algorithm_show.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20241111131217.49fd91b5ad7ed900a2d707b9@linux-foundation.org>
In-Reply-To: <7a00249a-8a5f-4a14-87e6-f084c35884a1@kernel.dk>
References: <20241110061637.2A885C4CECD@smtp.kernel.org>
	<d720c44c-455e-4d02-b1f2-02544d48a68a@kernel.dk>
	<20241110181253.0ed6a90d5962edb1a8edb9be@linux-foundation.org>
	<7a00249a-8a5f-4a14-87e6-f084c35884a1@kernel.dk>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 11 Nov 2024 08:14:15 -0700 Jens Axboe <axboe@kernel.dk> wrote:

> On 11/10/24 7:12 PM, Andrew Morton wrote:
> > On Sun, 10 Nov 2024 18:26:14 -0700 Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> On 11/9/24 11:16 PM, Andrew Morton wrote:
> >>> The patch titled
> >>>      Subject: zram: fix NULL pointer in comp_algorithm_show()
> >>> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >>>      zram-fix-null-pointer-in-comp_algorithm_show.patch
> >>
> >> Andrew, can you drop this one?
> > 
> > OK.  It will generate a conflict with one of the 11 zram commits which
> > are in mm.git, but this is very trivial.
> 
> Ah indeed... I don't have any merges behind that patch, so how about I
> just drop it and you pick it up again? Seems easier that way.

No probs, I re-added it.
