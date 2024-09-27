Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483D913A3F2;
	Fri, 27 Sep 2024 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727458933; cv=none; b=SvHOJAlQ+L7SJvzLO6qAj1Ip/oMrzplZ0hUL7bK0R/SnP+S0EMVrSK/5RPuJYv+ZtsiMAGXwuC1kO+AqUWlZrzn4rd/qyVwD7omfOSMQ/4Ue60dDB5DIiCckozJatU0ab/+scGQjUclKHhEMSamLAVNk5Nfq/JGyuT7kr7Dy5Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727458933; c=relaxed/simple;
	bh=N25LYuDasbpviinGsZKWQsr1klixu2LjoWBIk+VBF6Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ftGZYUR4Guv8ScI7XtZ/tKGRlQj390WiaQt8ZnyPl6lYPtsFKqYTQIOnAdye1Tp0DO235NcWS6/7iHT6mWaY26A1qeJsvEbHMhFrLjurFxvhHAwlxhvnZt0dtpYRz+n8OZ9jwvuGWhsCsmcDO0Qe2o47+Bt63/Y+tCLEWP6jf58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFe0AJ/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFe0AJ/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C97C4CEC4;
	Fri, 27 Sep 2024 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727458932;
	bh=N25LYuDasbpviinGsZKWQsr1klixu2LjoWBIk+VBF6Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=iFe0AJ/zRxkH38yWpxgUBVmAQXjMWRv92XG2MePY8oRX57cyOlqMPPozL/JjGNRLi
	 LfDvgsu4P7yqqLRmb7NEHU768OQgjQcyttoJf957gnwhWIYWKAWi+fgEEiQi6vIMII
	 XDm0quwUVQZQGC7c9uHvAiIowQJiBsVJ0eoA4iga/HRhQeVAdgIatjZCYAvJKuJhBS
	 NIuM9/HN5PYmMPofXVClRLYZapF8GnINM9K/gHxSRcrKadpkay2MHAtOwyi+CNwpCk
	 uXiEYMQr3R4/qpp3i5MvFZ/zzBith7VlW/W55hk9aPaxyR7QQGJmLjCSrm5GoRGpeb
	 zz9LE/fLwElag==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF1A3809A80;
	Fri, 27 Sep 2024 17:42:16 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240927094740.1a82b77b071feb9027621bed@linux-foundation.org>
References: <20240927094740.1a82b77b071feb9027621bed@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20240927094740.1a82b77b071feb9027621bed@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-27-09-45
X-PR-Tracked-Commit-Id: 2af148ef8549a12f8025286b8825c2833ee6bcb8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eee280841e1c8188fe9af5536c193d07d184e874
Message-Id: <172745893535.2035470.12948823925062904720.pr-tracker-bot@kernel.org>
Date: Fri, 27 Sep 2024 17:42:15 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 27 Sep 2024 09:47:40 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-27-09-45

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eee280841e1c8188fe9af5536c193d07d184e874

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
