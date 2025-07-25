Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5F7234973;
	Fri, 25 Jul 2025 02:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753411789; cv=none; b=iNCq7nQ4S7spNReniQK528R8ovkRnZbevralR5Gl2NN6n85u3xXhSMAM0tujD0EJyTUOZMuKUH0748ziquUhnQZSjOzPLtMk3JOWNFL6/8ziKXNQWMqwNR7Z7zTbySX8yQntEonR7eWKH9DG32klj2hwn7Jb4KtwgdhM95ezFrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753411789; c=relaxed/simple;
	bh=qUCSrAgl+i6cCOtcKNxDQMp0yHB2JDvPJZobt3f40XA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BrNz3YWR2kdjf5EGxiQaZaWDQhH/h+Qsi+UDHd3d+T3U2LNz15n6S7mWADAutdhIKoO8Bm1yy78QfjMNcAX+wTCV1bT2MR5UMuuLoyaHZXrTS2S5joNhOTwM9KfyFfvn6xA8xmxHLaTsroPDATJge7eshrC4MCrAIsWTtr7mGlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olzSoiu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olzSoiu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7963EC4CEED;
	Fri, 25 Jul 2025 02:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753411789;
	bh=qUCSrAgl+i6cCOtcKNxDQMp0yHB2JDvPJZobt3f40XA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=olzSoiu/cgwUrcS6qR4oFnQAaMPu1oi7AKpl9XFOquxrYPnxzSVDJCZnUcijUc4hu
	 TPStRmwMT6QHqI7zXjIH1vsPuIL9NtF9F5HaKW6chvU1SGezRisUyYPrSH0kMu6ztP
	 5Dj2bhtXaLV0Z0f6MmKcQbFw6hDQ9dKir72n6caMjAPfjf7dMqLc/NaJsSOz+Dfjgd
	 6B70B7j9WwL8INmN5gv0yXwOrBwVkxxuN3ptHf54m/FJSyBUSFGuMt3yq8fw1TrPme
	 cZMZCscGUbFhD44uiiXSJhz1fkp7hzAjr5OQG/sPZma701XOG49p7FZYTf3WHPsgxj
	 DRf4PrRIzqFZA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3907C383BF4E;
	Fri, 25 Jul 2025 02:50:08 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250724180503.a8a80b0b0c904c1c7f967448@linux-foundation.org>
References: <20250724180503.a8a80b0b0c904c1c7f967448@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250724180503.a8a80b0b0c904c1c7f967448@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-24-18-03
X-PR-Tracked-Commit-Id: 0dec7201788b9152f06321d0dab46eed93834cda
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2942242dde896ea8544f321617c86f941899c544
Message-Id: <175341180659.2616960.3118846587587977860.pr-tracker-bot@kernel.org>
Date: Fri, 25 Jul 2025 02:50:06 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 24 Jul 2025 18:05:03 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-24-18-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2942242dde896ea8544f321617c86f941899c544

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
