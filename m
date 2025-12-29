Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2B823D2AB;
	Mon, 29 Dec 2025 20:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767039716; cv=none; b=ttYpBEI67LdM4d0GjDbwAR902gQrCEOI9M9hrUJEwaY1kLwe673kzZMqzyQ+js4qXZ8Pb0C3VrZx1o6vy4ms+xBkqE9pss84zcPgHxbCV/a6bBcy/1/JoPtzfFEGpuhFLbtRy8+L7sRhXTDtMQhtyRxKalKJquNjUJqcIm2nL24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767039716; c=relaxed/simple;
	bh=RUnC6j8rWQ36k5z/8jPrCJeEoxGbebLjrUnPKPwaUGk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nJcyyddmFQOIln9pucYEOXlqwufqOIitZTTh0Cncg/2bLISP5Zg/ymevcHr4r1kQSjajuKbiV661RP7f+VGsWMPcrvRoBnceUjHxjVV4aWTupQH5p2JzqaG7lp0IXh2DTHVFlW6bAplnRGam2FHJEqHtGhV+nYLP2EfB9Nktz64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RFpTP3im; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RFpTP3im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB0C116D0;
	Mon, 29 Dec 2025 20:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767039716;
	bh=RUnC6j8rWQ36k5z/8jPrCJeEoxGbebLjrUnPKPwaUGk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=RFpTP3im3xuRT9HdtJJ5ETj3e7yNZPWQzdcXtRbXJpQfasV+pbqEvnUwmgpn/vIL6
	 z9s08eLPz1To6QudG64IBbBi7CXnLJ/tJoQf8Rb53P/e2Asuy8GsqCHkOis7zBhW/S
	 YjSMTOK37mTjjRGVoE7s33qSG2sC1HGPoOur7WZ3gJBsn5jQxVNtaC+bQa81PhoLBP
	 vd7ZgWbSazboHwcbsC0sC3v3QD3DNLYjpRgJx0fag3G4vORfa2TU5IjVtrdyAlRbyM
	 lYrTchkuZP5KkR+gHYZ+K7v5LCk/JQf/xEKuJ/03mc0MF/2oBH+Yygr/PnmGZRm72Z
	 RyrgwmXo5iRSQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1746F3808200;
	Mon, 29 Dec 2025 20:18:40 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.19-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251228215244.10e9ec389dcadcbcb336c98b@linux-foundation.org>
References: <20251228215244.10e9ec389dcadcbcb336c98b@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251228215244.10e9ec389dcadcbcb336c98b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-12-28-21-50
X-PR-Tracked-Commit-Id: d6b5a8d6f142ad0a8e45181f06e70b4746c4abc3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b34fd0feac6202602591dc15c58e25ffde41bd5
Message-Id: <176703951894.3046711.9527961125769121540.pr-tracker-bot@kernel.org>
Date: Mon, 29 Dec 2025 20:18:38 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 28 Dec 2025 21:52:44 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-12-28-21-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b34fd0feac6202602591dc15c58e25ffde41bd5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
