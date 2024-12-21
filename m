Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12551DC054;
	Sat, 21 Dec 2024 23:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734824919; cv=none; b=JctYJjz9ax5Eo2sIZte4c2XXq0gIKv074XD6gMqeeue697PpU0J33Wt/DXQIIHXBQUTRCefG897csJuCewq2z7eFXHwGWHo2Mf/17kf2xM3BhiavWxmkhZbIKZXedM59Ub/ANhOpeh0efKxzw5iRlZiWlorvkglw4F0LvXBzQEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734824919; c=relaxed/simple;
	bh=y5ZHCkt95fx+Vz5XL3xW9lt9unrq4QvgvPUwdK1hdoQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jAd4cBfkChQ91gycHhKFOu1scaC1wKv/ggVNf07oaa1jMHP+GXPxX7K+e7zQqutFM25Q94XvG5o3Ufms77tDij91Ujc4/nfLs5un1YfWq+0jxvm5Mvh2Nw59psjPhiKk0RXLy5Bs2RCeQ4LZXqBmnnhK6xpu4WySu9izUI6lGu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QS4HnaD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QS4HnaD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93731C4CECE;
	Sat, 21 Dec 2024 23:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734824919;
	bh=y5ZHCkt95fx+Vz5XL3xW9lt9unrq4QvgvPUwdK1hdoQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QS4HnaD8IXCsJgUQbr36+SBPSojkVq+fOqMBkW5zun0op5WAgV5ESqx+0nsJkzHxu
	 IahJupcmLCz6pkl2Po+B30Cy14JWhqwbXRS8eVdhpreCHFeol6zKltA9hf36s7cogb
	 H+vXymMtuXdziMKf14X4H/2WqVe7VPhP0DDHZnD2hlh/yOvBO2NVwkyV+UXfH7juF2
	 D0W1Ztbz0vl4OGSREVo/xr2uNGN8jyTlX043JghLILVX8VXN07G1pmgoCFdrtgNn0f
	 B2mCTyCZB+w1Ei/+SpJQAnEr5v6kB4gMDS5E8me5NghYTnrwxgNbWzInfvcsdmULAg
	 PUtzEiS0jMaBA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF993806656;
	Sat, 21 Dec 2024 23:48:58 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.13-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241221121129.db5f29eeddf08a80f5585bb7@linux-foundation.org>
References: <20241221121129.db5f29eeddf08a80f5585bb7@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20241221121129.db5f29eeddf08a80f5585bb7@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-12-21-12-09
X-PR-Tracked-Commit-Id: d3ac65d274b3a93cf9cf9559fd1473ab65e00e10
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4aa748dd1abf337426b4c941ae1b606ed0e2a5aa
Message-Id: <173482493744.3244160.2059440546581518780.pr-tracker-bot@kernel.org>
Date: Sat, 21 Dec 2024 23:48:57 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 21 Dec 2024 12:11:29 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-12-21-12-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4aa748dd1abf337426b4c941ae1b606ed0e2a5aa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
