Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4F82C3250;
	Sat, 13 Dec 2025 09:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765617073; cv=none; b=atLQNw7vhZLmiuojkKtTgwQnToU2dyhztodhpa7ew0dBBjA2F7mRGfjCwTwcC7evm0zM5reMRDrTVlGsrzrgFXn1wBHnyWw5CZf3/AdeQxcaEnOUX73O7JHO2KkEdkx95/tQ2+q0HhrLacIM6bgUqvNsj9vX6EzM3/FuWt+oqm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765617073; c=relaxed/simple;
	bh=n8v7mjktx34ZyZNyQCtUPWSe1lEJnUWvpFY8sC7hqmY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=B90wt+HpkAwTn8OwHFf6JuxX2+f+AwrhWQU9YTVkwkh257EDZluEtQau3WlaUomTxsaoqyLaeUmdI9THpXGAqUCLleuzhrKNcoRQN1AqWENQAHqZWckDDVe2MazRiMx4Mqyxxq20OH7Qso+JY6vZHk4q3Z3+y2NKcezE2aOIJX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pHnRcyyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pHnRcyyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34888C4CEF7;
	Sat, 13 Dec 2025 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765617073;
	bh=n8v7mjktx34ZyZNyQCtUPWSe1lEJnUWvpFY8sC7hqmY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pHnRcyycwk+bmPNuxRFgQMgvOEpNjdeswfjhTHW3QUc7gMijnU8mZZ0kCpj7O/ZUk
	 MMLuMtxRHdWQXjKrakJYCOUHO2B1XdBPf69yTTJIr4d79Az9dk6FGHYYQleeN8FTL3
	 1Lk+foC9JWi0o93KYO+LQMPO6bf0IBPOijcbC554zlOMtF4AeHIlq4ncv7oo9zBdFD
	 OwxqeBweIyIfdTXtJfDSwF6oKruhXjKUtN/zWkjLImJC8nz8wKtKCGmqOY8rExno/G
	 UmnxS7i8gvBOchWeHpO//jjdoLmEFMcS5tJNsIAZ6WEDc+cv/+EyqPYAn9UDSabfSe
	 KiLo61fKaCdeA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B81D380A956;
	Sat, 13 Dec 2025 09:08:07 +0000 (UTC)
Subject: Re: [GIT PULL] additional non-MM updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251211131145.512b1694cf5f46d959cfef76@linux-foundation.org>
References: <20251211131145.512b1694cf5f46d959cfef76@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251211131145.512b1694cf5f46d959cfef76@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-11-11-47
X-PR-Tracked-Commit-Id: 601cc399a01049efa76be8f496541315dc9cf914
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d9c1cfec01cdbf24bd9322ed555713a20422115
Message-Id: <176561688573.2460530.13988646072896057380.pr-tracker-bot@kernel.org>
Date: Sat, 13 Dec 2025 09:08:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 11 Dec 2025 13:11:45 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-11-11-47

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d9c1cfec01cdbf24bd9322ed555713a20422115

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
