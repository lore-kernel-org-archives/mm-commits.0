Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB783A1CD;
	Sat, 27 Jul 2024 20:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722110839; cv=none; b=Msm11jlvJ200MzH//OM4GBBlpw/j9D3NI1ZDGKIv8qtc+zm+b8oUEguPauvExk0Shpw0EQJAu6ryLwgcGsHgl5rJxVGJQCVQY9w5qtqVzHQf0AKEIrT+AiHV6sJzv79gtO5Rb/bG9tRfGu7Q1JX4S09GWh0PTlLCJZ+hYj6eW+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722110839; c=relaxed/simple;
	bh=QHRlFtWM57V1fiBD5tIA+0xDYACcVCQNCyTh+QiwmEg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bUn7b46DookUnt+h301ajXVwT7MvDHKxYjpRJpzPktUoSfD8cu/lMh0wA6oqmwmbiASTLE8CmNBWs7wnzbt5B892EQO5AnAnmf7XiJpE8BlB23+PdG6/vjYCOMi5wE6FK+lEmAfrAyj37pDcsm1ZhmbNgdJs28rfD4jKpYO9VPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+YpZ6PR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+YpZ6PR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 851A6C4AF13;
	Sat, 27 Jul 2024 20:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722110839;
	bh=QHRlFtWM57V1fiBD5tIA+0xDYACcVCQNCyTh+QiwmEg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=i+YpZ6PRI7fgpPsHedDZjfEkbZbUaiKKxZO86PUKSglgptJ7s2N1PlTczH/OKB9vM
	 WVenxFmUMEiAGCe6CxVGgURvWkiKFCK8sEheqwMniFCgoVB0HAbRhkwCI9uHLwT9wR
	 hIL8lZ5vLW5nhJcxOjjJs2rwY7hsb17zu5LY6MXCKdOc/gnxzvQ+cWFObuxl7DDFM1
	 eAKk0KjeQHDTTFZg2bbLxS5xx1qNpshfHzDng+2ftS+9KeKBTpYHP2maRquaEzuMi1
	 B8nHMEuJmoupJNB1KFbKBLPw1KWteGR8SjInbVLwfQQIKSTWM9ZvMX45Yx8+Yu3+7S
	 +K/XwdRivvFQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D100C4333D;
	Sat, 27 Jul 2024 20:07:19 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240726143615.93c57975048105d2883f3d4a@linux-foundation.org>
References: <20240726143615.93c57975048105d2883f3d4a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20240726143615.93c57975048105d2883f3d4a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-07-26-14-33
X-PR-Tracked-Commit-Id: 4811f7af6090e8f5a398fbdd766f903ef6c0d787
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7b0acd911ca05b2555d834cd93ffcfab1ade828c
Message-Id: <172211083950.16614.3264137296122762770.pr-tracker-bot@kernel.org>
Date: Sat, 27 Jul 2024 20:07:19 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 26 Jul 2024 14:36:15 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-07-26-14-33

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7b0acd911ca05b2555d834cd93ffcfab1ade828c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
