Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570FB496D4D;
	Mon, 14 Sep 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789409315; cv=none; b=txeIiyZwKwa1PB8x6+J7b9+TSjOybn5ryBQE5Vig4XMaIjbFVlrJHgR4gVdp8naImlIjJToy4GSJEI6FyJcvpa9BKJrjK4TMUpi1GuZntf2zMkbTAbFsb8VYzOV9EO3PD8+zyD8eyPID/+pZhZnZQPrHMVjdq7Qu0qZkFo9t9bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789409315; c=relaxed/simple;
	bh=7SwUiF4axwLQqulsQd8Wri3D6YFxvlXgDqe6lqvBS/A=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oEmF8ETuFb/kBtSJdiFHt/Kx2F8+zzVS0p1rq2CS/v0Kcxl1q7aty0H3ig+Ua4ZsYG59Ou6Sj5tU4gkRTK9DnY9vzgnvDLuIkYrJe0TUD6NeeBxZYTSGo+vEd3ac2XayCcr5+3MwhgcvOjsDt6tHuCI4tPgHYI55nMVOkQv7P7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBx8NKYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBx8NKYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077461F00899;
	Mon, 14 Sep 2026 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789409308;
	bh=u0KpxEbtIpaA6vBLj8yJU9DCMNoi+xqSXe2yvAGk5N4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=jBx8NKYURkY0EaFCs2uTFvcm1aEQ3xK0sBdWkzbFNIKDm2gXbGqodA+21bum6V3RU
	 fnVCraGH0MPICvMeeGOizbaCvRQBa18CrFINy5ARS9V67Yo68EDRg/XOMLxAGoXlbD
	 9QxZJiyaCZReKxKD4oAGIdOdovfcq5X/t/VUt/LRvfQQTcQbl9lMet4TC3z5HeTlrw
	 nx9aP1ImDI6If/DSjfsYPWZuK2rNGva5SAQIg0tijJ/LA80USVnV8ftBID0cVkCqmq
	 JM52hgV7yVgp/MzR7V8PH2FyLi8JPdEH7C9oxBCrP2l0dHDaIbkx1nQbWZInvr90YC
	 TbG0wsje4mmng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56AF43924FD1;
	Mon, 14 Sep 2026 18:07:24 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.3-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260913215242.66cdff48a7849112984deefc@linux-foundation.org>
References: <20260913215242.66cdff48a7849112984deefc@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260913215242.66cdff48a7849112984deefc@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-13-21-50
X-PR-Tracked-Commit-Id: 7891fbb9512f127826e1d5dbf380ee212bd15eb0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 164f652b6ef9209437ca016beedfcab626ff4f02
Message-Id: <178940924295.1155813.13705216181057255376.pr-tracker-bot@kernel.org>
Date: Mon, 14 Sep 2026 18:07:22 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 13 Sep 2026 21:52:42 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-13-21-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/164f652b6ef9209437ca016beedfcab626ff4f02

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
