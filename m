Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4653FC7;
	Sat, 23 Nov 2024 18:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732387782; cv=none; b=FzEttvqTlzc77xybKfzS77yOLzYRHa2aKiSVOFnEf/QutT8OOoRDnKOG3FEbC7NDNUrZQTXuJPxcwJk1lo5FQJPkFDTpHoDOKtdUmZfAN3K007wKPhXKL4vLr5VKl+uRQzuOKyyZAOBW+iSaXaZ4zJp+j55WtebrrfDR36MrZHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732387782; c=relaxed/simple;
	bh=0ejY13YBLABJA9mZviX/7Jsi0gTLFU9W1qDfjtP2gug=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hNrYLWVlEUKBdyVWtRKGWi0+HAwohmMGAfoRtfGkOGgwd4WyEK2N5fvgzZvWxwj4K9u/g+2Gk0k0t6AX95AXnh8qWww+iq+e8Jy2wdCAE2fxtwnYlaICM1d1SNGcak1OyLnrJ6stAnB79gd75gFlRGweIsfFpVUfeST3bmcnYEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niXqmcak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niXqmcak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E040DC4CECD;
	Sat, 23 Nov 2024 18:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732387781;
	bh=0ejY13YBLABJA9mZviX/7Jsi0gTLFU9W1qDfjtP2gug=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=niXqmcakcwe9Htwr3zvzzYVPgbgC2pDrt89CPKWUaRJQ/MTHneCelolSzXDUu5NhB
	 VV0tu8PWg3eH6Ni4Bo8GK6sPfRGiS+rw6Puj9ge1K3/TVgrtTnaIO1h3jqZKr6L2w7
	 F0hPIbVt/51HVFyWcErbXi7nbggzmxQV/8shMvkSrUWYWCXFYqlPw0YGT0BBapPi2D
	 2HoQcYbAP5KDfigsn8W81i6BQblI+5DbnSg1eGLvrSz7iPt7VDCPjDwx94KFZXlHhw
	 Dy8jlU90hkSF/FTIvPfpi46xoj/sbgaHboQXx42JXrAhtWcmrO0HX847hq2MvBiyNe
	 P+EZrz6jSzn0g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 713443809A06;
	Sat, 23 Nov 2024 18:49:55 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.13-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
References: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-11-18-19-27
X-PR-Tracked-Commit-Id: 2532e6c74a67e65b95f310946e0c0e0a41b3a34b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5c00ff742bf5caf85f60e1c73999f99376fb865d
Message-Id: <173238779396.3055463.9655465915586785920.pr-tracker-bot@kernel.org>
Date: Sat, 23 Nov 2024 18:49:53 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 18 Nov 2024 19:30:01 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-11-18-19-27

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5c00ff742bf5caf85f60e1c73999f99376fb865d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
