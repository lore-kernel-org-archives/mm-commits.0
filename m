Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780EE2EF660;
	Fri,  5 Dec 2025 22:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764973080; cv=none; b=PGemv6yG29zsarigad4tb6qjfAa/cAm+MB+EP7M+VoTeGkLXlxGQpmn55OhwCPO4PGtTpzbOcx8sbyx44MKIVwqLn1aeD9Wruc+x6bJZuDuzmhpdhpceVKAtPQLYZI8awSirReHI5CQaaVk2XMG4QYjDFTxeG5bdnHDNeVCoPAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764973080; c=relaxed/simple;
	bh=vZT1N7OzINfGzWrHt/AkN/V/E9PnnBAgULLc6tYB1to=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=J6geEXtXpqtakBrzvYPDkLHOj9n7l3jPfW2/IG7CAzbUSTvwbXCFKq2uM2fIj1fR2oJ/LNYN0vEaP23otmnc55YbtFEU+4/p9frl/xl7iqHfzGYKhrnagOW+UPtlMJ8x3CSrYInz/xw9cX0rXqsAlCjRPX+NScZqfSooNDpKCH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKJDUWnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKJDUWnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E0EC4CEF1;
	Fri,  5 Dec 2025 22:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764973080;
	bh=vZT1N7OzINfGzWrHt/AkN/V/E9PnnBAgULLc6tYB1to=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KKJDUWnkV+0BrAmG8iaVkXv27AugTFYBBr6nztV+v34qGDUKW6jEF597sRBLAlOJ7
	 PjeO/UeJqAgshM9WebG0HlpNtBBaZY2QPE+qUhLhxJeVpMvMdY2azGnwYtOAWIDUZV
	 okp5Roy72KnzP3QPqaL7ul/DhrXaCMOPYNcoiMbXoYQlbdKu/Q5xP88WDAbbbl+ulJ
	 ZEISnSfQe5iQzewdGiQS+/5I4l9noyecrGSky0+/ViO7S5COrwtvmm2dWoZhflCSHb
	 AiD1RrUnHFCFTLV2j4nvGT5aLUlbkxj2e0q0E21TilXA1rauBvHs30DnZc/0NHT4Ht
	 sEedszSmQEa1Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2D0D3AAA0D7;
	Fri,  5 Dec 2025 22:14:58 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-03-21-26
X-PR-Tracked-Commit-Id: faf3c923523e5c8fc3baaa413d62e913774ae52f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7203ca412fc8e8a0588e9adc0f777d3163f8dff3
Message-Id: <176497289744.1839199.7735679084188935975.pr-tracker-bot@kernel.org>
Date: Fri, 05 Dec 2025 22:14:57 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 3 Dec 2025 21:29:18 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-03-21-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7203ca412fc8e8a0588e9adc0f777d3163f8dff3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
