Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3697121C18C;
	Sat, 28 Jun 2025 03:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751081868; cv=none; b=IQ15NORr5Cs9M1N+yVkzCyxU+QufU9gX3MntCJPrtV/CveIcSExoe2pjSQUAGPJFLx5Kb2nNSkR0c16DSgDldhurpVx3zpZx0c6lrq/XUxmiedUxeIONp/RAhbILP3n9uLd/Q1fMaFQVKNdqSHkpzHBd4wTxDOnnPSyEUB0tM4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751081868; c=relaxed/simple;
	bh=19szQ2RMVcbO8ZxDOTqWYVmOMQF8Fx8oP4Tck2oIhkE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=n3IB4RSmsZHrRi0AtwYo4q48GpGUdw1PuzSvvy8+Lba0Yiu+kSAh7EeE6MiaoCkNLLasr+uF9yg+LEzWaX0oKAv+YLgJRUT/e64AyMooEp2HID5A70zOWVc2MMQ2xtGHXahjGP+GIY8IpsyzA4s6Alv5uEP3Z9MuP9CzSrycDOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ssu2wwiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ssu2wwiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA72DC4CEE3;
	Sat, 28 Jun 2025 03:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751081867;
	bh=19szQ2RMVcbO8ZxDOTqWYVmOMQF8Fx8oP4Tck2oIhkE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ssu2wwiuY2f5tUKnLbrJRPaJvTFKlAmJh1VxoPY4i9P6GzIyRcWZAAd4HKsQjcB2I
	 +MyL1uMAJMS7/55v2H824nSIS3lK3gPIYfIiwiaEKi9wAjYpPNP/ndWU+qZvNpW6hd
	 PE9EAv7fgUjBNhhmxPJZHrdqNE+YgxabF+87Jc6CdikADcI5/xKtqPoO+2Cx2OQQNz
	 UhxBj1vHwhaj+OdxnLE03eeD7ay3VsIQxKBfkbjGY3MpMUPb4l2SqGfmaCupWTakkx
	 j0L5n2aamuHu376t7VNU+jO6kc8Ya1JjS8WSzAL8cSlY/WJwfqM4ETmwfZYTLFlvp0
	 EqMx4iekvWu+Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEE138111CE;
	Sat, 28 Jun 2025 03:38:14 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.16-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250627165947.26fdc00007e5acb0ac39bc8d@linux-foundation.org>
References: <20250627165947.26fdc00007e5acb0ac39bc8d@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250627165947.26fdc00007e5acb0ac39bc8d@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-27-16-56
X-PR-Tracked-Commit-Id: c0cb210a87fcdda3c25f43b5a64420e6b07d3f53
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0fd39af24e37a6866c479ca385301845f6029787
Message-Id: <175108189362.2126884.4558946833711183611.pr-tracker-bot@kernel.org>
Date: Sat, 28 Jun 2025 03:38:13 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Jun 2025 16:59:47 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-27-16-56

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0fd39af24e37a6866c479ca385301845f6029787

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
