Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F05383
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 01:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747098860; cv=none; b=XlXF4+pmPLmeerSCpB2/sRjdUJ7eWPqHVts5kK9E5NMvK+bejqNa+a4RFC9Aefq/F0BH2UayZt58W8fLq6a4XrH7JC1C7Fx4WmGOWTn0mG9pAOxoD9zN80SLkoZS6jkcWlUbReQCPmfE/V9gKqZ4xRqrLzRcHYYy/qw1Gn2ep8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747098860; c=relaxed/simple;
	bh=K80AsJUkQztN8NqlicilHuz8lhOuqGI+2ixcf0qCxBw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pCA1O9H6oO4slzfRzVxEGxIG0Xgla88G1Wij6EseK1yUfjvlYwMUSSMTU631Txf5UV+af+xhLkxzUSFNJiSNeXvYcxdv+pq63dx/PCFgj9ZhBRd+hCYI71gx/qPsB69XulTbM4k/Jdr0Xow830JojaXF0L+dSbtCmvewP5gfNRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=noS7pjj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="noS7pjj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06476C4CEE7;
	Tue, 13 May 2025 01:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747098859;
	bh=K80AsJUkQztN8NqlicilHuz8lhOuqGI+2ixcf0qCxBw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=noS7pjj0i7Zq6V6PE8RKGErYuPV7yrvFKh6x8JK+gutevaPHixPig8JXzkOB1zwyT
	 PkBEsoxjIFj391Ef1GKyPSjgHfiNe7pUE5jGM5Uz3hHkrr86Q7Liyf3awAnyqL983F
	 +HxQRB5FsDO2u62yEQwoj8Y4dJu18OvlmqKrsXCc=
Date: Mon, 12 May 2025 18:14:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, dja@axtens.net,
 agordeev@linux.ibm.com
Subject: Re: +
 kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20250512181418.526650b7a8ed24b013e9c87f@linux-foundation.org>
In-Reply-To: <aCKJYHPL_3xAewUB@hyeyoo>
References: <20250512222307.ABA4FC4CEE7@smtp.kernel.org>
	<aCKJYHPL_3xAewUB@hyeyoo>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 May 2025 08:50:56 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:

> Andrew, please drop this patch                                                  
> (kasan-avoid-sleepable-page-allocation-from-atomic-context-v7.patch).           
>                                                                                 
> v7 has a memory leak and after discussing with Alexander this                   
> 'optimization' doesn't seem worth here.                                         
>                                                                                 
> But as Alexander mentioned v6 also has a memory leak in an error case,
> and I believe a proper fix to that should be (lightly tested on my box)
> below.
> 
> And with the change below on top of v6, it looks good to me.

But does it run good ;)

I'll drop everything and shall await v8, please.
