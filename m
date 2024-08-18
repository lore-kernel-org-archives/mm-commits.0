Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF37A2F4A;
	Sun, 18 Aug 2024 03:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723950684; cv=none; b=ic5IU9HrN/q+8nTYjCwrwvOF0OmycyOF5KHxO/+h7AvN1xo8wuirBBm57SWL2nI4WC7Frp1l6Gn46hJJri3Yjt9Bx/upUintAmMPGkrS8NFz2sQVTnyenybfCGFFQUMd4VIDMfaY3oCH61NTFL7RBbKQRruDcNLHlSnuA3Vc2XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723950684; c=relaxed/simple;
	bh=XB88mgj4UgieCqLOM7Syp7axLwThrYPBIRhhhia7xc8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MX/QoEub6z9rtI9v+nZXl1Pu2h1yZwdVRy1Qcx5uFZD1MeIrQS5/LctE8pVoGHdbVdMh1C/p1PFf4rM+2SghLlc2Ou2UppUaKu5TuTLSvpKNd1NA5bSjlnXrAME/6A0in17zLJDiDpmbCaIJ0GWRQjbIbViLAGJMyHKRbjaXyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJq8TNWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJq8TNWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F0CC32786;
	Sun, 18 Aug 2024 03:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723950684;
	bh=XB88mgj4UgieCqLOM7Syp7axLwThrYPBIRhhhia7xc8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=rJq8TNWUv+31Q/WqojD+ugnUQhEt6MQ4guC9ht/uQsZleeM/qBBG7ms1LtZAIIOvq
	 Rh2Dw+CCWE2Xktzz7PwPVWuS36gabXWpp9KVgBXl8Y60/ECLBjPU5VjU/hBBBZh1cD
	 hBagyyrlNUhY250xEfc3d6nLjCfHINRcUGVPThPO9AThyosYACHY9UBxm2gY+XfGhW
	 OA1E0ZqFQTLBIZID3s+4teK25OzyYiUAEW4xRxv9HoeB/C9xhmp+HeSYH9WYMw1mSj
	 MutYxeTQwRNrdC8+7gNWpfqJdETducswei9h4uDMmkV7FbjJm+dAh02pO8YeFltNag
	 x5dkEMcsXFdlQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3400B38231F8;
	Sun, 18 Aug 2024 03:11:25 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.11-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240817194908.0d40388a9e597b5b99af644d@linux-foundation.org>
References: <20240817194908.0d40388a9e597b5b99af644d@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240817194908.0d40388a9e597b5b99af644d@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-08-17-19-34
X-PR-Tracked-Commit-Id: 2e6506e1c4eed2676a8412231046f31e10e240da
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c3f2d783a459980eafd24c5af94ccd56a615961f
Message-Id: <172395068364.3861226.13951086628472744403.pr-tracker-bot@kernel.org>
Date: Sun, 18 Aug 2024 03:11:23 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 17 Aug 2024 19:49:08 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-08-17-19-34

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c3f2d783a459980eafd24c5af94ccd56a615961f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
