Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52032727E0;
	Wed, 26 Nov 2025 21:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764191624; cv=none; b=t9dGYN1IMamyiG7kZegiJRGAM0XwTPd+aJNldbDFlavIztQ1szx/MNA78HYp5y72SocCdqPH54Qra2vRB2DTetdKZr05j/gfRuUB98dklFHvhXdjvXNsz5DrZFIWDeNOUlY9yEnqDX+T+ibQnamTc+wNrKSikNUDR1eBGHJ07yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764191624; c=relaxed/simple;
	bh=CHaXt7Mj5E5nPYnWOBYVSOk/Kdq19B0is7PCYQwmKUw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QsAZ6gqP4y/eSfmAAPHstsyzX124i/2h6N12T8O1aKW0ury4/O8aeSGLDjpK7FNrwUiN9m6FSaCqp5wkPjwPBvRl2pc7nOYkeJZ2dToNt4sDGHjMNmPyk+TWn7DaXuOSBCJ8tSJ+BoJNKw5nz1x3AHnOfgbezI9yIPZXCnQaSgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPWTd1Wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPWTd1Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5400C4CEF7;
	Wed, 26 Nov 2025 21:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764191623;
	bh=CHaXt7Mj5E5nPYnWOBYVSOk/Kdq19B0is7PCYQwmKUw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=EPWTd1WlcShHd1m8qu545g/pne8wyirk+8gd2+8TsH65io4QyFb35w5qXZ2fYQ1c8
	 Dz8O+uVAc8GFx6a5AeBBPtWSAYiabwojilyMBQi8kQIaXEgPRE4FrPe6BJiNnIUbud
	 dMMM0FvAxlAXcgJmzwZjsjqbcpCxHuY+9rfOi/GD8sJjmyJmmCeSiOiOzPFReMBg6n
	 xHBOUg1ndE15giQtfYxeJ/tlkuhD8fTAJGUJs0tXJTzcqN+RhrSQ9evEzGGdfiFo5/
	 9AByGXU7JYoMxAepuvK4xOfWekcTM/ge6AYr1XGTNRqiUfWntWRsOsDTs/fvJEXdVg
	 EvwVCoVDqOc2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE8B5380CEF4;
	Wed, 26 Nov 2025 21:13:06 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 6.18-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251126115356.e5fb496a181886475567ed74@linux-foundation.org>
References: <20251126115356.e5fb496a181886475567ed74@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251126115356.e5fb496a181886475567ed74@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-26-11-51
X-PR-Tracked-Commit-Id: 7c9580f44f90f7a4c11fc7831efe323ebe446091
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9eb220edddb20a019d1630347555bc4ae1514e61
Message-Id: <176419158535.1847725.8946913720051022935.pr-tracker-bot@kernel.org>
Date: Wed, 26 Nov 2025 21:13:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 26 Nov 2025 11:53:56 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-26-11-51

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9eb220edddb20a019d1630347555bc4ae1514e61

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
