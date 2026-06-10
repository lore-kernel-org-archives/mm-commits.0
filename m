Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C915E97;
	Wed, 10 Jun 2026 00:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781049959; cv=none; b=g5k9NktpVAbR1T8f/ojRsKu9WgQs4aq8K4r2BY+zEZrhIacXp8ONuBQvsZG3BWDwSzhfAyS0DOHxyI4EmkA/zW57MqTWHjIcGjVOwpMBSmERXLf2r6chV3MT9+gWQ23QsoVibeVcEBXO8rysX2p2OoFZXhqfSKcQxrOXXisUSRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781049959; c=relaxed/simple;
	bh=Y1AO+CZpJoL4rMTJFWnV+vxczlW9h9igDcUrOG9SQK0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GozQk+QOFcseYhZWGXv6gFnKEtaXFyNfz1Jf3XT+3fk4JvdXa7ICnh6nXRKNTbf4nSiLQ3ZljBEdkzKWjSmQTTOARBoLc7cepLjvOctSP8SG7hoOsUQGs0YU2ynZROwpRsIYwjjWfSsOyoFQ4U8RuSC5zQ4+JwyhEfGq9FFIqmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDPD1E7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDPD1E7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83151F00893;
	Wed, 10 Jun 2026 00:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781049958;
	bh=U2oWTyRfuyBQWmZNU0N5t+zo4Nu31fPKtsscZI06t58=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=BDPD1E7X9MYJxio/V5ZunaDH7m7HpkFOzcciIEAxkWdCS53+d9M4nQ39f8V4qyqso
	 /Vqceq/FHZ8aP5rK9Z74Fam4PAZe8GCe84ibcchf0fYXoSOLgEQsimF1nwW0erd8N1
	 1jGRBtpNJMxv1lLvbheaOcUp2qJYsu1+y1M2YExrVmmGjhe6sWjr1Vztrl3oYzdSj/
	 Lc0T7Xg2DYRWON6BC5/J9n9wQAPmGER9RXZg/UwU7qWOk7O2xmKJN8+chmUNYP9FUh
	 nFfWBTgbHgxLLdd/yKDRKAT0d01mle4IwlbmNi/H0R8o3UY6/0djhU6eGwxvPArcZt
	 MfE29CULB7Zdg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198DE3930A0F;
	Wed, 10 Jun 2026 00:05:58 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 7.1-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260608205426.3319be94a327307e23b34f3b@linux-foundation.org>
References: <20260608205426.3319be94a327307e23b34f3b@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260608205426.3319be94a327307e23b34f3b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-08-20-51
X-PR-Tracked-Commit-Id: 0c25b8734367574e21aeb8468c2e522713134da7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 685441a6d3f17404b47087d051963bc7fb665ef0
Message-Id: <178104995669.2756347.12777254541134916583.pr-tracker-bot@kernel.org>
Date: Wed, 10 Jun 2026 00:05:56 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 8 Jun 2026 20:54:26 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-08-20-51

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/685441a6d3f17404b47087d051963bc7fb665ef0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
