Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1DE3806D2;
	Sun, 29 Mar 2026 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774802590; cv=none; b=l6QkAlPMsUsvlUc8VC/qVnwgFSk8J1MZRUZevOHuTikVVsvV/H+6MdK5PxKMuTiK2C2kHM9Q329oe875eF6DJDdQoagEUbdNFglcMErOmGoECQPMbJ1Sgw4sPO7CIzwxeB2pdBhX+1W5v+RacgU7RJMESseczj/syANrf+GHK2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774802590; c=relaxed/simple;
	bh=84gDbC7L/bu+sVbfFzM59BLcSHCoaYv4jdvcr0O6YKs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gDZz3TInMHbvKfIcfKcUV1EL20sbWVqUQ6dAXU8RVxPAZtaPiM5y7NVAw+qiy5oixFxqXKzeGP47Tq4wJvuS52py6CiiixGYFKrvkAtwIh3BD0uqnv7zFUFg+1eftKBiDhJkqszqmmKPmT1WrChOH0bMcMd58FoYZQE7tN2+7Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qdpJPPWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qdpJPPWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89916C116C6;
	Sun, 29 Mar 2026 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774802589;
	bh=84gDbC7L/bu+sVbfFzM59BLcSHCoaYv4jdvcr0O6YKs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qdpJPPWMzlSl8o4WjeY3OuWIidMRaV0gI6ZhqoaKfwZ3jwFjYbdjq2RBeLTuFYWw6
	 0b9vScg12qXt/aWXrkfNQHOp8eSBMDFNfyD2c+uLM9wN+jmB0Ty/0wk9TYR8JTNSAg
	 Gmh6KGXCZa/QVwb2xcmZDmLyH5dWcS+Bs27gRUEdwH0iBQXw8PwQDbe4H/EcHq3tAQ
	 bWzYxFckp6Lo+CqWB+8+OuoRlLYItWPYqmrpk/s+leFKxvio5UG85axhE5T0k9ohVG
	 05GIEcQ7jL5LaVcLAJNoY9LrQ/f7oEz9HIuUCIae/SKHkyC3XF2YAqBn6+A26vjH7d
	 5WRgSXRxgS0Tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0CF393000F;
	Sun, 29 Mar 2026 16:42:55 +0000 (UTC)
Subject: Re: [GIT PULL] Additional hotfixes for 7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260328104905.4f602f792bacc66ff1495ecd@linux-foundation.org>
References: <20260328104905.4f602f792bacc66ff1495ecd@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260328104905.4f602f792bacc66ff1495ecd@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-28-10-45
X-PR-Tracked-Commit-Id: 2697dd8ae721db4f6a53d4f4cbd438212a80f8dc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0bcb517f0a70ae4fc59ce87bd27573043416aa94
Message-Id: <177480257400.408055.217569697494671186.pr-tracker-bot@kernel.org>
Date: Sun, 29 Mar 2026 16:42:54 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 28 Mar 2026 10:49:05 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-28-10-45

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0bcb517f0a70ae4fc59ce87bd27573043416aa94

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
