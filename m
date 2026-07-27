Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAA942B728;
	Mon, 27 Jul 2026 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785189040; cv=none; b=RaHqsHUDUDNhFqlqZQ++1hsTxtpH/U/EUpzrsjJaUwBZIsjw6SxA2LPwv5rzSP5OJ92grQdIr8g6wijfc4JzxTZOKuluctLwKbBaCHKs/pcpCvkgVYTDAR8EA2S1B3drA9MrLChC/x4BG/Q6/MPCES1vgTXP2/jpAxv9f6uCUE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785189040; c=relaxed/simple;
	bh=lGISE5fzNJ9Bp2TrFjygS3ZrbqpoJE4jPQeFIh4yyVc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jgAcRNdBpcAjhSzIpi0CMG8UuIKLCFV4AFIzjdotC2Ugbzo+BzxWZVUVML9+taLA0hzso0dn7rBkahs/DIhNh5Hvlr3G31wVEiJtRrGg5aAYq8LHaNP4tfZ38lmDl8GSsM6X4+El7l3hzbQN0oJxYVyliezYBnjJ8fvNnMYotvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJybgTFM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJybgTFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CF41F00A3A;
	Mon, 27 Jul 2026 21:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785189039;
	bh=IObLMwFXviAwE0MuJFpkaHWW+I+EiuAqKlIpXKq2l+c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=iJybgTFMewLz/05qL5l/JVjQunItq7VvfwESk2oUos1duInYYuE5zCF9n4mYAz4sa
	 vq1CvrP8VW7wV0/3aD6c3PGZ8o5VVm2n/j8ZbLKtkPIEfQE+9TkVFqftYHSIX7Sj47
	 zRbAtMRSsMy8owbOq78oLqc0XJ7q3L3Jr4VB5E4stItwrFXNkR1z8URVX8yVgPVdBw
	 0SPEPkUS3c/9hUDizzBQ3hPnxGQgny9fRoBq10IS6VUGkjzmFODy/RRCrauaTggCyU
	 VGu4Hx/SBw2Y8uLeRgzuser8hiqZjUg3lLgmDpjcjHEgbGNzvnIaXjYX3mOcusNFHp
	 Oc7Y4SGzV7KVg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93CF3380CECD;
	Mon, 27 Jul 2026 21:50:05 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.2-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260727142015.3795e489e504bf62b793bb55@linux-foundation.org>
References: <20260727142015.3795e489e504bf62b793bb55@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260727142015.3795e489e504bf62b793bb55@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-27-14-18
X-PR-Tracked-Commit-Id: 40de8160ca7f67d14619ee0351ce5d68fc4a237a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 62cc90241548d5570ee68e01aaba6506964e9811
Message-Id: <178518900429.1430977.1445190236974738530.pr-tracker-bot@kernel.org>
Date: Mon, 27 Jul 2026 21:50:04 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 27 Jul 2026 14:20:15 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-27-14-18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/62cc90241548d5570ee68e01aaba6506964e9811

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
