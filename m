Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3BD3D69
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 01:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717204318; cv=none; b=gLC5b50G+6UIPb6WGUac1Si+exzz57b/aSa6c8ynXshgwGe6Kx99D+DqTbYcapIlpxE9mlgXjynuJ787Jve4Hy66ED4eLEjzjS7wnIjKDqmn7jdqZ2uzy/mz1wCQraxZ/FemY8fDpPBObr0sc3owLSqaAIDJ8VPqvO8qGVGXUP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717204318; c=relaxed/simple;
	bh=eFhjz4lhm/CXozQa/lu1vgfsxwuhuv8FSzl9ijhMxiE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=hTysjbOMnhEE+lbt1xsneiIVekGkdlBk+q+u4D9GWbJjIa+PmcZb0nliPRoBLLK4vttNYCTtDLMMv+OWFspBFhEj6aQ1nh9LsfIOO3ICcH7GeZzXuyfi0xFBLGxFL+utuLgYRJVOiLWt+aru+QyiTXu2OovardALm5jnO+MgNBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m5JRYbgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m5JRYbgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ECBC116B1;
	Sat,  1 Jun 2024 01:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717204318;
	bh=eFhjz4lhm/CXozQa/lu1vgfsxwuhuv8FSzl9ijhMxiE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=m5JRYbgY9E8aKc/RynaEtJB3XrL3omYEQ9rnad1lUff/IgmW3rm2L4jYvNUAtDHuO
	 JH0VAKJfVovGb2oxC4QSMHurj1d/1rL6rzdljSlmPkScM3ILyb3DdSa4+VnNUm/GOs
	 jhnOoFc8OhCqia5BV3uLfFyGxDWzxgHb56PKt+vg=
Date: Fri, 31 May 2024 18:11:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com, ying.huang@intel.com,
 roman.gushchin@linux.dev, oliver.sang@intel.com, muchun.song@linux.dev,
 mhocko@kernel.org, hannes@cmpxchg.org, fengwei.yin@intel.com,
 feng.tang@intel.com
Subject: Re: + memcg-rearrange-fields-of-mem_cgroup_per_node.patch added to
 mm-unstable branch
Message-Id: <20240531181157.85647d3bcdc872f41c50811e@linux-foundation.org>
In-Reply-To: <umreni7kauetfdtiwte4fy7w3bgduq4f7sdv7vunl56x36yofu@vipxht5mgmmo>
References: <20240528190057.A650FC3277B@smtp.kernel.org>
	<umreni7kauetfdtiwte4fy7w3bgduq4f7sdv7vunl56x36yofu@vipxht5mgmmo>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 May 2024 15:54:28 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> I couldn't find the following patch in the mm-tree yet. Does this patch
> somehow fall through the cracks?

yup. thanks, fixed.
