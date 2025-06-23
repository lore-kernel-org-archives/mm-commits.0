Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433E92940B;
	Mon, 23 Jun 2025 22:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716585; cv=none; b=pbQGbV1UJcTsXoE9gw5wggUX/LsycLeQRZksAvnQlmTGNbne7IzYWOfyiDBpMFMVwPKJvVyK/zdem1DQBMIWaEfQG2jmAflN+qXrlQwCgoC6pnw0DhIWHiEXyZHO3gkEUzhAEnn/kc8dcR6OsviyaH9X5+aLAIFN1rnIoKkZcHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716585; c=relaxed/simple;
	bh=rUu8xlHqwU/hSh7Cp8o3XVutQ6pIsZ+o4IvVZcJ2wDM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bEH+XN77SDvzMwdQO73SkNBTrtMXrthkKFKw39wWeDS6milVFqUosbv2uJ6CarE+Rk4nd9uJtjwWXI6neK4qiiaZAr6voMZuuRB08V7bXSnXXap6JhkIqAex6o/C1SpBNc2bsDme6UaZzHJh8p6h0EgxUDCEUFNLi7+6+89boQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=taXUf7Nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="taXUf7Nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0B3C4CEEA;
	Mon, 23 Jun 2025 22:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750716585;
	bh=rUu8xlHqwU/hSh7Cp8o3XVutQ6pIsZ+o4IvVZcJ2wDM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=taXUf7NmTcVt3HY6RUiOW2eqZ7ZRO9FGeOtvzRZbBTTRd3ayggVteDbKSGWidWasy
	 tVbURBUN9o79c3KdjbTsD/ySt39mtDlWiaZ51zLBspqA/dFUC51RzewO9dWtVxxxVc
	 s8sDekeP/AcFpf6eeP+lqzgZdhgvO4ATHuX6/hX5exQhzDPprooHaPoGsV2kstD8CW
	 O0w1q/zo2Vpq4OufkpRY5xjJ+kiSn3/ujsD091EQ08nZwOqG/ziN3Q6SmUmWN6GABq
	 8SymYb9NOcgvCwiJDXO8sNYdF64LWRl4dQMn0tQbwfUJ/BQFM5StTGproDnfemRk0L
	 Xjif5KezQd8NQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3850739FEB7D;
	Mon, 23 Jun 2025 22:10:13 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.16-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250622185510.662af99051fedc1815b9de00@linux-foundation.org>
References: <20250622185510.662af99051fedc1815b9de00@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250622185510.662af99051fedc1815b9de00@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-22-18-52
X-PR-Tracked-Commit-Id: c742d127d2d831aa83ae2987a508bca2bf0c7736
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c06944560a562828d507166b4f87c01c367cc9c1
Message-Id: <175071661195.3311076.12429089372502858004.pr-tracker-bot@kernel.org>
Date: Mon, 23 Jun 2025 22:10:11 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 22 Jun 2025 18:55:10 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-22-18-52

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c06944560a562828d507166b4f87c01c367cc9c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
