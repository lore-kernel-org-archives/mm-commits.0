Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321DCC2ED;
	Mon, 22 Jul 2024 01:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721610924; cv=none; b=dqrzCDhLeUQ6r/mU42aDidv+pNNdtIM/TkU7pC57VOI6qb7DuB0128gKNTrB5r3lzmYevfF2m9ODPJbSb2usmmkoHdijKbSiGs4Iwb1XLx5ePLUqaHx2q8Cf9uVJcMqDnjQb54N9DcDDJKWFmvHRS2T6GhTTzrCbyOvXsIfVjhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721610924; c=relaxed/simple;
	bh=Ww1NU0Eh9y4l/qtALACWFICY66s4bvmwMdMQ8EQ8T/8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uu964bxbEmk4bcQOtMJ756giMX4F/lNQkAhTpFpkGh6XqLUl3v4wdv5sF4bCq1BYKNX1jsppsKmzEZYsQJJN4PO926GH1/nyDig6IM0wGqdNjra3joY+GltK+wMxN7oEKhxdsbqKAz6Te3F8B/H3BH64baHPt1Uj0a4k2PMMLZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M18EJqqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M18EJqqM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE0EEC4AF0B;
	Mon, 22 Jul 2024 01:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721610923;
	bh=Ww1NU0Eh9y4l/qtALACWFICY66s4bvmwMdMQ8EQ8T/8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=M18EJqqMtB3tevsplU52gjwj9aPQk2pyRIh6z1k0YoHT5+4sbDSnUe2qXmXLuqK+k
	 C9aQPYqQ1URu++Zq1izeGBEKGbh/yzS/ncYiCTmDYofzKGKHlon443YHtt/nkFFKHB
	 t5+CSyqWAWFBWrVg5OalIZIFHq2yNJfUzhw13rRgh8ZJSC3Dz/GZOT6N0lhWb3wwTm
	 9mOXNbMueSalOPQtAkBT46N5/wsGb5FezYe79QFa3L4wrxCa69bgcxudhEjbMcNVgj
	 yF4UZrtXIGey4ei8H1s9/nScj4HNX9YDvQMBstML1s+Q0XfAJnmWo+NdgUAFCpS8xz
	 j495bxbA5lfPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5BD6C4332C;
	Mon, 22 Jul 2024 01:15:23 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
References: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-07-21-14-50
X-PR-Tracked-Commit-Id: 30d77b7eef019fa4422980806e8b7cdc8674493e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fbc90c042cd1dc7258ebfebe6d226017e5b5ac8c
Message-Id: <172161092373.21017.16428992388199740936.pr-tracker-bot@kernel.org>
Date: Mon, 22 Jul 2024 01:15:23 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 21 Jul 2024 14:54:15 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-07-21-14-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fbc90c042cd1dc7258ebfebe6d226017e5b5ac8c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
