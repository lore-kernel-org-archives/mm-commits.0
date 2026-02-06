Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BF92F5311;
	Fri,  6 Feb 2026 23:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770419375; cv=none; b=g/zW4C7gyTrAgS+D5wZJ1i1SjAXp0C1vKX5eFpT0uO5wwrcvA4tLkFY+7DCrHVl0iB426Kc//MB8Tx0nLJQq1BwHCG90BQh8FrvwW7ZETvh6ptKZdDtBKOCxk4AcPHvUXylTaXwuSIbefQSKcYx6cFXfFlFxHmJJDvKKCLABcCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770419375; c=relaxed/simple;
	bh=4OeBmvtFeRbZ6Dfmm12Cqb1YDfbaZl+I7QOFZRnjzP4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Qr+QglbOmSji8PS+VXIMB/MQ9aAdgl1XJA1iIeCi89H7FTv7xuow0O9QlMEjl5VmEdtQh4mcdSjeSmEfVivVWha/nzs06JA1yIpEfp1J0p0VDTm74wdtUQRTLc7xtoHARRn6UO78SOhscWEFU2pMmm+SgqQPFW7dVTJXkcRvDtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u7oBmgbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7oBmgbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306FCC116C6;
	Fri,  6 Feb 2026 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770419375;
	bh=4OeBmvtFeRbZ6Dfmm12Cqb1YDfbaZl+I7QOFZRnjzP4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=u7oBmgbDhw2h3InaLV/vrRcGN6oI7DTpLEIEgYqa5PoMoVuGIJcFISQy4PVumTXTs
	 96za0u4OheWETMx+1ET3BbcdjKDq/xiYP2NEVW5z7Ysks13ipbRofvmM5v7gMz4ADs
	 5fxBS/MmYfLSyIDHcnQtngOTsBsAXhvkTDaP8W2xaH4qWFJpLZvrWJY5EBO3+qYDUa
	 b52wdSfHJe5FBykjyc4rztnrIGKDWsBh4QNebBldTNHODc5qpAxNXd/Nwkq8lbK2a8
	 n5jQO6RDvPOa0l/MOCV1SP2n1NVnYarL7hApRS9t7MEN6sheR1n6hSH9ba9I2bwq84
	 Do7vkXGRKamMA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8584F3809A17;
	Fri,  6 Feb 2026 23:09:33 +0000 (UTC)
Subject: Re: [GIT PULL] more hotfixes against 6.19-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260206124341.c7dc8fc55e0f0f9ea68d3951@linux-foundation.org>
References: <20260206124341.c7dc8fc55e0f0f9ea68d3951@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260206124341.c7dc8fc55e0f0f9ea68d3951@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-06-12-37
X-PR-Tracked-Commit-Id: ae9fd76c111bb4a5293c2831a1ad373605251dd6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3dc58c9ce1c5802fec680cb8e95962f1430d5771
Message-Id: <177041937204.1109628.12627294139127684854.pr-tracker-bot@kernel.org>
Date: Fri, 06 Feb 2026 23:09:32 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 6 Feb 2026 12:43:41 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-06-12-37

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3dc58c9ce1c5802fec680cb8e95962f1430d5771

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
