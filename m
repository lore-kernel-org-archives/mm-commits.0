Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803E0AD2C
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 23:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716508206; cv=none; b=b+TICGuLvGG9rbmIkKIvISERSor3sOx4zXOVQWFMly5zERw4NgWsC1LY6Z28qmZFhnnrGRe4BGf+aaxUaNztAwOqBwoMjwWJqiRRCgfNv4v8WEbTEAKeZ7IxnjI3ZDd6hAGCAItDx8UzTMy9OBc28Uii5nYzgkrSaDIwK0lPUrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716508206; c=relaxed/simple;
	bh=Hxip3KvIRGbJovN89QrkSRYQQNnDn4RsW2aGXz0EPgo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pOnKZ8bav+Wo6mBCpQQSlWKmqQkRS0wYrthxkxpHURBZtSrQFGztOnrFTuTwGyew6zVsl1ZoqXviqgka3lyNl++40KlBKbz/0A3JfAwAhBJb/11BFtNRoDaKGgW4J67OrvGakZUB3nlIuSKEOi072tWQ1BzxTfZDBZWcNkHMin4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xHbg8jXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xHbg8jXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0CC2BD10;
	Thu, 23 May 2024 23:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716508206;
	bh=Hxip3KvIRGbJovN89QrkSRYQQNnDn4RsW2aGXz0EPgo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xHbg8jXZDdFjOjXfHrbSbCpVnCaVrt4fNVaWt6hQ/rZ6H6yv2kNOC2xPhn/Na/CxI
	 T1inN1T5vT7odtxJ9MzfbD0W0mQ0bZ6bFpPfnwI9XnvfajOihrvLEYA/CnilKE6P1z
	 wSDEK4BQ8LFVIwMsVGxLVIdfHjfqOlQK4VBRphAw=
Date: Thu, 23 May 2024 16:50:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <baohua@kernel.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
 willy@infradead.org, ryan.roberts@arm.com, ioworker0@gmail.com,
 david@redhat.com, baolin.wang@linux.alibaba.com
Subject: Re: + mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch
 added to mm-unstable branch
Message-Id: <20240523165005.3b1569628569060cfba211f4@linux-foundation.org>
In-Reply-To: <CAGsJ_4z_FiDM8v8h8gbfmr5ooU8Dw6TyQrG3MXRUdOzQfmrjhg@mail.gmail.com>
References: <20240523194021.CF145C2BD10@smtp.kernel.org>
	<CAGsJ_4z_FiDM8v8h8gbfmr5ooU8Dw6TyQrG3MXRUdOzQfmrjhg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 24 May 2024 10:55:17 +1200 Barry Song <baohua@kernel.org> wrote:

> On Fri, May 24, 2024 at 7:40 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: mm: drop the 'anon_' prefix for swap-out mTHP counters
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-drop-the-anon_-prefix-for-swap-out-mthp-counters.patch
> 
> Hi Andrew,
> 
> Baolin is aiming to implement this rename for version 6.10.

No probs, I kinda missed that in the changelog.

Things like this should have a Fixes: so that anyone who backports the
original feature patch knows to grab this as well.  Please?
