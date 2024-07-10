Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2225C12C52E;
	Wed, 10 Jul 2024 22:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720649778; cv=none; b=QTuqOMUvuFfXUyCEPUsELzC1X1U6zuixtkpt83d2GCJ6TktKQRTXHwYH5iS5YMbsyrXazHMvF2lI0GQrANfsYx+CeIm6e/JVYMMAztnvFs+SvloRl7ppK4cU7uS5dGDOrXZah0WtFtTPNWZcuUvqGElGrr+DGg5Gzy1fYagFm9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720649778; c=relaxed/simple;
	bh=D9sg10VzcQINEKKWOwv6L1Yd61n9yqq4lXu62g4KdC4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=i9UkkpSkPlZkbZPRDdFWHV7dJd4DJz7Dd/Q3Zt0o1+3HO/iwoWKnsD8lHbXTZr5ulWqSfmAZ2CpF/ws8wIG/ZO4W9iyol+wuXFDDW3slNsVXcIKtIxJ0up3J+jqUX1Y0LGZKD+tnup6xaqUhcMTIM5x4ycY5aZAQslkOxujiYj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6SeWXMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6SeWXMO"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0455CC32781;
	Wed, 10 Jul 2024 22:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720649778;
	bh=D9sg10VzcQINEKKWOwv6L1Yd61n9yqq4lXu62g4KdC4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=j6SeWXMO6ZNzwh5yqNcdOyEPBZTW+6lkv5hnXi/bwar/uOt42l/Bs4oragY+75Xy2
	 ZoxspjxEY73ZA86oCSm5XIJ18vWOBzQFCQzcTQEBadWI8u1vrjDfQfHpw98DXOMFEu
	 AmDDxUMRyA3WbBp4x3m1VMMd20c6PY8m7a7uPDKTo5S0bgK85Krez9df/2aJfJk5mV
	 B1DRxmxLcDRmLAxrFW9JqxwCbcz6rYhirKanEuY7xf0tzF9AQnEwLpE/pzX4Z5icyF
	 +bo77s74DGBw+Y3uuv4g1o+EbN+uSz8M29puw48mFPvCeojGL48eYxVeNYN2YWZscB
	 w4YTyl6H5J//A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EED81C433E9;
	Wed, 10 Jul 2024 22:16:17 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 6.10-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240710132333.0ef20b0442ffd813429ec240@linux-foundation.org>
References: <20240710132333.0ef20b0442ffd813429ec240@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240710132333.0ef20b0442ffd813429ec240@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-07-10-13-19
X-PR-Tracked-Commit-Id: f708f6970cc9d6bac71da45c129482092e710537
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d9a2f29aefdadc86e450308ff056017a209c755
Message-Id: <172064977797.29271.17850898090549768605.pr-tracker-bot@kernel.org>
Date: Wed, 10 Jul 2024 22:16:17 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 10 Jul 2024 13:23:33 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-07-10-13-19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d9a2f29aefdadc86e450308ff056017a209c755

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
