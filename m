Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB23340D90;
	Tue, 17 Mar 2026 20:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773781053; cv=none; b=p+Ol7bANolcD1+2Pl1IxEWl5QzSYwpGKtrgj7a0Wair2vj8cieh4NbC+tt0tMmnjDNKmAnFV0UJmDe4RE4bmbuwcRtU2tJKtBYRndraACktD0CtytKdN/bb8DTHeeOxHnU9sQAsZKsGVkdIXkcG8dF92HoirFoisQwg9s2Inoyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773781053; c=relaxed/simple;
	bh=guTzA1+naN3igCbO31ky7A4heGg5JVZ1ELhJHmusAks=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=F7+lJuvJrn7yu6NjhGsPUETy0jWYPusDNxfHD+/Xc0wSMsCj2fhJcq1gByTXuSzNAP+HWK8+l5f4lW6iuLi0t3zY6yd5xrWhiTLPefjebFVexTh8FF/b5xmTHbnArJzvi1Q3tUX4U0xnrFyp+vW1C4Brj6iETH5RjQynNyJq7lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKtLr3D9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKtLr3D9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215CAC2BC9E;
	Tue, 17 Mar 2026 20:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773781053;
	bh=guTzA1+naN3igCbO31ky7A4heGg5JVZ1ELhJHmusAks=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JKtLr3D9wSXIBFWmpNMUlliH+9JqogwmxNQtP2sPI/ePqhIzbgTTVxEBnVwfjaJT5
	 e/fo1FYmH0+DN9lXTOIGTDxcNdTm6POBP8yzeCBmtjcF53wi8ZLI5ylxft120t4f9P
	 nndk4RipFCrZB3QFeukWsC6GPhWNJCitDzoosU9IgKLJVBj85F+ng6h8z5tr9fHZYP
	 dlKcv+2qRc2VaIo+tKF43WeHLWtRDINOw3vE8787IuaI6FuRowgqdn3SKjv7BMSeDo
	 pMSGmV1+anPcdqLO+8Rtja7J/cvOdIrnHNPAeJ5GamaY5WCAy+rkX64MImBMqtJhfd
	 T8t9ni8qpfphg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0B83808200;
	Tue, 17 Mar 2026 20:57:26 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260316121727.54468f0e01ca280c17f2b735@linux-foundation.org>
References: <20260316121727.54468f0e01ca280c17f2b735@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260316121727.54468f0e01ca280c17f2b735@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-16-12-15
X-PR-Tracked-Commit-Id: 182b9b3d8d1d36500f58e4f3dc82b144d6487bdf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a91ebb337fa68e01339a8c1c411a38d66eac80e
Message-Id: <177378104513.6471.18366680837313261729.pr-tracker-bot@kernel.org>
Date: Tue, 17 Mar 2026 20:57:25 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 16 Mar 2026 12:17:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-16-12-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a91ebb337fa68e01339a8c1c411a38d66eac80e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
