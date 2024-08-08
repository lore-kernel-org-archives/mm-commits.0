Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B384B155C9E;
	Thu,  8 Aug 2024 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145370; cv=none; b=gCkORIl7Wyu0MJyI4AvNd+WIaHC70j2rWCbwZvSRg5PbKi6NTOGI7e1zHj+TLnu5vrmI+V/XmxfTtyMYalUbzLD6ZVih2CfLWEEHLFaZZffQaKrhbw1wYrtzhmpYMdeElLLSn2w5htQdG57W6//hG5LxD9hcJS4ODGnQ3IGMKeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145370; c=relaxed/simple;
	bh=o8CcjJtOD52WQargWvqw6MOCw0Ev44dvpmrUzwTvjP4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DCoQ3JJ+hqiYzdDHanUPcUKFhREFXg0bD3J3KmYnu9J07f+DM3I8AGkGEBYFAxzJITIjE7fxJERG3szbHKwNX7AmLLt/M57Tl6sQeyMiHDUlMJMjfd1ScYobmPCJcntC0n8bads3yM/i9NGvPoT4eNaBWkhcoUP6KVQqDM4u4lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PT1Fk1Do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PT1Fk1Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55847C32782;
	Thu,  8 Aug 2024 19:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723145370;
	bh=o8CcjJtOD52WQargWvqw6MOCw0Ev44dvpmrUzwTvjP4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PT1Fk1DoDlYFgQLPCrjwsNka59C0+LpYI3Vt8eZc9SFL2U5G4C2JfglBYpXK161y+
	 ZbqP8Ud91AZ9QgoI6f3ClgiiFMzHZlj1uJySsLD2v+Y5Z+1nqWbL+rbctqYoz+7pn4
	 2z+CFrngqmcxeT8/cJ1x+vc05NNh6xB4MZCWdJbM63pL1G4AV4rHxUq5TNsIxl/6YD
	 NsnTcvWrNylNV8RC809FLHhRj770OqjA1I8RZuRDipt+k9Xtzhv42GE/TzDnZHGVz6
	 p9bvOKUM/CxjfkcEaj/tMWMh358PQLUwfhfQe+hPtbLXbYuaxJUdazmCLBX4OG0j4I
	 2YSJ/3qGm/ifQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 710C23810938;
	Thu,  8 Aug 2024 19:29:30 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.11-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240807202807.2787ceac0ca8a603be90d3c5@linux-foundation.org>
References: <20240807202807.2787ceac0ca8a603be90d3c5@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240807202807.2787ceac0ca8a603be90d3c5@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-08-07-18-32
X-PR-Tracked-Commit-Id: 6d45e1c948a8b7ed6ceddb14319af69424db730c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 660e4b18a72efe555c9b7ff9a80cfd4777af9609
Message-Id: <172314536897.3277467.14108263086094575482.pr-tracker-bot@kernel.org>
Date: Thu, 08 Aug 2024 19:29:28 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 7 Aug 2024 20:28:07 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-08-07-18-32

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/660e4b18a72efe555c9b7ff9a80cfd4777af9609

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
