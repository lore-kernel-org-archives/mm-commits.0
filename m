Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B25811CA0;
	Sun, 10 Nov 2024 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731260637; cv=none; b=mOJhqC9pl8ET92A/rwDnaKPbsfGPpIF54kdsZvFfu2V8Dnu9ZS7NOWm+bs7fNbRExqSTkFIlg+70DxC+vfUvB5Yf81qSfWdpEhY3oAWYAdf3J405QKVhjdjfzhwGGO1tXK31eF4nCYy6iNcnegtR366RfD2NMHCidCSs94nxtUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731260637; c=relaxed/simple;
	bh=Az2ZTzdS70JR7j4EdQ3Ur2WdrBF1N/lZv/88jW+YIg4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZZJMFN7rMxcNUm/G84rvaTs9P7UAuqe60NLVEmhG5Uzzb2qWaMLXBBQ8A1vZmznXNov9rG3DGK2wwBK5hDV+u3qAa68vrCgK9VeACk36K+9Tj7dJgcYMpCU6eY1DvbLB15fAS76AmXfbw/8baHL4rLsVtU5Ul7hE/JnU0v6jInY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExkiTd4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExkiTd4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFFDC4CECD;
	Sun, 10 Nov 2024 17:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731260637;
	bh=Az2ZTzdS70JR7j4EdQ3Ur2WdrBF1N/lZv/88jW+YIg4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ExkiTd4rGgItt2qhGi1b4bW/QwPJFrPGQLD+hbBh2OtjIba1uqKgkcpzE6WxHdtzW
	 zpka7UbDqPe9PEc21S0kH8p+IDx7qipP/TxpOjidrJx3JkDoUGdHPRcocLEYQkHH2o
	 rycbsFhYktmWNBk0W92RjDhjwFaxknz8G21vz3fhKGRtTv8YEZfyRltzTZHgpCJbmT
	 NTHhgI+84yQuvowud/jt9hUSEC9kMs0IOfodb7+BFTYoJRsuzdQegGSnmmuZ72VU23
	 J8AOMSkdFKEs0PUJ9thL2AvzkWqyo550hyAKufyr9DAt9lpumiZi0CuSefkJSr1sZc
	 6uWCsxyKE4hww==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 718A23809A80;
	Sun, 10 Nov 2024 17:44:08 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.12-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241110014508.c2626adfff36ba70af88b0a0@linux-foundation.org>
References: <20241110014508.c2626adfff36ba70af88b0a0@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241110014508.c2626adfff36ba70af88b0a0@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-11-09-22-40
X-PR-Tracked-Commit-Id: c289f4de8e479251b64988839fd0e87f246e03a2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 28e43197c4460e08b55554c05998d6de9da7d0b6
Message-Id: <173126064709.3189816.9455249071893662256.pr-tracker-bot@kernel.org>
Date: Sun, 10 Nov 2024 17:44:07 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 10 Nov 2024 01:45:08 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-11-09-22-40

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/28e43197c4460e08b55554c05998d6de9da7d0b6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
