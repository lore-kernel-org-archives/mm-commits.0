Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075E129A2;
	Mon,  4 Aug 2025 00:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754266862; cv=none; b=P2yQ0RzUcS52zWouGbbaTW23I0dcNLnaCQ4XmRzdG4Dn4s7aw1G1aOFUlQG/+QVXkWiHaaxv378ABHY+r7wWNUHP6B7+8G7OcY7cExUINtoH92l2CoJ94XCa5kInVoKug9WEnqkfY7RgHAcMFrFvoV8XbMJx5ZNeR+MiF31Dpz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754266862; c=relaxed/simple;
	bh=+GBsBj5oUsMncRZo4f/B63sXL4D/YxmZlZeMzZIItms=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AK+k0l3vzIeLWV8PHiBz2Yj9ciiDAjKLOa9+YpMRCRQCOu4ifK+OabAg9K+GCo5a1j9ImJ6dSWtDdFs6M+mwUcxqGbXNM+dGrQmnG8TH1wPEK8wSK3lRdT4GDOUFiU2kAI4eeNRE7LBvUgTGE59lExQ9CbG6+eoe25j7HL1YLTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bF91+p0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bF91+p0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8758FC4CEEB;
	Mon,  4 Aug 2025 00:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754266861;
	bh=+GBsBj5oUsMncRZo4f/B63sXL4D/YxmZlZeMzZIItms=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bF91+p0Mo+ZwAnP4Kv71RfDEWHtWROz4VCUZ+r9oc8g/0g7PzaRlPRZWebMV/UnCB
	 CLJg3SjYUTA/OqxNoHpEF6KvCiDizw0xAkE+BrjXkAULQfU/7epS2an9AL5PtDLOQ6
	 MbrO6BAMOaGkftTcjUcxkSjYyOfLoxR+GOMlEifJRQ3ub9dmtobyNHsGK8AB8YsTWm
	 DWgmxXg2sU8r5DRZO0xxeEElyC7WYKrA0iucBc1lCT4QiHc5wJEibaEPEhGVazH4BL
	 kOrJEgJGEivthM5eQevMyZW9T+E/eQTjEqybswBY+u8d6K1ZJoUm6GtPYExrX37lkj
	 BZyM6Grc5v6LQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 37251383BF56;
	Mon,  4 Aug 2025 00:21:17 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM udpates for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250803124842.f3412ea09d7396677e270ab8@linux-foundation.org>
References: <20250803124842.f3412ea09d7396677e270ab8@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250803124842.f3412ea09d7396677e270ab8@linux-foundation.org>
X-PR-Tracked-Remote: https://lkml.kernel.org/r/20250729104245.6be6957a@canb.auug.org.au Thanks.
X-PR-Tracked-Commit-Id: 085dece6cc88b5c6fc6f2eca0403bfd2c5fbc7cb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e991acf1bce7a428794514cbbe216973c9c0a3c8
Message-Id: <175426687581.577274.432913297714282579.pr-tracker-bot@kernel.org>
Date: Mon, 04 Aug 2025 00:21:15 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 3 Aug 2025 12:48:42 -0700:

> https://lkml.kernel.org/r/20250729104245.6be6957a@canb.auug.org.au Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e991acf1bce7a428794514cbbe216973c9c0a3c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
