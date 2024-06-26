Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0BA190043
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 17:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719423806; cv=none; b=m2REw56xIoevVdq1aGNDfYwseqrqe9rviGKHivAY4yAg8SumxG3+5YKCspndMdSviHF/sUeanxmW1ghKR4/mzt7znLFQb+zp6G7mkNw8nIt7QpHGITDBlhiTXu/pedAi5Of1cl46y/BS6mdPU7WfyvddVqUK5nko2+Jgclqu8uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719423806; c=relaxed/simple;
	bh=uogUGusrSqh4Gt2PYD5aLSVlxgYITdKZZ5lJV1oXUSo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=nqgtpTqk6VGPyJcFJnlUjlxtFIBs3GdUJyOCSU9Bf3dEs7AWedQ6y1p90SvnFjov9s0yX/FTvxlwJSnkCg7wFO8NKYkrLR0rzNO78Azqxv6/M2FEhaOrJ2g/nrF8KAK/kjBHOi8SQywCH8FAhQm7ZVAUDJ7aTpuC1ojFrhvVub0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0H82lXX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0H82lXX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1870C116B1;
	Wed, 26 Jun 2024 17:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719423806;
	bh=uogUGusrSqh4Gt2PYD5aLSVlxgYITdKZZ5lJV1oXUSo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0H82lXX/XcCpe8mC/eS0kMYRoexoVC6yeK/YUbo0+g3fez7KZ/nL63Z55Mj9MN8yd
	 a7ZKZ28PWH5q/D9x1ldu24n41CrClb48mnHmZIHMB3BaIOu/RIl+ML6/r5dbo2znMs
	 Bl5xkTEEfb9ZNJvpdZ6TPbF7ggI8mv8MP7KSaCxQ=
Date: Wed, 26 Jun 2024 10:43:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
 yosryahmed@google.com, willy@infradead.org, wangkefeng.wang@huawei.com,
 tj@kernel.org, shakeel.butt@linux.dev, shakeelb@google.com,
 roman.gushchin@linux.dev, rientjes@google.com, nphamcs@gmail.com,
 muchun.song@linux.dev, lizefan.x@bytedance.com, hughd@google.com,
 hannes@cmpxchg.org, findns94@gmail.com, david@redhat.com, corbet@lwn.net,
 chrisl@kernel.org
Subject: Re: [nacked] mm-add-swapiness=-arg-to-memoryreclaim.patch removed
 from -mm tree
Message-Id: <20240626104325.9dff86f6a4adc94cb1a5b4a4@linux-foundation.org>
In-Reply-To: <ZnxQZkREehawir0F@dschatzberg-fedora-PC0Y6AEN>
References: <20240625210334.0BCA0C32781@smtp.kernel.org>
	<ZnuxTAcFbW0mI5uD@tiehlicka>
	<20240626101137.135997396b4e184643e045a4@linux-foundation.org>
	<ZnxQZkREehawir0F@dschatzberg-fedora-PC0Y6AEN>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Jun 2024 13:31:18 -0400 Dan Schatzberg <schatzberg.dan@gmail.com> wrote:

>  After the patch was accepted in
> mm-unstable, I contacted you directly a month or two ago asking if
> there were any next steps or if it would be sent to Linus and you
> indicated that you would send it to Linus as-is. More recently,
> Shakeel asked about the status of this patch[1] and Yu Zhao said he'd
> take another look but that he didn't remember having any strong
> concerns.

Ah, gotcha, thanks.  I must have failed to update my notes at the time.

I restored the two patches and queued them for the next merge window.
