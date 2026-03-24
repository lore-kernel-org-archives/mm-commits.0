Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005443CEBA4;
	Tue, 24 Mar 2026 16:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774369097; cv=none; b=kRaLeMCG/HFTCfYeunK98XLkE50hoFmqGCpBkL5VLrZ0lO9i1VcWzdbrTElzV2qfjFUbeOqTEh1AUgw2iTTpupKLWGoYJAhLTFl+Ke0HH+oZI8KMStkhoqkveVXIX2seGVjnyB43p+rrHxQ2BjYFVV2ZXbrjT937RLV4JUX2VjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774369097; c=relaxed/simple;
	bh=/cUPzzLJI+cz39jGVtpY25JX5CIzYEoDyFD0cG64CVw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mA8jPa32Dgh7eeRmpaesjIo/AeiDvXce6NyJCdk1Tl4SXZjxwYphYaHDLHwiLArH2zZSoBEcNEfUw76GBfkJVl87fvzzEZsWlT86sKHuycw+mKKdQwX0cUamFazsWmbbV6AVRCUBp0nNj6jaeQm1G3/pMjRTChpJGlecdOGO3TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7pe2oN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7pe2oN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70BCC19424;
	Tue, 24 Mar 2026 16:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774369096;
	bh=/cUPzzLJI+cz39jGVtpY25JX5CIzYEoDyFD0cG64CVw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=K7pe2oN5E5M5+gzqcVwNneA6DyFGEImzKSkzdM4asceF1zi5G2PbeTPOmwGPcB68E
	 JXfw5YG7HP0Bb2RR2KnyArRTu4I+TbHGF3ypbJbBoH64tQtsRG7sc72z7R7tvD6rJu
	 shXjuuj3quuKq9lXQBno2tI5mapyA1Kx8X5kt3svrzXdePdd3mffS039wQj9en5tGb
	 rIoG0G9IqVOnt6/4vvpeCB6u/XmXfwre3Q7ysNsP+gxMqZRsb9InD+zmy19wwTLdky
	 NGA9Z+Nql2rVYRc3ALh4ypvT4I06q+P1I+foET2IT0EBBtr11gjNoDB2R4Le9suZxE
	 Qt9EcuZdx7GuA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02FFE3808203;
	Tue, 24 Mar 2026 16:18:06 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260323180007.d3f7db6a8b5dc59e72cb5f62@linux-foundation.org>
References: <20260323180007.d3f7db6a8b5dc59e72cb5f62@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260323180007.d3f7db6a8b5dc59e72cb5f62@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-23-17-56
X-PR-Tracked-Commit-Id: 84481e705ab07ed46e56587fe846af194acacafe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e3c33bc767b5512dbfec643a02abf58ce608f3b2
Message-Id: <177436908461.1187739.15267081620122808415.pr-tracker-bot@kernel.org>
Date: Tue, 24 Mar 2026 16:18:04 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 23 Mar 2026 18:00:07 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-23-17-56

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e3c33bc767b5512dbfec643a02abf58ce608f3b2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
