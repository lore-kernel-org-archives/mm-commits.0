Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B03191F8A;
	Wed, 30 Oct 2024 02:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730256261; cv=none; b=mSzzz12U/wF1tr1yNJiqnh71KivOoMWQIo85aQMft59mCT/J7iwibHZQKEXWgHrzUaTxFTIbwRjth20mQcGDw/u9RiB4Y1Ky4gyABH7/acOxo7azP4sVYZPp4IjOdtYrtHUbKbv4JUCOH72Nd4GKyKgTZ3+QXDsdmMq74ZzghSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730256261; c=relaxed/simple;
	bh=0ghpe4D3b5OMK48zde4csZNO1vsmy0T9ep+8bPI8Xs4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KxHYVf3qJ1R1pjse2KvDCcAg9sXcjYqda3G55DqtM58nOTkQp2e4z5sA4l3AvyBia8IiN7Yz5voj2/GeSyRxKCtgADXUjFWeaDpJJ6Ru417mvfwSe6EbnNolvq9xea1sO0OfscKqzSx9t1LMrrxi/slXpoWH/SBULIdIjqfRYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VW77qyAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VW77qyAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D82C4CECD;
	Wed, 30 Oct 2024 02:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730256261;
	bh=0ghpe4D3b5OMK48zde4csZNO1vsmy0T9ep+8bPI8Xs4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VW77qyAZzE73UvvGzcNZS3fomWVtYlAQmfyyZcPw8MUiP+LEhQ2MSGQkSmA9m3jsL
	 OCWNqHCeGiiC9jpg4xzoWrrMsZSP+k1boC/e+fXOQ2dvRpkLay88HUOmnzWZk5ImA9
	 K1VCIHGyM7x4iBS6JTGWqexL11ohA+N/SIiRlatSlLBtrok9F4PC4bg2ohZHWXACyv
	 ZWjxUR43JjHXNOipqkwf8HZojuEWy1EYmmk/1Q75dyge7JFi0KynA67XG9AA9APouN
	 MklefliOqPj5nemqUAc0jlqq8qSgbbo66z4hGSe6ycinntVYxI1fQzOupWCUeAK1W2
	 ZwHtgJsROg96A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71134380AC00;
	Wed, 30 Oct 2024 02:44:30 +0000 (UTC)
Subject: Re: [GIT PULL V2] hotfixes for 6.12-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241028223738.bb14a8723e947d40f3711007@linux-foundation.org>
References: <20241028223738.bb14a8723e947d40f3711007@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241028223738.bb14a8723e947d40f3711007@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-28-21-50
X-PR-Tracked-Commit-Id: 01626a18230246efdcea322aa8f067e60ffe5ccd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9251e3e93cf2892641539c184294838adedae415
Message-Id: <173025626914.893735.8352324667615241008.pr-tracker-bot@kernel.org>
Date: Wed, 30 Oct 2024 02:44:29 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 28 Oct 2024 22:37:38 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-28-21-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9251e3e93cf2892641539c184294838adedae415

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
