Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C7E3E8C44;
	Tue, 10 Mar 2026 20:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773173226; cv=none; b=GBR6HVcuG4pHNS1YPuCjQRzfzJKlCaVG9QxpS4OGHMxc33zhkrSxzIuPDxCPvewLzqz1jIcZjrejWAEHo9tj/gCXxD8I/xV0XW5g8nVR8OgkdLwGad3VTMKCUaMoLhx4r7CTirMyEOqumx8vEgUGjsf9Q1pSfjHysMC/T5QHQxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773173226; c=relaxed/simple;
	bh=gxIHa4pN/d2HT3i1lYIseeRgtgv+dktAfHv5WDkX2jo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mbaXVz9VAsUzXFM+IMLZrl9/RMEejY659vcf/ki/BBVDPZ3zcri3CY9uM+eQFCos1UsUU1bwoGYLTypfenNVIFTddkuP2afDS2u34U6hahpCmOw+Uy/HIYyWan64o9wvynRwTUYwlcdupu+7vbdHnIeFn8OalAv91GhQ49wsiDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIzKNsdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIzKNsdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C31C19425;
	Tue, 10 Mar 2026 20:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773173225;
	bh=gxIHa4pN/d2HT3i1lYIseeRgtgv+dktAfHv5WDkX2jo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eIzKNsdrWNDc8vCGQ7LE/TQ4/RYRD5wV3OhQcbR31AlQUD/cnerfadZQH8yFnWFCj
	 /wmzKyaCLpk+rUI2BRdUr5WfbrVGAGOPn5UPPxKCUfSAcL7h3vdxHXg4qh0s68yr9b
	 7QkNlJDDj+zjAz1qiQi2yF9Su9CQRAsi+8bgE6SDhlCjW2Dl8YS3hxtYSGAtfeNn5T
	 5FECkx4qUeqLiEnuLOG+9J3ArSuPXFO/dMyv+aFBh6EDQqinFGFmcjjbGrpQfwszEG
	 sDMPWe1l4c2sMXy3k/Y/wZNqU0wmL/D5H7frziiFzIkOFT4oTQzWvcfj0U9npCCw8M
	 YVZqAg4Hf6tPw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA2973808200;
	Tue, 10 Mar 2026 20:07:03 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260309163846.f59b3518cba71b9587576e7f@linux-foundation.org>
References: <20260309163846.f59b3518cba71b9587576e7f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260309163846.f59b3518cba71b9587576e7f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-09-16-36
X-PR-Tracked-Commit-Id: b12bbe35c7c1e431f2fa01fe9291daa52fb7ab43
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b4f0dd314b39ea154f62f3bd3115ed0470f9f71e
Message-Id: <177317322237.2899380.1182380861308467097.pr-tracker-bot@kernel.org>
Date: Tue, 10 Mar 2026 20:07:02 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 9 Mar 2026 16:38:46 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-09-16-36

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b4f0dd314b39ea154f62f3bd3115ed0470f9f71e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
