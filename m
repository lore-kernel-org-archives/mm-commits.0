Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC8219AA66;
	Mon, 17 Jun 2024 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718655644; cv=none; b=Ej6fGv8j1I7ufvEfiica6di9EFqIULbFg2X/ZjigAumUaOO+RBz9aNYWa/vl5PkJBCcPXlmZ9SWQrfz3aBon3HoO/onLJNIFgjJCBcQIIiJtLnAYViF8810JbqP+eIwOaMH+O3eLdtTDuduIx0qo3IjrW7Zdoka7Ec8VNmdfps0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718655644; c=relaxed/simple;
	bh=XRfwQQ42SAGnZUjgqc8i/9rJPtME17Rs3iBLm47zuJU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DPkwTW1FM1jb2rAzkfXN2Jw6quAPysu+VS8xqDgZxEJ75+jFqj2jvDFaOFedR9tOxC8NeIGXF0cCDyAOVCfG9sTulhIb2ar8i0MTKZCrbJwU6VzU9+Dfq2UgsM2gv3JYQW1L/GPWbhprBAHWgXWKYIZr+woBbI/v3BvQTtCU2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0JN1pJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0JN1pJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEFF7C4AF1C;
	Mon, 17 Jun 2024 20:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718655643;
	bh=XRfwQQ42SAGnZUjgqc8i/9rJPtME17Rs3iBLm47zuJU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=q0JN1pJZRbPoTX0oRK+gqDiKmDH6p2SeYZCmL10gWEDLpfeeFhCGKExIlkKWbFhKB
	 rn2hOorCxw6b6XYpeUDK03NqgaPQO+PCoLyFBj+pe5jxHplseCwg9OtVqOPLN5oItO
	 d4DYnMHk6efgwZFwFjPPghLgg3a13HqyxIixqlPPAj7pXswYBdcP7gR18Flh4vlTIp
	 ggSfUxHvxCZRsvWkW94UqKRWQkUoSxJ8MRBJbQzEOBX0s/MPpoeHtOfjbvXx4OIhE6
	 ft6KQE2naSs9OW3VlhILKofqOLtKnckIgJgOGz6GCg3tVpGzmCY+MdC7weIDkVMH0y
	 BQ7p2VVES6/lQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC5ABC4332E;
	Mon, 17 Jun 2024 20:20:43 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.10-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240617114712.45d4743f8bacb832dea4b5a9@linux-foundation.org>
References: <20240617114712.45d4743f8bacb832dea4b5a9@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240617114712.45d4743f8bacb832dea4b5a9@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-17-11-43
X-PR-Tracked-Commit-Id: 01c8f9806bde438ca1c8cbbc439f0a14a6694f6c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e6b324fbf2de1797a4756fe2a489442464738dad
Message-Id: <171865564376.9005.9789134174772755356.pr-tracker-bot@kernel.org>
Date: Mon, 17 Jun 2024 20:20:43 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 17 Jun 2024 11:47:12 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-17-11-43

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e6b324fbf2de1797a4756fe2a489442464738dad

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
