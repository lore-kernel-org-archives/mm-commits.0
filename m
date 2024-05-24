Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460984A01;
	Fri, 24 May 2024 22:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716591252; cv=none; b=DT0/e5MCmPt/CHRnBBdm84iUWBHaSx0ABV0zbHbui5A5v0LTgyilqI6wK29wSB15zhV6IP3p+HLBqOgLHe7aJ2tGpX+SicILm4Zq3ORYvRpm8aZJaawtP48Q/K0UrM/+gtcOMOBku/HKdIMAt03T+ek1tbRt8NyrLj5tymUyHEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716591252; c=relaxed/simple;
	bh=FQRMBiCY0NCuUl+9rQmZqGpc8cg+oLOsu8xRauk0mMc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=S47V09j9B3IUFkPswu8r0pbQjnoIR7UwB/wj7Vx8QQozaR/GCOtm8d7asFawSehlSDAFItWXmesC6biw2LkX0GuEh99dO/nLbbsw7fo/wJmYPjbwbAc1eRuf3LguKyZ+24yAVbFdmAuh5RHXaKhAdXjJyPzMpdWnMNXJDzZ5IPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqOhJcaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqOhJcaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28921C2BBFC;
	Fri, 24 May 2024 22:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716591252;
	bh=FQRMBiCY0NCuUl+9rQmZqGpc8cg+oLOsu8xRauk0mMc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=UqOhJcaZTknC3Vh2Wru1oEmafxz5U3VwppXzAMl0b7cd+qOLUR53U0uYDtvK3GaEy
	 hvwtshM6/4MPD4mCuN3RRqs/izORB6kV0UYxWcb/dt63mHXJehr8U/EwlSzwcJquS9
	 nSDPLpmCXRP49XXYf3Nglc942PBLU+aBH3tUO1Ru4AXFRIfF0CWgi/PgJ4KE/oyqVN
	 JLieR5a9LDVRtAY0ZUpdFNxvZCoQGO6Q4QmwIpSmDo4FvJfML+Sng08liRK53A/Dze
	 vmIJprN8cKPn1VzQmYQvR9iwqSZk5etfrotbnnqVNcOAbVrXssT2vmH4b8wwaF6Yo4
	 bZNQhKclo9N/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B124C32766;
	Fri, 24 May 2024 22:54:12 +0000 (UTC)
Subject: Re: [GIT PULL] final MM update for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240524115135.3b6fd971bdb3e538e1873632@linux-foundation.org>
References: <20240524115135.3b6fd971bdb3e538e1873632@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240524115135.3b6fd971bdb3e538e1873632@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-05-24-11-49
X-PR-Tracked-Commit-Id: a52b4f11a2e17109c4b9f7df4ff19215b1752efc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b32d436c015d5a88b3368405e3d8fe82f195a54
Message-Id: <171659125210.6963.5097523928632344684.pr-tracker-bot@kernel.org>
Date: Fri, 24 May 2024 22:54:12 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 24 May 2024 11:51:35 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-05-24-11-49

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b32d436c015d5a88b3368405e3d8fe82f195a54

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
