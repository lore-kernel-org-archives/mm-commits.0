Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95B527A108;
	Thu, 18 Sep 2025 05:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758171606; cv=none; b=gfWTt71CcZXxWXjycGiYCQyUFCC1NCqPkZqxjI8+pMU7bfSCKLSW3ip/5eDwowAacKyTylEfpsE4xJW9VNNNDu/HIHAlGfMqgyAGfJlFjxcynPGHCYnVAIpbC07FjTAraLylHzYCPgffBsNTqEOFAA8UcC7/cErzohgf5CieeXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758171606; c=relaxed/simple;
	bh=Pwe38i2essNnYnJ3UQqLil3L0njh2nUJNrRrwwF8g0Y=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UXPOIXrYDUfuEvT+y5tIg3kPu4zpUswNxkvLAPmMNP2DRcb3ClhdYjwOciy1cpODistXBVvbCPLHIv64wMi2e/ZwGhadNvh7jsF0YW2avpnUTqLAIsPNoBQm7DbB5H0C3ZitZze/JG9uFwYekksUMFoWKT8MYUWjDGJyBotid9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igbs4A95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igbs4A95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8E2C4CEE7;
	Thu, 18 Sep 2025 05:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758171606;
	bh=Pwe38i2essNnYnJ3UQqLil3L0njh2nUJNrRrwwF8g0Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=igbs4A95i0SZAd2ZiO6v7aDzwzLJEuv4U5QGReD9svMMlfahs0WqpgCiuc+6mbZhc
	 SThjrocxu5ORjR4k9wouv04DYLhyMhmQEpoKXDM76+dNVxlb1ZUVuKk7ere+lQ1r0e
	 hIkKRYPIT6rjc/Tk3ky6+Lpl1XN92vkNv98cPqE0eRMnTnvnlA9A6UOjuiApKjnTAj
	 4hFWAbj72PVv73A7MEH5e96AjenbsNx7PilrIp9kMa/aHmCmSUlcMa2o0e/MU5skzn
	 spZ7RPpgTDAKRHgabAOYcMzTSCV/zfLB7T8ge2FIu6fagbaEd62CYqcNnrCRCAa8Bf
	 DIfmsorlQFpLg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3533139D0C3D;
	Thu, 18 Sep 2025 05:00:08 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250917211310.da8771af4cb50be2e657fe6a@linux-foundation.org>
References: <20250917211310.da8771af4cb50be2e657fe6a@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250917211310.da8771af4cb50be2e657fe6a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-17-21-10
X-PR-Tracked-Commit-Id: ce4be9e4307c5a60701ff6e0cafa74caffdc54ce
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b789f2b7602a818e7c7488c74414fae21392b63
Message-Id: <175817160718.2263649.1243233939386153850.pr-tracker-bot@kernel.org>
Date: Thu, 18 Sep 2025 05:00:07 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 17 Sep 2025 21:13:10 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-17-21-10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b789f2b7602a818e7c7488c74414fae21392b63

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
