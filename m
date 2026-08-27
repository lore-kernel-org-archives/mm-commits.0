Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478D04854EF;
	Thu, 27 Aug 2026 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787850559; cv=none; b=A7Kk/AMAcqKvxL9TYWa/tSfi8vmity0XerJlT7KW8mhfuPyowihkMcyO3Ny+yapdmACqizbqw7/MQCYiwYbShQyopU7A9IP3heZO03Fs05SU5XSXKNBhvOvkGXjey+OhFMEX/ayfZ/JsStal4bgqFaXyYG79FqJn6rkTHE2qfX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787850559; c=relaxed/simple;
	bh=ENSCz2PGcJTimwlpnBspYAGijaGtdVkCkzbyhQryWvU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=t07LXsO9gn9b6K4tehp9jJmla4uIW4V70IUGz8OnrvnQnaEIzLE3k76vSWXxbtU+1XfDPvPUs53KybBq4otqfH2tTvyCnquyJf1XuX9vf/mGMC8BlTrd3ytTTuQVMUWvnVj3IxJjg8zPVkaq3fI3Z+skmW8Z6FGtXJeBEbnCPZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlqsaUiu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlqsaUiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1689D1F000E9;
	Thu, 27 Aug 2026 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787850558;
	bh=2+TtOTWAn9+K8+57S9u3rhptl8PsUZnys96Z6mm5eEk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=IlqsaUiubPVhLE71yfQCZwtFSXNDceRztFia7OehE3IagvK7OxB6h7BkRC0tOA5Ti
	 LfqnUwyepxWQBy/uIYgOigX7i/ZBYBTXxW9dVqbyYE//UIV/WGvoevPVY6mvIGot59
	 qMwt4OPBLZ/C13fxbOtsqXJ9eT3DbdtwHjN6hSY4lSixfX8G3lPOb91rf0YsTT6B7R
	 UoxVDmb0eda/oqu+3ivLBLmjN/SykmoocsTO5CejYYlwsJqrosNcp4W0tYbwlvIt/W
	 etld41JqN87WlrW/hWoMSNqyDNhLbGtY6V3hrFTrSXvsXunycy/fPkit1Mw67r1gBr
	 du+FGoVRqOrTA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C203809A89;
	Thu, 27 Aug 2026 17:08:24 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260826152330.9cdd482b43726942d6c149cb@linux-foundation.org>
References: <20260826152330.9cdd482b43726942d6c149cb@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260826152330.9cdd482b43726942d6c149cb@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-08-26-15-22
X-PR-Tracked-Commit-Id: 0685630fdccb62dcb0e3f44525a40578da5f6dc8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 18fbf5151d2c0bfe433c7428eef03cabf5fdb2fa
Message-Id: <178785050350.1753754.11441521265176590388.pr-tracker-bot@kernel.org>
Date: Thu, 27 Aug 2026 17:08:23 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 26 Aug 2026 15:23:30 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-08-26-15-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/18fbf5151d2c0bfe433c7428eef03cabf5fdb2fa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
