Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A4817BB1A
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 17:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712770679; cv=none; b=I0kpP3csSlTigX81//ouXHEOtHNUNt9eJwyEqtQ2UlohQKclTaj8PB/Em4EHvl4YcBD+t/htPr6SPzwDL1h8qDi/wbSkN9TjxFDyA2MHW3DWMf1fx9mWdlFu0ngQM/sjuqWANJDlVi4OfIRFFEyPOZLHR65scYCyfJKExJGzxyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712770679; c=relaxed/simple;
	bh=MUnTblFGCth+B0IW/RMKU88iBw+Wv84EDuf9KtSj/8I=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fF++88WeLwWiOKd5ZvTN+sI8zEKS+8XL2qDlL7bPNTsIfTWfsvVMwQMxhLuDH7s53k2JKNuGOSkT2LojKgSe5yR6gfZx4pDSzf7OiVfXjTRRqpXrZZp9mGxQdXp1usq66PGOCM9aO8KP+R2IvZg2RSscPCiAtNaWvA8gM/X1Vco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kEshn9Mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kEshn9Mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F28C433C7;
	Wed, 10 Apr 2024 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712770678;
	bh=MUnTblFGCth+B0IW/RMKU88iBw+Wv84EDuf9KtSj/8I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kEshn9MtunQV/kOYLMI2KkjdZ/Sfz1Y6nov6Gtzzt2pbwyYy3zWjoNxsZdAuxK5h7
	 HeprrPiHIsr6lsdREusNERx3mBaVnBtrp7lo+t1h5lf3v70eJEY/DvjBUXKA8RcVo6
	 GsPKMNF17n6RihqH/xHHWQ37oUzrzw1ZJN4BxteM=
Date: Wed, 10 Apr 2024 10:37:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk
Subject: Re: +
 bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch added
 to mm-nonmm-unstable branch
Message-Id: <20240410103757.dee2241d8b4708358e26157b@linux-foundation.org>
In-Reply-To: <20240410085627.77c36525005364940404ad7d@kernel.org>
References: <20240322002657.D73F4C433C7@smtp.kernel.org>
	<20240410085627.77c36525005364940404ad7d@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Apr 2024 08:56:27 +0900 Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> Hi Andrew,
> 
> Can I pick this in my bootconfig/for-next tree?
> 

Please do.  Once it turns up in linux-next I'll drop the mm.git copy. 
This is my standard procedure.

