Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FD2376BD0;
	Tue, 26 May 2026 15:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779810888; cv=none; b=VNcKTEuM28LVs9hsVmsjFp/GmDwvQX38RE1YMvEegFD6dKDYRMnGAMnNG3Fa3hlP1jFBw+T0VVDZ/Y6Eggj62Jcshtrn5AB9sdvHG7X8zGTeSQ0H7ISA9Q4KVUXDa79nO62vo4z48bv3uG/13RC5AXRGO9D7KstQ0a10jjTtduY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779810888; c=relaxed/simple;
	bh=4lFP7qu4Y1vSofhJqegVQs8wRl6aKhGmI1/6kJuG2VE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ONTkFe0s9Ra88L+ng6V2e0qFidi4Boi9NF1x3iiGv6MavqMDAXkX5N1vfokQoWaD7wawgjAkuoPaPW4V/OyZ/wmFX2PCNoGbz18ukzLjbbBZqYVlTptOkIsputJTdbmiQLvJ4vAWgJcB4ZkbYJXN/HjQhubNY7KLDigI+n6i+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TwGgf5eY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwGgf5eY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B711F000E9;
	Tue, 26 May 2026 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779810886;
	bh=mjTjLcUf3D3RpHdforEePIUHCwUbuLTqLgsCOgyF/uQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=TwGgf5eYPo8x81cmujdnoOfMNKzw8AGuohgG1b0mkf7HduN6SB+brzvWeN3KokGFd
	 yWPshT7SJK4udoqPAYn3zyZ5suXDwn5Ts5muoqwnUu2Hd0/Qn/yN5NwtBMkf0dUIh8
	 y1jMN0wlHxm7JlqVnhVeNhBvfIR3zDi3mN5vSilxbGL5S7d6b6hu0A6NysLcnIRpti
	 Xho5JKlddVz2Q+A47KvQpScz9eb/q9vV8Vp33LKlNGzwZy+bPsIX5lmClXe9wc3kXs
	 +0l4+bEX71oJ3ipy22Fx4Ft0V1TnbyJvS0AaetD6xvbW8ZMgO19HrO8eMhRZBGwWUs
	 CnksU9A/U9OUA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F020D380CEDF;
	Tue, 26 May 2026 15:54:53 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260525162455.b407390573351c2d352baa16@linux-foundation.org>
References: <20260525162455.b407390573351c2d352baa16@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260525162455.b407390573351c2d352baa16@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-25-16-22
X-PR-Tracked-Commit-Id: 54cf41c969da6637cce790b7400da1451609db9b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d60ec36cab338dfe2ae40d73e9c8d6c4af70d2b8
Message-Id: <177981089259.3872742.1490966349452710325.pr-tracker-bot@kernel.org>
Date: Tue, 26 May 2026 15:54:52 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 25 May 2026 16:24:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-25-16-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d60ec36cab338dfe2ae40d73e9c8d6c4af70d2b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
