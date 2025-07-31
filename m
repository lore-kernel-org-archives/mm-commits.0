Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7DE263F5F;
	Thu, 31 Jul 2025 23:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754005610; cv=none; b=XQ41zr5U6X1Ssp6kBAE2HPTQX1Aye8av/thZMhEVVRIvWrEAh96I/JIFCIoDunDE50GgKvQopoh1JxKQMxRM2gKihxRLcBdHMRGgPE33lSDeJ4ZT6qGhXo3MfCksej0gkxda5y/82up0DiAbBz/Hn5u8cxSRXcZ7Bei+yFQ7wt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754005610; c=relaxed/simple;
	bh=/8AimOShOs5/QptszMVNP7lJiKeFsOBtVZXlzHQ9/Wo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=i3b7FElSb0NquB2/3hIHO7pk7QBB7T9fGIHizjCyhzl2mUBwdmsklSyiwscBLkUD25U5XnBH1J4v10ZE4QWDEES+VoFrFGUPqxR5uxN3koUYs6bvcYddIT09RPIpE8JzW5E0ZnLFeHvS3vh1fU0rsyTbF8glWRUQmXn8rnhYcAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgGhgrEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgGhgrEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8FFC4CEEF;
	Thu, 31 Jul 2025 23:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754005610;
	bh=/8AimOShOs5/QptszMVNP7lJiKeFsOBtVZXlzHQ9/Wo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OgGhgrEF+3FnRkKZf7+0/72jB6bltFGUkwPZVTmRsslG/stkis2vjybypcqcoGOsG
	 3e4saSKRZdMRJVaGxAnrng0ZrL60bTQNexVDsolDmVVJKRgrBbcvUMYPUngBz6YCqR
	 AMkCXBqtMH+39BBZh7r4dxlSvh+m9LUURuHqJ5GjelqeygFifYGiCYA3+UfFq5pYhN
	 h0CuhhYsKjS77EhUj0qnhBQBZtF60eL+xwPOphR3B2fLztXchn7O/ECIZ5jGTjX1Y9
	 /I4euSrBW5cTBabarH0t3N9mDnBFubA2XYnzZHwYCVlAK/Swo3Ll934h6bpnAPfwrs
	 sBSD1JuN4GsOA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33E01383BF51;
	Thu, 31 Jul 2025 23:47:07 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250730152806.16f5c618e3af0d3b8dea3159@linux-foundation.org>
References: <20250730152806.16f5c618e3af0d3b8dea3159@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250730152806.16f5c618e3af0d3b8dea3159@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-07-30-15-25
X-PR-Tracked-Commit-Id: af915c3c13b64d196d1c305016092f5da20942c4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: beace86e61e465dba204a268ab3f3377153a4973
Message-Id: <175400562579.3358753.8024804640119746893.pr-tracker-bot@kernel.org>
Date: Thu, 31 Jul 2025 23:47:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 30 Jul 2025 15:28:06 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-07-30-15-25

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/beace86e61e465dba204a268ab3f3377153a4973

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
