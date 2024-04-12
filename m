Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496B917BBF
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 05:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712899156; cv=none; b=KWwviDhV2bi/IQVo+glqlPvBGNxc6805Ja7aIm5Q9tfMZS5WfzWasfiRQ2br+1l3c1V0ll5FvDFoj0GBWMcGLADcZc5JJICyCNkRszdI4ffd5a+XkLFLDFZMJe3nvKtH1EdA3Rqz1QEZDtOO92aPtCDo2ldBOd1ztb8lTOhbVMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712899156; c=relaxed/simple;
	bh=AjfSbLXRJj8S0KQoJ7oxMBlTklNQqiifqTIOjrwz2Gc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Eoa3zcttBtzmMaXACjUL1UUf/LpKVljSOCIBDT8556RLFmIzK76wsnYFE9mLcMLhkys5o9IrmRuRtxbNQFOLV4gAGdfC4EuCgqOI275elHvBGsNOAIKS15IBfMEQRTSsWkbs21JM8tl/VHJrfAG6hAf6C06CJuI+EmyGOytQQN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4bgs1/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4bgs1/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFCBC2BBFC;
	Fri, 12 Apr 2024 05:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712899156;
	bh=AjfSbLXRJj8S0KQoJ7oxMBlTklNQqiifqTIOjrwz2Gc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p4bgs1/LgycYmQJvAy8nlfznhvIy8/XVY8h6gFdlZ+IjVF51UyyQU8ARHtqI9wP5s
	 rWioLA9F4hXbyufLvLOtpFI2hKmXz097iuUU0xVmh0MNO+1JlM9RQhnEM5Aa6odSrl
	 ULv8OUoKdYddel2UZhu7RXCzlJbDCB3KnFO4AYirhZ83YwOQ03dd4JL97XABVjXqM1
	 gnJJFDiDiwGfV+wGxB2+TrpVB6QXv9pmPzXbKBs/RLlF/iyoz9PKuURW2IHYDBjQsH
	 GRpix0QyDeWxOLE5IM/75TuSAUvlx4p5YcnyhKtDjsP2YRjl+DSUIaxNeRiYvIeIMH
	 AdQX3cPmOv7TQ==
Date: Fri, 12 Apr 2024 14:19:12 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux@rasmusvillemoes.dk
Subject: Re: +
 bootconfig-do-not-put-quotes-on-cmdline-items-unless-necessary.patch added
 to mm-nonmm-unstable branch
Message-Id: <20240412141912.56c4accc0fb1457a2bbee0cb@kernel.org>
In-Reply-To: <20240410103757.dee2241d8b4708358e26157b@linux-foundation.org>
References: <20240322002657.D73F4C433C7@smtp.kernel.org>
	<20240410085627.77c36525005364940404ad7d@kernel.org>
	<20240410103757.dee2241d8b4708358e26157b@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Apr 2024 10:37:57 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 10 Apr 2024 08:56:27 +0900 Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
> 
> > Hi Andrew,
> > 
> > Can I pick this in my bootconfig/for-next tree?
> > 
> 
> Please do.  Once it turns up in linux-next I'll drop the mm.git copy. 
> This is my standard procedure.

Thanks for the confirmation!

> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
