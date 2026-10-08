Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9FA44B68B;
	Thu,  8 Oct 2026 11:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791459431; cv=none; b=slbGFD2GOWVqCaPt5vNk3PrpH9N9ArMeHECHWSYE535fFno9gp52oSLsE2yynG3U5YegqfnZ4XF3ekmVF/IycEgvKV/f6+PCsz9/j5lEBAjQNPy61bj5knrftxLdcn32kCsGyMbJei8+pQWcalwCAwIqEa2SYuyXSynUILNvnEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791459431; c=relaxed/simple;
	bh=RCJ88M8Y8tCO/XbvNWCntwaHcZvsED/bcwmBBIhHk+Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TG0oofe0q7O9X82Nl03UkpWkeS8LtHUwIjTS0w5qZcuFkFWzdiLb/yPdkFNLTO2XDeL0ObOrpusvoII1/8EMVBThg27P8DhlnzV8ctgHrWNBkbunicfEx2AnVqao1gwASVcpbiyRBx0nM2cYyvtVNWSTYTMkJjvU8ef4uLFF66o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhJjO88l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhJjO88l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B9A1F000FF;
	Thu,  8 Oct 2026 11:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791459430;
	bh=vK96+N8Ow9ams/JAiHfjfV2uXZUYzla6HGl9CXeaKaQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=JhJjO88lIml/f3TVY4LCcW3l3XTZV+FNDfe1hH59ka+hC7yDIwuGFE73Uks269UOZ
	 aiep0cRHS2C/U244JTI5b6ZgHj6weeY7TNnazm5+Gmw1S35WWWIODzpjmDCDt4MB4E
	 FWkVwNC4GDC7Ai8GyjKAC+eaCwUdoy+GyxXi5ZcVOOsx/G/9K64MyzhFzo7dHerBFg
	 0tP8MxzJVnYNwHymoLefwFmjlduIXkVON7dVbUXkFLYtttQQD2HRdvcBgcXkJKomT2
	 zfOpc2JaHgmPA9H/6hHKZm9KY2AnNFSVjAgInBv0GhS1Ib+TTG3uGNI075NKhOl/ev
	 KS2U8adahlpgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A4DC380AA4F;
	Thu,  8 Oct 2026 11:37:10 +0000 (UTC)
Subject: Re: [GIT PULL]  MM hotfixes for 7.3-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261007215240.377006c9206afa07f769e92f@linux-foundation.org>
References: <20261007215240.377006c9206afa07f769e92f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261007215240.377006c9206afa07f769e92f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-10-07-21-48
X-PR-Tracked-Commit-Id: 80ce29104123be4d61b5912dae543c70af0fcb75
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b732c98215831db36eff1cbbcd0df2f98b765f4e
Message-Id: <179145942878.227328.1450292004861249270.pr-tracker-bot@kernel.org>
Date: Thu, 08 Oct 2026 11:37:08 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 7 Oct 2026 21:52:40 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-10-07-21-48

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b732c98215831db36eff1cbbcd0df2f98b765f4e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
