Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E1B16D4F5
	for <mm-commits@vger.kernel.org>; Tue,  7 May 2024 15:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715097328; cv=none; b=gwU6Np0RBWdJbMtmZcMUz2Mib/6vuy4tJvHIAINkM3BhOAokmRfWIW1BUtP1Y4OHk7Tj37Y1QxkRRprJR8nUxos73EN7kFeFDcQ+vKjT1cHqevt0+DHzvO35VUE6wj8BLwjfFM2+eibGyYj/nJxiH7xuBLnA9Ijeh6Z1v/ThpvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715097328; c=relaxed/simple;
	bh=vOhJWwOJBvEBn6uUK/f6Na8jJhJNShP4YqVjgcd1Y6U=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=dz62G5TYmxHzQeljOqSR7gCLn1+joGyfC/McUetQEEpWdVS2w/RDYulo8BgG3QJF7jY/pKnpWStfjQunl6rm562nEPZ3O26qJOCkr/OtqlpgbMBlC+8v0M889o2ZFpbT9bbs6wmCTt8V5aFlI2yopkN6MLe6NSrrYclBe5l/rOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KmUrFuaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KmUrFuaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727CCC2BBFC;
	Tue,  7 May 2024 15:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715097328;
	bh=vOhJWwOJBvEBn6uUK/f6Na8jJhJNShP4YqVjgcd1Y6U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KmUrFuaPVDxiviNntVSqL0zuz+XtspjF3ioz/gUOgjCGs6JwPgED8GERfsvDbe8FI
	 8BXFt00VbgkyJTTDbJuMpTCRmWa215gOhxebJMjBSL9OOQ1yGj/qCJmrqljVk2Lzqh
	 axjDLMDs1t5ghczte0iNtZOhepSC/bs5Nkj3Bv/Y=
Date: Tue, 7 May 2024 08:55:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: mm-commits@vger.kernel.org, zokeefe@google.com, xiehuan09@gmail.com,
 wangkefeng.wang@huawei.com, songmuchun@bytedance.com, shy828301@gmail.com,
 ryan.roberts@arm.com, peterx@redhat.com, minchan@kernel.org,
 mhocko@suse.com, fengwei.yin@intel.com, 21cnbao@gmail.com,
 ioworker0@gmail.com
Subject: Re: [merged mm-stable]
 mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch removed
 from -mm tree
Message-Id: <20240507085526.5f4ea12e85e637dbc8e2e9df@linux-foundation.org>
In-Reply-To: <4e4a03e7-9c2e-4e23-8e76-3b2feae4ccb4@redhat.com>
References: <20240506005757.7819CC113CC@smtp.kernel.org>
	<4e4a03e7-9c2e-4e23-8e76-3b2feae4ccb4@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 7 May 2024 10:15:24 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 06.05.24 02:57, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >       Subject: mm/madvise: optimize lazyfreeing with mTHP in madvise_free
> > has been removed from the -mm tree.  Its filename was
> >       mm-madvise-optimize-lazyfreeing-with-mthp-in-madvise_free.patch
> > 
> > This patch was dropped because it was merged into the mm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> 
> Andrew,
> 
> this series was moved to mm-stable a bit too fast for my taste.

It was nearly three weeks.

> Review is still going on, can we still remove that from mm-stable?

I can rebase if needed.  Is there a reason to do so?  Nothing that
can't be fixed up with followup patches?
