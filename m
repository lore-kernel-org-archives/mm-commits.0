Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FF131A807;
	Fri, 13 Feb 2026 08:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770970454; cv=none; b=Wz2uGnuMmtlTnq7j0qzqgIqgMOklf8s3w1xTq+EEM1X8tfOo/UPw94D9veS6yKPy9swGNduM90JbjWLPmOOB2n1NxYpB8T2MuDrf4bfRn1cIVQpn2RB3TkvC9VW3il2O6H9XbRkiXrRJ4FhVSKPOkx3xKweKa0T/B6dit9dvoj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770970454; c=relaxed/simple;
	bh=KHHTft1r98iNakUAiYkr8HqIRyfuvhWX5WhKA9ZdSRc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HvUxDSRf3PY1gAurlNGzi550XPWGRF2WgLlmrSdJH1DSLPi2aJExZ9oTMx+poRMKbOa0zv6uewgC2o+0Kqvc6fVQ+Jn+EvB2TFpTjedB5DY468nicuxtm1lpTEnVd1dy4Jt3OyQkRdu+mwAMb8nASK06zevDQecSL57xh/DpVqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WS6gPhEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WS6gPhEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBAEC116C6;
	Fri, 13 Feb 2026 08:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770970453;
	bh=KHHTft1r98iNakUAiYkr8HqIRyfuvhWX5WhKA9ZdSRc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WS6gPhEKIYL6CcfVFVzUzZicQOOWYpxvpbVxDK5yZ9OqKUo70EGywi5PTxpLamE/h
	 mKcIO06idqIt2V0bd07gfrnMFcFRrJMkK3Zh4+xTAATSr9KFxJ/mKKifAZOFG6bwjU
	 mDOzFezQlCTdOPIMJ4pdDqOjy5nR7y/fCsSyuvYarQvCZn1cqakOfaG+9rmCM1K/kG
	 t448JMX7VPzDvpTZVgkIeIMqAQUtCFfYsY4pgsPV8T5H2bRemPH9zPMoYcT4PpuBD9
	 GI8CUZBS10Qap0pi4IVtOk5kn8BNDWaQsHmcw7JYnTm2G73c/Od6D+d0j9qXg5XYTY
	 +k4Jv52VYOQVg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
  mm-commits@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] non-MM updates for 7.0-rc1
In-Reply-To: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
	(Andrew Morton's message of "Thu, 12 Feb 2026 10:49:56 -0800")
References: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
Date: Fri, 13 Feb 2026 09:14:11 +0100
Message-ID: <2vxzldgxqcvg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Feb 12 2026, Andrew Morton wrote:

[...]
>
> - The 2 patch series "kho: clean up page initialization logic" from
>   Pratyush Yadav simplifies the page initialization logic in
>   kho_restore_page().

Oh, nice! I thought this would get dropped because of merge conflicts.
And I didn't really have time to do a re-roll past couple weeks.

I think this needs a (purely cosmetic) cleanup because of e86436ad0ad2
("kho: init alloc tags when restoring pages from reserved memory"),
which was posted after this series but landed earlier via hotfixes.

Will send something shortly.

[...]

-- 
Regards,
Pratyush Yadav
