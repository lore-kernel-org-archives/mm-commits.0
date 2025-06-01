Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7EF2DCBE1;
	Sun,  1 Jun 2025 02:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748746015; cv=none; b=oAPFJ2lXoZmj7EFN9OlNaBui09l1yp92SgVerXApeHYfmKpwU0NUFl9qERvVk89IVIse1TdHPkMmBxIpgYBMst0Hdf1YK4xuT1iwnewTpuojZoJg+yI+l4ddE5qLT1B0pvJQ+46AbsgEhI+a+X+BG85e2fxFUdMPZMC84xA3o+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748746015; c=relaxed/simple;
	bh=8ahz6LYNQBG0k7IUFJJOjfWE+ZmtI8miLuEt38X8sgY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=iftCcUXHK+oEPiO0CsI/slYiRSR3RPim/DOmcQQQdNcBDbX4YJjvUTT0NPNuyZxbyRArhDLh0SOIMvwMOEk0teZURR606lRw2R1t2A5413HxHwzx1ADUbXELsdiZ1vwo1YIs/MRJdmESSU/PlFrEFM8Xdh1RXNRcb/LJHsB1qwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/audMD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/audMD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3ABC4CEE3;
	Sun,  1 Jun 2025 02:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748746015;
	bh=8ahz6LYNQBG0k7IUFJJOjfWE+ZmtI8miLuEt38X8sgY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=P/audMD4cvf+k68hrY7l1U6LcV1oqts+p3n6LO/LnTmS2fLGsvrPWK2g9cC/tu6Yn
	 cknTcivKZgdIyxmAHZVJ+9LOor7NtkFluKEDHiOfCyENI3p3h2LZk3PIb1PcVWdEb6
	 o9O0gflzmTYANKTmbLtNTdjOvlycGBN2tBTcI205hFk954gJWxMKvMNcPxyBedez+d
	 2kq0Jb/b3r4dU6Bvo2oAOV/uW7VmNmNJhw0R2VVWKA80D6d7eiUiZ1OJ4hBtBrFMph
	 YIThVeODCDlQ1CInuAYYWoosF+6hvltBFm0dt2Au/Qnk8jRuFwKDJhNR0uHsfABUtL
	 zjhBQ/jT1qRFA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70E1A380AAD0;
	Sun,  1 Jun 2025 02:47:29 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250531145342.383090aa5ed5bcefee0740d5@linux-foundation.org>
References: <20250531145342.383090aa5ed5bcefee0740d5@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250531145342.383090aa5ed5bcefee0740d5@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-05-31-14-50
X-PR-Tracked-Commit-Id: c544a952ba61b1a025455098033c17e0573ab085
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 00c010e130e58301db2ea0cec1eadc931e1cb8cf
Message-Id: <174874604794.296823.9742582059292506586.pr-tracker-bot@kernel.org>
Date: Sun, 01 Jun 2025 02:47:27 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 31 May 2025 14:53:42 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-05-31-14-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/00c010e130e58301db2ea0cec1eadc931e1cb8cf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
