Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDA53CB57C;
	Fri, 31 Jul 2026 18:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523133; cv=none; b=Qs6JPN6uDzDlxytoo04MzdSRmve0Azwx6SEjVfSB6VHsw6Uz7piz9tQe9oK37DEl9A8/nKOzhM85xCu9LneQpqDhL0iQpnSU8P14DfPWySVKtKFd+cwko2kF0/mVpHiqM71S5PVy8QiTogjZgnTSC3Dxx3aY9PDhm1Pq023Xkp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523133; c=relaxed/simple;
	bh=gekC/MgnUup7ORLXIIcfpsnsa/8gABjx3PwAdiGRCPE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VgHAsxoHp54uxToww5jdJMkWECMSP9/Doz4GtfBgk333QCgl4VY8IVHKjKVr6FnP58anapOkAgVXivs7C0eLf+kF6VldfrcyBtZwzy5NHrsWnnenMZ+YHy5dqoD+VZdkdMQlMvZDvcZ2NL039yHNRUz4MbLo5hbi9N5t6XB7G1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3ycdpD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3ycdpD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2DD1F00ADB;
	Fri, 31 Jul 2026 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523125;
	bh=g/lzQIVjvbMB+cHgOtiDKK3SUl+Je2zRODZHXSrkEhU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=c3ycdpD09D1CZTYEArbJpJZ3n99kEarPJKYjrFu4XfUTIOIU8MEzOywG2Fo0HJBYs
	 +FlLriI0MzXMuWXlf02aAX4pXF97o7vkBMvsoHsIavye3Ans+L5oK+qkk9uiwMej44
	 z4koZkahCi448THHx/CaZqJLE0YLwEMur/k4FeSIujL1fF1PLZHk/6WKBto3McE15y
	 mtE5EoUX5bVEI1h5SsSfvhCWtO1AnBi0YAru6wk6IbYwGGOnSYgHeysnRHGcWzhxAg
	 9pP528LSzBJSfB28OfGWze49YiuIfyowjEX4Z0T+TwO0c6b2MqX/sp1DjT6OrDttB7
	 TFPr2IH4QDatA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A9839263B9;
	Fri, 31 Jul 2026 18:38:09 +0000 (UTC)
Subject: Re: [GIT PULL] additional hotfixes for 7.2-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260730193347.67069b3a7254649fb89c0956@linux-foundation.org>
References: <20260730193347.67069b3a7254649fb89c0956@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260730193347.67069b3a7254649fb89c0956@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-30-19-30
X-PR-Tracked-Commit-Id: 9f1d75a4ce04095afdb63d8e540092ff8151dacf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c7ed510824b1035a9bf7c3347a946f3ada81299
Message-Id: <178552308825.857209.4715981379357494186.pr-tracker-bot@kernel.org>
Date: Fri, 31 Jul 2026 18:38:08 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 30 Jul 2026 19:33:47 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-30-19-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c7ed510824b1035a9bf7c3347a946f3ada81299

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
