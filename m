Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793914657;
	b=daOg4YunDzU7j2ruJi8M9P+3BPuc0DJMhdiCTTojaOnnBa5MFGJSw4dPg2iCvwcZlVDS
	 XbMzkhUGturfJuwhKtFSSDVCEIKreFl9nfYi6pQjNLPsSSNPXosElHqh4ODwrH0guXxGU
	 8ozQJMprY30rUko2KdQ6ACz/BGfYpZ6eOPJSJarCAV6qY34Ih77Mw6sRiLguC3kaTA0Q7
	 muRMT3cQv0A+RMXLls9EWlVppc/Md7EgvR/aQuYFpp/e89hhHq73LvymKW0N8xgfua0ML
	 D6Ap6Q4XlaBA0ESzD75gVbq3i/9NYrAcYO0IP/foE/pUCDKrFSQbE4+LRkEXw2vFnaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793914657;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=MqdUX2Td33+rRaomDoEmSN7ivph1Gnk8nEs76vR+Yzs=;
	b=q210wr9nO2gitxWcGbTFwQf1QNmAfPDWvGv9V7/rYojLbAWNOOQNmPfk6bd2pd+cF9gc
	 W2zTXWpslbgQxWckhmw8YHgklbrTH6NM1ynarOtMwFXF0jNG4US7zCY8vkysaj2uBb38M
	 k9Cdd7U40qefxp7AM9NsQsccEPXbHSwWRpFGJtlTdmXiFpi4tW9odx5LR+//kCondvkGe
	 h1UNdqOd2zkhJnvZsDkRa/KORMyEkEy4YKkPZz1oeN9c/XBavj3kSs5buWcf2p8kSnuWE
	 kET+gZS8hbos9ccrpcmpKrvVMCljA1ImvD9yYTDvJDAzOFrcyqCvNc3TDZ4pmhyX/Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSK3RUep;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9F8606A332;
	Thu,  5 Nov 2026 21:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSK3RUep
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291BA1F008A1;
	Thu,  5 Nov 2026 21:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914657;
	bh=MqdUX2Td33+rRaomDoEmSN7ivph1Gnk8nEs76vR+Yzs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=fSK3RUep5yDq4Y3rrxxl7whyQRZOdKKBSHFpctJ26dYpC9Y2TISpYzLZGJHHKaOgE
	 5CDgq3F3n2laURcMXm10OW60J7JL0Pk+nkLl1jZMpf04Zw3F7rppjSaeorni/RcWX8
	 Nya7+HDD6rUB2ZdiSFqzYqXP3U3W8X2XcM4XPziaEVG3sHRYydkNuLBTX26L1eGoko
	 UjIHFGIbHWo1dMlH1Bgg8Zrc9/kdUF60c4btXQgHekq7Fg6I8+fOlXmIy/wmzweNkm
	 BT3xX9Iwq5nksYGG+iot4tbwPokxSfCkYbiCPt8PdwhM8g7HpqezKCF16Yjr3KsXww
	 sMlTT+B/6d6ww==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 21049391B19C;
	Thu,  5 Nov 2026 21:37:37 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM hotfixes for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261104202749.a5b9ab39d3169f80b5089a14@linux-foundation.org>
References: <20261104202749.a5b9ab39d3169f80b5089a14@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261104202749.a5b9ab39d3169f80b5089a14@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-04-20-26
X-PR-Tracked-Commit-Id: 5b4696e0bfc358619adaeab25ad35b4979af8331
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 46a062865b6b6b9a2ba199101b44feb925455c66
Message-Id: <179391465578.190890.11695255160827231010.pr-tracker-bot@kernel.org>
Date: Thu, 05 Nov 2026 21:37:35 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Wed, 4 Nov 2026 20:27:49 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-04-20-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/46a062865b6b6b9a2ba199101b44feb925455c66

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
