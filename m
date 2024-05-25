Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B765F1EEE6;
	Sat, 25 May 2024 22:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716675903; cv=none; b=JQQfkdvBPe0qi9iJpvhaNAdh/uTVQ/LuBuSxWWJtNgi9kHva52QaFCPt6GUZKpPQLsPq12oai4Yc2nvbJgKHv3cq78keioqTN2Z8xKp0nv7DUMsqnuh/fQKvM12r9Wane4JWW93GOCGZ+9z9sBad8HoEntOIh+MYXyUJ5pmgr3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716675903; c=relaxed/simple;
	bh=Y/YEWc0Rs/dPn7JSpaZTDowgmntq7BZqN3eMdqbSqqs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PAUd4/pPMYkvsvfpdLjR/O2dTKPVa7WSFoLnqfkUPskIwGFjcOepzw0HWpHOGQvlQZJwVRPcXPpAu+WXdW4bJmX6iIYNRrK4xYzSSA6Cr6VqhulcIYfdYorxIg33hEJtj0qNbW5CoccrgTM/tczHUMU+4lUy2z1cHK2M+BRvwpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgQZKycS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgQZKycS"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9777BC3277B;
	Sat, 25 May 2024 22:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716675903;
	bh=Y/YEWc0Rs/dPn7JSpaZTDowgmntq7BZqN3eMdqbSqqs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JgQZKycSJKIbjHcVLid2XDiG89ChiFQO2Ps7YC7ihowlvUVFQ5nVBLs4nZOiWcH+X
	 Ecnnvg59iy54b+ZLuRhZJy+uEWauO+r6xAl2jCleg95duwchejEjzYieeOe7GeXPxh
	 5siJW8nrJs7DZT5a7RIpqjoEuAfjCI2jw4O11gJvCOJcLAlv3PUFsmHOZnSeL9q39X
	 Zea+IpQPJvW8kGP1fCfqDOECPP9hYAYC5PGskK/8Saa2moQHydCyZv2WvnLIC0Bx0P
	 svPxDo6xnnPu5RRdIHpl8m9KYdnjDZVT1nYzVQyJ0lvORdRKr9JM3k+tEDMM5jc7q7
	 zPGkULgXs3ddw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E6DBD38A65;
	Sat, 25 May 2024 22:25:03 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240525091557.9ca6e57ab6d41bf204c12531@linux-foundation.org>
References: <20240525091557.9ca6e57ab6d41bf204c12531@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240525091557.9ca6e57ab6d41bf204c12531@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-05-25-09-13
X-PR-Tracked-Commit-Id: 90e823498881fb8a91d83e9a8eed87c8c3ff2176
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9b62e02e63363f5678d5598ee7372064301587f7
Message-Id: <171667590357.21543.16604668613026866529.pr-tracker-bot@kernel.org>
Date: Sat, 25 May 2024 22:25:03 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 25 May 2024 09:15:57 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-05-25-09-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9b62e02e63363f5678d5598ee7372064301587f7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
