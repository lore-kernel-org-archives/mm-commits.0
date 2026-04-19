Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA1F15B0EC;
	Sun, 19 Apr 2026 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776613364; cv=none; b=u+ijdT3DRwfy3cMUJIrtvDHLBBtKRVGGNbGTPr9o3Ooc1FvFI2wTp7xKpxk1wM2lXMmsKUDjJ0j3glDncxGmb6K/vDXNFVTH7u3lkgADxjU5JSBF6bd2Zfzzbisn5vGCSaNgKP40gFUDikE+YkzAW/HKlsFij2HSZu7J2cAUL6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776613364; c=relaxed/simple;
	bh=xvRKjYBnCdzdh4bvLjdYo241YniLSW/CTCHzePGo0Y0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Kfftya3pi4xUPv7/10sfOqthDSFMG1PEq/uqexFUHpzEG066xdhrD1HkuELvj53zXqLS+yo1hmthRwZ02llmA9HW9KN4ggdOoxSIVnY0Tsp4R3tHjCGM2UfxnKS8t5pldMZpIv8RfpfZRE3OozCuwXzV52+hTWMNpWSzLmGlEl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qUkZf8h4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qUkZf8h4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244DDC2BCAF;
	Sun, 19 Apr 2026 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776613364;
	bh=xvRKjYBnCdzdh4bvLjdYo241YniLSW/CTCHzePGo0Y0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qUkZf8h4LJ3DLxhk1q+D4zi2lfcNGRyBbujxLHAm3ggNKXV/lAK9hfYHDnc4eC9Ek
	 18E9yE7XwpBISHSuLadheCUJp/MVz2l2a3sVtdXFDwIvMEP3AFWWI6aWs81Vrs2GC2
	 d5LB3U3VOszgSJh8LRz3VtO1mX4XrWsxuOYS82QLT94Lnyu65Vr0e/KWk1vcG4F2m9
	 LXhnY/KELmxCsXaEWZXLXAf/wmKPSblYPGYQaWAHhL3yCdourGDxg81dsWK65UeJW7
	 hxesVjrmh/N6bi0y3keNpLC0UVQJS+rx0zvXS/sqJf175s/WguRNSqdi6/PWMVFU9T
	 ifxZm4WkfKcxA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02EB5380CEF9;
	Sun, 19 Apr 2026 15:42:11 +0000 (UTC)
Subject: Re: [GIT PULL] Additional MM updates for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org>
References: <20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-18-02-14
X-PR-Tracked-Commit-Id: 0b5e8d7999076ac3c490fc18376a404e2626abff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 40735a683bf844a453d7a0f91e5e3daa0abc659b
Message-Id: <177661332946.800150.16573212022538901755.pr-tracker-bot@kernel.org>
Date: Sun, 19 Apr 2026 15:42:09 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 18 Apr 2026 22:38:23 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-18-02-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/40735a683bf844a453d7a0f91e5e3daa0abc659b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
