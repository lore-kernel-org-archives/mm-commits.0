Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A548E12DD9B
	for <mm-commits@vger.kernel.org>; Mon,  3 Jun 2024 21:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717449566; cv=none; b=m7eTp6R8g0IAWBG6zTgo8j/wh9UFXK8+y/O9cDAFMLZxYj6IhPYOntJMq7iKd+/gl7arpA+7YKswNbOWLo6imB/QNQW9yDFOzLwdeD6zdH/Ya/ayZxviRjiSVhLXZmtF1HXYYcmfsTLrbDUBqrjZsN71IHJRIVRpX4C5SJZdQms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717449566; c=relaxed/simple;
	bh=wi2N5tuhAC2u3sDt6GCBZa4ZUjOhYgCCbGPlQu4pq5c=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=UFZKyw0b4Kxfa4kQZnySczq/YR9QAJNa0F11priOSOkdugxK0mgznxhFUY0geFgQQTq1MXuoldNxBz/Hoql0Cb6Mvd04HZqZZfmk0HTGG3qwyvM+H7Pv3bBMSngiQYM+CLDunBUTHzVc9Z+4sTZYzi3Sz9nbUDBtYVNTkorj4WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WynYfZLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WynYfZLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2729DC2BD10;
	Mon,  3 Jun 2024 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717449566;
	bh=wi2N5tuhAC2u3sDt6GCBZa4ZUjOhYgCCbGPlQu4pq5c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WynYfZLFAnDzAvPZnM9/ppv9LOE6jE/cdiYsKIDAzV2XrIHT1+Ttgoe39UqOz92Jz
	 NntwDXWjRpWmz4Gs8jOyM2O5uKYMtS36wboPVGWndVoty1W+ISntc/oFkX7ytmcddn
	 qP9M8UkasjLR7hog+GdTP4hGgeQ5LNHERRxUal74=
Date: Mon, 3 Jun 2024 14:19:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will@kernel.org>
Cc: mm-commits@vger.kernel.org, zokeefe@google.com, xiehuan09@gmail.com,
 wangkefeng.wang@huawei.com, songmuchun@bytedance.com, shy828301@gmail.com,
 ryan.roberts@arm.com, peterx@redhat.com, minchan@kernel.org,
 mhocko@suse.com, ioworker0@gmail.com, fengwei.yin@intel.com,
 david@redhat.com, chrisl@kernel.org, catalin.marinas@arm.com,
 baolin.wang@linux.alibaba.com, 21cnbao@gmail.com, v-songbaohua@oppo.com
Subject: Re: +
 mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch
 added to mm-hotfixes-unstable branch
Message-Id: <20240603141924.32e4118a478f0d75b18e9cb0@linux-foundation.org>
In-Reply-To: <20240603131346.GC18991@willie-the-truck>
References: <20240524191054.60D9CC2BBFC@smtp.kernel.org>
	<20240603131346.GC18991@willie-the-truck>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Jun 2024 14:13:46 +0100 Will Deacon <will@kernel.org> wrote:

> 
> I was hoping that this would land in -rc2 to keep the testing bots at
> bay, but it looks like it's still not graduated out of -next.
> 
> Did it simply fall by the wayside this time around, or are you waiting
> for us to do something on the arm64 side? I can pick it up for -rc3 if
> it makes life easier for you. Please let me know.

I usually give hotfixes a week in -next before sending them upstream. 
I'll include this in this week's batch Tues or Weds?
