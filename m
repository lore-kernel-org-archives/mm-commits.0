Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D91265637;
	Thu,  3 Apr 2025 19:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743708803; cv=none; b=L93JiAEPUMNcHQ1P8akhxKyL1t+x/r4m9Tuy1b1kszTaIl0VTZk6QRxbsLu0yDtCv3z3UKkmhRZirA5BwRnCrvqwVhNxEhH0tsuv/TWH5x8KEtB0WHpoE2fCDSi/cX2VNE86dwAsCvemgYVgI4mRj8S1nqjHZf/vBmvzR80r8/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743708803; c=relaxed/simple;
	bh=F9AxcnQeNXvdVUQUfdWsWvxSC4RuTk7OVd53HWFYJ2I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jnmg+REtdgz9ygqwD+CmfjuAqmfMjHiyFdj6MFMZEq0Ul610tN0uNnLfk7KKtz7rMZXKkfr9qJDxJX+kDrcOuCgEmQdKzOccnEKzkZOTruAgIOsxLIk04R8jNU4gZ/+z6TMbmFEdD/fYmeGQgU0uUmNaQ3PVkoAeNMqSPhxCfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8h916hw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8h916hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71761C4CEE8;
	Thu,  3 Apr 2025 19:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743708803;
	bh=F9AxcnQeNXvdVUQUfdWsWvxSC4RuTk7OVd53HWFYJ2I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=I8h916hwlPOq8hIY8o4MiZLhinfwAf9W90A0bL377HB6Jq0T15ZjHy3rwCyWwnNOr
	 dkstM0ZQbxJnMo7rscEiAn3LERAXhiAEl5i1oDPUoj1ekxpXDefiYqOSQ0U2UxDJnO
	 kP5AWt9nqMYSo4cb5FDEGgmz3xzv/uSOnM6s1hf4ghpnnYOBc/1byoiL/9Exv5X5Qc
	 pXMUZwcfNHwiVmSg+aSw72vgfQ9N8ietNH9rggwER8goz/KQ3puSqUFy0RjLmtixvU
	 qx4p+5sBQF9tkUEPx8CJcbTt8O1Z2O86ATTmA+SEm/aFaN9U/XhwNnc3KoQAwOT+4o
	 WnJRZfuAl+IHQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADC65380664C;
	Thu,  3 Apr 2025 19:34:01 +0000 (UTC)
Subject: Re: [GIT PULL] Additional MM updates for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250402221540.435857db0b10cfeb489ae299@linux-foundation.org>
References: <20250402221540.435857db0b10cfeb489ae299@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250402221540.435857db0b10cfeb489ae299@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-04-02-22-07
X-PR-Tracked-Commit-Id: e20706d5385b10a6f6a2fe5ad6b1333dad2d1416
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8c7c1b5506e593ce00c42214b4fcafd640ceeb42
Message-Id: <174370884031.2657822.6757639254388479414.pr-tracker-bot@kernel.org>
Date: Thu, 03 Apr 2025 19:34:00 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 2 Apr 2025 22:15:40 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-04-02-22-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8c7c1b5506e593ce00c42214b4fcafd640ceeb42

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
