Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA38121D581;
	Tue,  1 Apr 2025 18:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743532607; cv=none; b=mKy8QrFTaAenP8dzt9yRcP7WBx5Pt/mJb8WcqVpjCaAbh4ucR2flTefCp9qKYkH5m7oxagl2u4ZoxeUMIt8EganmbxnSXbLgBtrCKLQJptVNNfFFZAMqDfykK4sW97FXHOjEpeDpAAAu1vk0Ygy13zC4pXFNVddPJoeSmQw8ZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743532607; c=relaxed/simple;
	bh=1hqPNIPx0lIS+PbpsVIx5acJOC3su3eJ32hL4a+2kOc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=oSsDghWI4/z6YsrtvxA0uodWf9xb8aP3VVKuVL2ic87d+lJM+i1Wzt4Chrmgm5VajmKmi/zRtjEp0ty/jMfznHHY1MWhxDG59+KCs30Ox5z+esScM6m7bdf/WiYfq+3H50uP8wu4RvnczF0DHmsEIJf9huo6tcCsSPdlw2IAXXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ubuu+i33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ubuu+i33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A779C4CEE4;
	Tue,  1 Apr 2025 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743532607;
	bh=1hqPNIPx0lIS+PbpsVIx5acJOC3su3eJ32hL4a+2kOc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ubuu+i33G7CcxDOnoxIa68mqqhAaib+WrNJWMGwTrTzOkzBUiePeakiekrT1WMZsO
	 csd4xFNONXjqDrzJul3ALhd2eAOpsMufrBBTWfLhAH0I96E4OHPw5iZLbmAki3KIcx
	 SBAce/HE/7ff1FtXDhWXmhDCAnyHRyCTGwB7Levy9tRAQechvZRnnr0QZDTZgDFenb
	 yLlEcfI2PzoSnOejcEmgGxzV0RRVwyRwIuaIrMmvV0J7jaNILwzFqlw1Omh5dRou2H
	 Xlpi7oGFeECs6kzpO4oxkRngWD5mSqP06LqT1YbYM33h+HFK9F23/eQUD6KJUlFoEj
	 bdZdEKZMXVOYA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F70380AA66;
	Tue,  1 Apr 2025 18:37:25 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250330182612.add2bb30fef22ca5bc3e2755@linux-foundation.org>
References: <20250330182612.add2bb30fef22ca5bc3e2755@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250330182612.add2bb30fef22ca5bc3e2755@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-03-30-18-23
X-PR-Tracked-Commit-Id: 434333dd3f66f9d1ad387dabd2a565182a823f31
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d6b02199cde4b9cb99b311eeab1cdbe23165082c
Message-Id: <174353264369.872225.13170817086980092339.pr-tracker-bot@kernel.org>
Date: Tue, 01 Apr 2025 18:37:23 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 30 Mar 2025 18:26:12 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-03-30-18-23

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d6b02199cde4b9cb99b311eeab1cdbe23165082c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
