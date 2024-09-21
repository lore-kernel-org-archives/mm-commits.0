Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FA175D50;
	Sat, 21 Sep 2024 15:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726933751; cv=none; b=ipAF61PsIYag/B5GbkK0kNW3/6yhJM5JH46+JC8pMfv9kLXBL/DiEMnfN7RzcqcsC7Vfiv4naHe3MWtoX22dYaxW5e7kUajsow7Xmc5nXAwOZKg7pfkHBCecb+S+PUn5JE8hXcltXTYiGPsqJvpfjac5vxc3ZHhrvm9BztfV438=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726933751; c=relaxed/simple;
	bh=aYd3BssiNvwMM8+5Df6ozDiLoFGBKzmSMvm97EM/brw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SkQU6vM3PwvhPOvUMc3dWVEYcvR3/2iX8Bn5+jQwZhXI8cw7N/VDycuKAMHHtu7Zyf9h2D4x8hqBaGQK3u0XuuTtbY9sIbhTUTEpXNaQlouR+TsIMle75ZWK85bjmUxjVil8lTWWV64vM5wLOlYVHhBlax5ZBoBtvMX04UiyRbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooUy2Spy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooUy2Spy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5457EC4CEC2;
	Sat, 21 Sep 2024 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726933751;
	bh=aYd3BssiNvwMM8+5Df6ozDiLoFGBKzmSMvm97EM/brw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ooUy2SpycRNtc2urbuu12X923Bki8iRniV7ca3XWBqQQzLZOw09pd7iRoQ1lo4YK/
	 8k4x8fywGRiOeXSYblSVkNZyRJQhpKUB0OJLL51cdMeQXwFqJz3QTtVbszVumJ0KJE
	 U/zJS5azbbc619DZyTOJcSOMEIbzBQzwWP1D295YpoaR8n45g8kGgTlShoxyAkQnZ8
	 hHSERaED2ilyBU9+yLupUtYc+8KFqxC0DmjEvNQr6h5iLI1f2ojKxAtfrn6HBETqtZ
	 5Hsx1wDvPY6XN0LD4aUODRY8fNcmPn2NnWimvQJDwfHy76EawJQR4jdKuzp+xE8ao6
	 f4kE03qDpukSA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE7233806655;
	Sat, 21 Sep 2024 15:49:14 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240921075655.ecdd22bad5e21c783aa14f2f@linux-foundation.org>
References: <20240921075655.ecdd22bad5e21c783aa14f2f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240921075655.ecdd22bad5e21c783aa14f2f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-09-21-07-52
X-PR-Tracked-Commit-Id: 5e06e08939df1cafef97a8e04f4b88c2806b538a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7856a565416e0cf091f825b0e25c7a1b7abb650e
Message-Id: <172693375330.2514991.13899698393133462935.pr-tracker-bot@kernel.org>
Date: Sat, 21 Sep 2024 15:49:13 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 21 Sep 2024 07:56:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-09-21-07-52

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7856a565416e0cf091f825b0e25c7a1b7abb650e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
