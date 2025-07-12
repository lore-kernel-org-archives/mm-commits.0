Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D3670823;
	Sat, 12 Jul 2025 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752344098; cv=none; b=mCM+GB3o1/omwDcEH4jrSrTBybPaQ92OnYfnaP/jSjvppN2oFRcREFjNjuDN8Je9u4DtyqhpdL3m1t2wWaNB1bwDtXvw2Uz4piy+bJaC0nUJDbm7dzjn551lBf0x4m8Pjk4QoOOgGbIfWBi+37tvaMiQ/jRj6IWhZ7mxhKq4caQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752344098; c=relaxed/simple;
	bh=cRUxvzgS3a1jvrZI4ERESoX5hWtiv7MZAr9wf2zD/b8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sd06i5Ebk/auOCZFYK8Afp1uW0xlYxEHtIryqCdZP2BroGn6ucGV39xI4H4Y9d4T7DiOA4xoO7FMvauU0C+mHcCQV7iMNs+Ams2phGFlGZDq2lIEXEtfi7K9hkqqP0PoZAdFjLV3S8nOBr0xNKfuBgnsXp87NtQZqfBiN2EisqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPvAZwHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPvAZwHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63661C4CEEF;
	Sat, 12 Jul 2025 18:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752344098;
	bh=cRUxvzgS3a1jvrZI4ERESoX5hWtiv7MZAr9wf2zD/b8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bPvAZwHk3TPqgzimFlEMmDS9qSUQ4vP563DMuhzeFRU0rRvBHcKcV61PhJxA8pn2m
	 t56axZtTbFD6fB77THCAdeXF4v2XsviMS28DiCRTzu8Y7pdlyy0OHRU1QnPaeiMXF5
	 XWtHxFRQbx/IpQHx7kdHrOm9eF91MXKrNDEmo3NyrE45dF1aIbzs0zXEiJOcqiky0p
	 W4YjPzxZT8dMW3PkayjX4qU/+oFzQlrqMDqdPwuRqUIv8dyp47iM5Q7QrFJ3h4HCph
	 qMs2zqlupjaTCM5zZ4sNs45HBYZKm4RI2CtnLEFhN6Wzgsd/amxJG3JwmZeuLeNYd5
	 lUE4HWk7+FeiA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D77383B276;
	Sat, 12 Jul 2025 18:15:21 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.16-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250711161851.7b0e9d2d962b79f38c2f67d1@linux-foundation.org>
References: <20250711161851.7b0e9d2d962b79f38c2f67d1@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250711161851.7b0e9d2d962b79f38c2f67d1@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-11-16-16
X-PR-Tracked-Commit-Id: db6cc3f4ac2e6cdc898fc9cbc8b32ae1bf56bdad
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3f31a806a62e44f7498e2d17719c03f816553f11
Message-Id: <175234411984.2616006.6978041778138101480.pr-tracker-bot@kernel.org>
Date: Sat, 12 Jul 2025 18:15:19 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 11 Jul 2025 16:18:51 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-11-16-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3f31a806a62e44f7498e2d17719c03f816553f11

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
