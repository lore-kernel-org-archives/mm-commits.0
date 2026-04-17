Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098C0363C46;
	Fri, 17 Apr 2026 04:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776399097; cv=none; b=dKLDaeR+Xsf1MBXAF59Aw9EdVSV2ZFyycfOSXvRgcunpMSWtdbM9jrjgz/iicF6/m9RTsaDZv+GRzndAs7ZKSLUvUtcDxYaxumxqhZwTtkQCwcjvMABUDTetsWpEqAYa93Jkj0nbNzmI6rVb0RKugk30AJekXHhzjbZQBWHPafE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776399097; c=relaxed/simple;
	bh=0JN/9l4kgZSdkL6WdcnhCnlJrcJAjpq6Mag7wHEsClI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=H6MYX8bgXR3Y9rm5bwqvQ+QkzD6JdMQ9r/wPAb0Idk4AFsrOr7Su+m44HcqQEoJllDPci0zWH/XlSH9aKzH93rkIAWzRM4N864kTGsfFGl4W5UrZ6tVo+tUx1RftHzbuZSIG9NUVcghGEDXlCmyVPe3Yfm12M4Ifk3v+RqQpFrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BfL5v/l7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BfL5v/l7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA27C2BCB0;
	Fri, 17 Apr 2026 04:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776399096;
	bh=0JN/9l4kgZSdkL6WdcnhCnlJrcJAjpq6Mag7wHEsClI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BfL5v/l7B47k+jVZ1kJWsv22e3uw9v7vPcro0lWW+N+3HcbGEHUjaFOStQ0GUh+yT
	 CI1Q8zzo/DpHS4o/nzXV5zGvrNkHgJFEqMmH7L189aSa00VO+C8R3MPkT4r1Ilqnum
	 LFT5rRYzQiMjymS8rR6EmW4kX0H9MWjU+VlXPIXrX10SXziOR9FgCvKmWRy/s6X12E
	 77wRwTY/B6S48W62WvT0IgxbgjziycqRqQrP/QuPTrwp/cWdCW/p84GPNFAahCB5jt
	 b6+X8wjw7w93rSxL0o6bL07Q2vXPNyCazE9R6r22mxewzyw2+nc/25jXBH30QbNcKL
	 UGoi0p0wj8rPQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3566B380AA7D;
	Fri, 17 Apr 2026 04:11:06 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260416095229.d83bcb0f00859adcd5f90853@linux-foundation.org>
References: <20260416095229.d83bcb0f00859adcd5f90853@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260416095229.d83bcb0f00859adcd5f90853@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-04-15-04-20
X-PR-Tracked-Commit-Id: 70b672833f4025341c11b22c7f83778a5cd611bc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 440d6635b20037bc9ad46b20817d7b61cef0fc1b
Message-Id: <177639906499.3519243.17342913776148686908.pr-tracker-bot@kernel.org>
Date: Fri, 17 Apr 2026 04:11:04 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Apr 2026 09:52:29 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-04-15-04-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/440d6635b20037bc9ad46b20817d7b61cef0fc1b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
