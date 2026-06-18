Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1E62DCF67;
	Thu, 18 Jun 2026 16:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781800200; cv=none; b=M7U0awoJdyXN0oLya2b8Gwz7XTMowpOrjsqCfeneF3TWJ4cEHLBnfM/V7Zsh+P7EcnLtVJKP2Yhb2cpsj9HVDsVnLQ0HJU0ccuY/0yPsgaolEtJDBdOpptnIwed5fHl3kfIIg297oFSyRJE8YfmxKT7ZDg7G2VKVOVS+vUckDVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781800200; c=relaxed/simple;
	bh=qEOFwoF7RztCLnBJW2rif/P+SEyMxirvYwtToqD9khc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=POOlcoy894jteWynAqJk15YCxNt0BM1KUtBz5wT2s8LUZKeKgaoOUC4NezGR5g9pgiPmwCLsAUJ8hYpZ77F1z0BEAHPXBVGmjDbv+qHmdJxqW9HXUTYDQqte+SqIigmc5WIKeCbYlkVm1/dLWW07EOOINzVCl4QiQ1bz2otttHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=plexdl3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="plexdl3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495C61F000E9;
	Thu, 18 Jun 2026 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781800199;
	bh=2DQnlws4wWcJ1dLl6el7H5YeJjw4j146Dai2SHHxJ38=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=plexdl3XvWRzI1joncA7IjRg4N6k+Fd94qagAqnKV8Xm0NQdJAhItrFKd154SQ/Xo
	 B+sWsVsDyOYJOfjYpqMl7QP4mt1nW9ETznvul51cg1NJoqcK3NHMQYP30t0bMbLyvv
	 L2naVy8yoxNui5gGIYN/jtFa+YPiQzxhrgupvwLo=
Date: Thu, 18 Jun 2026 09:29:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pr-tracker-bot@kernel.org, Konstantin Ryabitsev
 <konstantin@linuxfoundation.org>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
Message-Id: <20260618092958.28c03ea5978cd6d61547610b@linux-foundation.org>
In-Reply-To: <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
	<178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
	<CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Jun 2026 09:02:06 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And I have no idea what Andrew did to generate that bogus pull request message.

Me either, sorry.  Let me redo.
