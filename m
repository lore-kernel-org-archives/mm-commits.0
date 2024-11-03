Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D42683CD3;
	Sun,  3 Nov 2024 20:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730667262; cv=none; b=nVxRKxiwNnvq8Tucyafu0m3BM+6v9AMjz2Sw0AF0k/C+dKWmjY/mC+JxLNMRbFEAJaQs0QsEMSmQXU/6QYJSjUSY6zOa1UVQL0BXd+5BayBwDjyZ4ygiTicivX39cDS/z3qW70jtKSC/oltJRrofWPQ2MlvUpFTCCMrenzTjb7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730667262; c=relaxed/simple;
	bh=kLbJ/mPE8oIqsXMCj/qPmq4SLkmMYSVx0tkXyQznC4Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jU3q3O0cSd7IfV+RTZ5n0Me/YEIjIU6rElhKfJdWXY8He+mtz8Vo0DCcV+L2VNOb6Bv3ODelMQUG0cvy4/17ABAg+IUYkQgAaOiVk+vvQi0fF/NUU0MK6Y1bK34vpNGelCcGPwM2kBEXOuX8I+N8sem+XZkt2yPUkITSbl2fPgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6H5i7f9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6H5i7f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D287C4CECD;
	Sun,  3 Nov 2024 20:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730667262;
	bh=kLbJ/mPE8oIqsXMCj/qPmq4SLkmMYSVx0tkXyQznC4Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S6H5i7f92W6DNTMpjTlB1kQ7mRJIqB6cHSyZhSNQXYHmcAOCVMx9TlvceV1lSEc1P
	 ONK4gWmEVWkWavV/G0xkgpNjsZlfvRguXMjVYFKKu5qnbuaQLhp3vJgZlMpeLX18l+
	 roW/J1ZMWmHqOR7rNPvjJ8BMVxbHo2O7/K9MH8v0xhJKN6i5njGk0FoarcqXrSP0D9
	 vbmwklGF1q+zofEu0MX2QKfeKeYqV90ezTSnLVTNy4o/bMUo2upfzGMMzIWB8Su0+p
	 brnLAiKfF3/un9/h76mKGbZD8i4LFloppCrlxLGBEjq9p6J/id7LE/9oq6C5+PVpTJ
	 K1hrRmX1viDCw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB12838363C3;
	Sun,  3 Nov 2024 20:54:31 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.12-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241103105404.3c1a60806b3db3baa1519537@linux-foundation.org>
References: <20241103105404.3c1a60806b3db3baa1519537@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241103105404.3c1a60806b3db3baa1519537@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-11-03-10-50
X-PR-Tracked-Commit-Id: 1d4832becdc2cdb2cffe2a6050c9d9fd8ff1c58c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a8cc7432728d019a10cb412401ebc15ed7504289
Message-Id: <173066727061.3251859.13022424773859445802.pr-tracker-bot@kernel.org>
Date: Sun, 03 Nov 2024 20:54:30 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 3 Nov 2024 10:54:04 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-11-03-10-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a8cc7432728d019a10cb412401ebc15ed7504289

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
