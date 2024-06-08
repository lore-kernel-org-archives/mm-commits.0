Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B21522A;
	Sat,  8 Jun 2024 00:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805754; cv=none; b=lzATI/SDcXoHjG8Xj7WCwDy/HTBuAh97qNBac2WQ1awS7vJvxV0hULwuweso69ORCSp8kwOzkKCJbU27MAw87OOzOmGMV7oku8AE03th4MU61sUE3puml0Ei90B3BLlv7VxEJiCJGMDuZyUZroNQRAXGI9ZfXJt1+xN4NUuAsVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805754; c=relaxed/simple;
	bh=ERQKEfoAStxfgSIjH8AQ8sfWG5NJa2jLuC1mg9bi5OI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Rc3220NBh/MO/tN3EdDe8g2DUeRfLWPri/jTOnbumxBHSxXpUgovtYd/4a9Si78KEPhB1eYSVtE33CQ8Mg4fobOPywLURBkScDHBkiZZaSzqClS+LRLUqte4j6YSDqTEcMFZs/T4yS6i/f2aOg5LSnQilc1bZhEbYKWbAzL+QzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvPUZlaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvPUZlaC"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9ECAEC3277B;
	Sat,  8 Jun 2024 00:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717805754;
	bh=ERQKEfoAStxfgSIjH8AQ8sfWG5NJa2jLuC1mg9bi5OI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=RvPUZlaCQgMaG7BOA1cmuexw7b88yMY+mZ4W2Wc1Vquhl6VSDLxbLdx6F50Bnfx3h
	 ZSqse3hAYlvq6MLRf0fbkQ9K6Yzg/bFrCT56ujQ510tDVD9FAhAz5HtU0+XUY0lNdu
	 /9AGd6gX/E5Ouce53wG3IZ9uAmOGEc8Khq4xAz3ZJxgYfGOc5bCm4jabDM1aGOEByZ
	 YO2FSqNmCD0+YMpb9LjF6YcE+OBvNQw9n5cOKzc9MB+RqLavvNv+yeCpufg60nk/Xk
	 3uuzHWELv2dQfNAyRT4a+e6VcrUrSEvYntb4szO0XK1S13r8zTnd6EwQ6tyCfOGecI
	 e3c2rtQZHe9bQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96E40CF3BA4;
	Sat,  8 Jun 2024 00:15:54 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.10-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240607152944.60722ce87f5a4b1a74d1145d@linux-foundation.org>
References: <20240607152944.60722ce87f5a4b1a74d1145d@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240607152944.60722ce87f5a4b1a74d1145d@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-07-15-24
X-PR-Tracked-Commit-Id: 7373a51e7998b508af7136530f3a997b286ce81c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dc772f8237f9b0c9ea3f34d0dc4a57d1f6a5070d
Message-Id: <171780575460.4241.4759347059353805718.pr-tracker-bot@kernel.org>
Date: Sat, 08 Jun 2024 00:15:54 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mm-commits@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 7 Jun 2024 15:29:44 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-06-07-15-24

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dc772f8237f9b0c9ea3f34d0dc4a57d1f6a5070d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
