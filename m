Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010472E8B66;
	Tue,  2 Sep 2025 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756845759; cv=none; b=Y9quECwrMms1KtFiG7yNBiEQ6SoZfQ+bUISc9GFzHTLY8lbWhpDidLYk7i+Jofowgyh+G+WPMRLFwWXVbmNJEQvutdCVL/G4/CydyiAr+ucxuD3wytSApvyToC6OVF9+Z2fb5aQOr1XOnAgR+H9rtuTuXTFcyiGWrGLpB/s4hTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756845759; c=relaxed/simple;
	bh=EY3Ros8ui1AxqpqZefjCgk4LjTsOIk6qAWtxKeex6fU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mW6tgayX6xUKnx5037K2oV4sscQBGsjYqxvN8aNvYsL6QuScYjEvw7N0xb1vOmcjm45Q62OUov1O995Ry5tjFY1KI6B49u3+i5OWhaX4hrP/2EPMEUNYUlrY5cganx6iQDqqmi1E8EjKqWtTZ1qTS3it8KBOTggY/pg49WIWq5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p29jjoBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p29jjoBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC493C4CEED;
	Tue,  2 Sep 2025 20:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756845758;
	bh=EY3Ros8ui1AxqpqZefjCgk4LjTsOIk6qAWtxKeex6fU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=p29jjoBAJe6T0O7UThks1cmcjI8SwiFvWaxZKkHmZDYW+zegGZ+hP7E1ddt6qE5Mf
	 cTWXmxdr2FFrkYBwpp0gY0ofH3mAgU6Awrm56ogJI/LhYXeFNSwdUg5H22EFX0UcLV
	 XpkohuD27GjAgrQLodQ+hyo6F+1x8RZ0HqAhPzmyYUe1UuV/bBs6i+gDr8nscdXlSn
	 9otq/HIICPl47kenbfXhrMXtj1n/aYYoUDeag+sTGpfSFjtI3Y3oTdd2wJ1Exyb776
	 7LgKNtE7pKL105d+816ek+fl35NjgiCLIufI5Zo65vE7/S59HUgTGZAjAtqnxf+BB5
	 ZoooU9lR3s5pQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7146E383BF64;
	Tue,  2 Sep 2025 20:42:45 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250901172234.3a74524a97b595a5a81d1697@linux-foundation.org>
References: <20250901172234.3a74524a97b595a5a81d1697@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250901172234.3a74524a97b595a5a81d1697@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-01-17-20
X-PR-Tracked-Commit-Id: c873ccbb2f8db46ad9b4a989ea924b6d8f19abf1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8026aed072e1221f0a61e5acc48c64546341bd4d
Message-Id: <175684576405.430647.5772922228170674151.pr-tracker-bot@kernel.org>
Date: Tue, 02 Sep 2025 20:42:44 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 1 Sep 2025 17:22:34 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-01-17-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8026aed072e1221f0a61e5acc48c64546341bd4d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
