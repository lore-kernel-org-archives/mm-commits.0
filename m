Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFEE1547CF;
	Wed,  9 Oct 2024 23:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728516605; cv=none; b=NQ6fphWL5xVU617LI19t7DabyZa4g9yGGvQbn8gnbC+t5lrLBc5EcYMC7S7WCp/+blGUqGt18h0iwTp/Byes+a0UyxrRBQ2XfGtK7lRExX+p4C+qGDi6AB0mjbIXcB/Kw6VDOqXiwtLACRVUJg4rI9iB1BpFf1qO/2feVgK0kMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728516605; c=relaxed/simple;
	bh=au3Vp4Y8pYuONjLQnkndHm8rK/atD1AIVU9Gic4+F+g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=C8IFDWl8oDy2tFEcAr6n/M/UIZri80HIeGFm9Gf4KDTGCzHYtx583M0srE0wZgTWHFXqF0NsL7k1xzbdwE8rOBQmpXoBjuXTMpPevTpOpY3kR2ZTYbp6rKPLbH2c5ah22gk7vwWL6RfaxUCJR/bgFR+WQ2kHZah91cYvOpeCkkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltV0QNfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltV0QNfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE005C4CEC5;
	Wed,  9 Oct 2024 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728516604;
	bh=au3Vp4Y8pYuONjLQnkndHm8rK/atD1AIVU9Gic4+F+g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ltV0QNfgc9AGAysOuBO5YouxGiPuoPHmGUEAITJB9Vnz14rRoECGKQb7h7ChhX6MX
	 d4SbDIGlBfS1QT59u+52SLxYZM3YQI1hqPeGVTPPCkwBEP7XfMG4sKxK04zt4xjV6i
	 q3AEgX870YvXoh8rShgWfZf1t4SuZ8NRRxSbg+Im8mfFcEmIaWIXNZgZeZxy+8eTL2
	 JU8woFpaX0NfHpI7VRX1VJRZ0rDsceosQCcj/cKtNDaYQb0jr/MM3Jk5Q56cEw+Def
	 9iFgLCD+xQSuWb7rX1PbFMDJkB4OsqOD4Vt5LFKuaY3UPku9f07GGSOk3PvfN2VKsg
	 XiWwuaSWWuBJQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 36F0D3812FDB;
	Wed,  9 Oct 2024 23:30:10 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.12-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241009155033.485bc6df1a01b6dfca93a9d9@linux-foundation.org>
References: <20241009155033.485bc6df1a01b6dfca93a9d9@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241009155033.485bc6df1a01b6dfca93a9d9@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-09-15-46
X-PR-Tracked-Commit-Id: aa5f0fa6af38d96bc6f1b7e1534f5b5c025930a6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3d1556696c1a993eec54ac585fe5bf677e07474
Message-Id: <172851660926.1505966.5311887052008986344.pr-tracker-bot@kernel.org>
Date: Wed, 09 Oct 2024 23:30:09 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 9 Oct 2024 15:50:33 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-09-15-46

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3d1556696c1a993eec54ac585fe5bf677e07474

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
