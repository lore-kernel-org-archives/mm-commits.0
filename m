Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70293259C98;
	Sat,  7 Jun 2025 05:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749273037; cv=none; b=YZqHC9xPOlK6W7D6qz+G4mY51nIw7Paq65FPt0P7Ov9STn3SCsz/1yRXU3kZqPl6XVKQaxzy46dfgLqibQ1GvpiAfyBn8EbZs85UqAfHClJRMQRXqbu8oiVb9xOH8VRxnFIzKPY6PAY8ZT02WcfferlG9owBRK1S0AkyAUy4x48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749273037; c=relaxed/simple;
	bh=j+0OZyLMRkX4Y8/WGxY1L/1aKUefvrtC32F+GWIY++k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SxnljP/4im9Jd5eBwuCfghmOXxSnYvTjpN99fckC+quhV3Ga70SJPneLuAn+fMBzgJjQrmkVvygvw3wJ1jEQZ7j1t3kbRbL/dFf1BheV1UtBVQkWGTn2BxGiW55PbXaYhXqsLVtpyqIjc2LItczSKdTu2wx/qoblEkHlHQokEws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7wT+JXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7wT+JXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52206C4CEF2;
	Sat,  7 Jun 2025 05:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749273037;
	bh=j+0OZyLMRkX4Y8/WGxY1L/1aKUefvrtC32F+GWIY++k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=d7wT+JXrOGsaGi0rUjoCI2FBWzeSN0cu4BozCGvYk0cSpj/bAf5MzuqD8ng8DlGT/
	 OvGU5jLI4fXAol3ofujBPU/KXq9spFQCUuJPmFkKbL7Kxx9gvlzgwcKTCS87AoRoCr
	 ZJnrBiuf7FmrmMEFQpdT8kPdCuLzFtpr8h+i1RUU5C5aRmLe+Dv9besLtP0RdNMeEv
	 bVGkIgxbSn2LmpZ90fD7n7YmYtxO42CAKdB2QJMnC+9+ly/5xkFFn0tPhDa3nsn8er
	 xOs0Ve90sjS5MzLIjhX7KrCaf4k9hkOwEh9bWD1pHxurn1unD5voMmHurqCdBtlDbb
	 dfqqjtfEca+sw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0D47938111CC;
	Sat,  7 Jun 2025 05:11:10 +0000 (UTC)
Subject: Re: [GIT PULL] Final MM updates for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250606161231.c9e10415b320f8cbc7006d26@linux-foundation.org>
References: <20250606161231.c9e10415b320f8cbc7006d26@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250606161231.c9e10415b320f8cbc7006d26@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-06-06-16-09
X-PR-Tracked-Commit-Id: efe99fabeb11b030c89a7dc5a5e7a7558d0dc7ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bdc7f8c5adad50dad2ec762e317f8b212f5782ac
Message-Id: <174927306882.4099510.9632313349738457384.pr-tracker-bot@kernel.org>
Date: Sat, 07 Jun 2025 05:11:08 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 6 Jun 2025 16:12:31 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-06-06-16-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bdc7f8c5adad50dad2ec762e317f8b212f5782ac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
