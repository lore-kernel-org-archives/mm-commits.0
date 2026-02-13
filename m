Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40DF28726A;
	Fri, 13 Feb 2026 20:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771013886; cv=none; b=Cb6qm284zyNAPiIH5XUPc0joawTtJ+zt8cpePLNOC3fMJ55e0PH60LqwHHe9VfHIyAqlC8BV+Tg2d43XrKH9+Q9J3n4hx5c/tEmPzir7dhyUs+YLoppBiJT6sYdc78g+Da8kxRiOUZ99gG55gwTpcSmE/r0cLoh290Ss9XpDVWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771013886; c=relaxed/simple;
	bh=4GCjESj7JoK5fBFoy3ylJnUVgB7t3oqyOrWWSK4SDwc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NZI7h6BqcJrwiuGdm6q4/EAJA4xhhu9yVQ93jwgX1F3rfraDMqYn0vRffVnA1kXLmumyZ8WQbE2A8Mmiyj7W1COFObHQPFeyLOw48JUmeHj62JgalEFnr3LoltyG5R8tQgkR0LYAQhNY8zSp3CSFC7BNjTLTMw5Qj4EnB488bic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s00Uy19n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s00Uy19n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DB6C116C6;
	Fri, 13 Feb 2026 20:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771013886;
	bh=4GCjESj7JoK5fBFoy3ylJnUVgB7t3oqyOrWWSK4SDwc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=s00Uy19nbU6KE4eIoJ+ZDKH9jzOQoKWQM2XB5Y+ogVytTDpB7ueJ1P5tF7z1Fck92
	 49bThbDRK2HUIr2kkvNPCLSToKou0j+W59iGdKyHwfYnpDGgUSjxNDc413wZ2Ttie7
	 A4qVWNBXnj473LtkZLANDo+YKp7y7r9M6TUx/tukr9hxdL/sfIAEiVHFdjX8MIip0x
	 XWUohxjjFcnX8bgAaV2lwGE3cXHMImMF4oITjRNe8dfKyWLVF+kbmjgxmK6VjrlvEW
	 xJYG3cV2MSI0XAr+ACSl0m9c5R0KyMMP3HUdbCOnEBr9H8f2cWaMjHInDZxHKUbdvJ
	 UOwQmdCpjMeJg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 481A83811A44;
	Fri, 13 Feb 2026 20:18:01 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260213071717.77ff0bf809865bfb7901453a@linux-foundation.org>
References: <20260213071717.77ff0bf809865bfb7901453a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260213071717.77ff0bf809865bfb7901453a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-13-07-14
X-PR-Tracked-Commit-Id: 61dc9f776705d6db6847c101b98fa4f0e9eb6fa3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 44331bd6a6107a33f8082521b227ffa4ec063a40
Message-Id: <177101387975.2542361.12777525486322994831.pr-tracker-bot@kernel.org>
Date: Fri, 13 Feb 2026 20:17:59 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Feb 2026 07:17:17 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-13-07-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/44331bd6a6107a33f8082521b227ffa4ec063a40

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
