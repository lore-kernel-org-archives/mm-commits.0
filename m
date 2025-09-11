Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B073451BE;
	Thu, 11 Sep 2025 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757602781; cv=none; b=Uxj4qIiho/wecsNbB2ZYop345e6hzNrRWnYQ2/QqxhbqbVtbGyEOOu4TeNJMiLrz9FGjVhMWlyf64z374FCztpe3k3ILdvQS17DOoAytF1YghMp6x2f0AUea1GSZQqevekSDZIuffohx/DCTT2WkIwBfIVvqu+fZR0IL7C/Tan8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757602781; c=relaxed/simple;
	bh=d9nAFXGJzmeWzLCo0MGgmQRlh5gWyfX0TrCYQC8mEIk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jdsH6fzsf5Xi1ztGPFZHKELnoFQNy0CLyGQJnoQtPpQ97CN66KaELM0hc/OCO9KTryLWHCETjjFD93FK93XJwq3MrN0fNw5G/ldwsUfgG8QcNlBd5NtOw4gTQAV8WPATQfg+AHLuEIkApdDKqhcTxaTzVYZDNYFFLpcK+zCPm+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AERr1Yeu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AERr1Yeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1B0C4CEF0;
	Thu, 11 Sep 2025 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757602780;
	bh=d9nAFXGJzmeWzLCo0MGgmQRlh5gWyfX0TrCYQC8mEIk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AERr1Yeum+bWPl8xQvvh75i/6VVOcutsllTdjwjlg4aS+vudiUiH2/kvyXmRlQO0u
	 gaq+x+uTYpwSE0FoNrI8l7wffqnFdr/b8yyuNK9xco1QBW9NyHLpQ68GX/HOq7XZje
	 XSabv07yNgkvPk+NEAI8z/V/BjdgWk2AvnvMapqhDF6cqZWOv0npI12JBXWRl0OSfU
	 R0Oo3cAHjfj+9L5+OBy2b6vG+C/MWtqWgXc2/EbebUOhB8xlFnF9yQpSXaEtLGMoT4
	 lZW9+5jHYqPZ1Wpn9xdzQPZtjr3u2dstolJgSTRYufxmmBvo9z5QALRzWpejFfknlO
	 okjpx496nP/XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF8A383BF69;
	Thu, 11 Sep 2025 14:59:44 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250910200250.b110da062c9561aa092c479f@linux-foundation.org>
References: <20250910200250.b110da062c9561aa092c479f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250910200250.b110da062c9561aa092c479f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-10-20-00
X-PR-Tracked-Commit-Id: a68172d95c2845d2b5455b072b4ff51ba32650e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4f553c1e2c7b81e957b5463bd7efad2465a586f8
Message-Id: <175760278335.2208976.10071544460985449453.pr-tracker-bot@kernel.org>
Date: Thu, 11 Sep 2025 14:59:43 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 10 Sep 2025 20:02:50 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-10-20-00

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4f553c1e2c7b81e957b5463bd7efad2465a586f8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
