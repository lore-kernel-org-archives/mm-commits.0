Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCD21A262D;
	Sat,  7 Jun 2025 05:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749273035; cv=none; b=mm5vaK5fGrY0dEfVrTzbdQKErSHf7iEimL61r7Yt2+cxKLc6ge7HnEnUmxRe4yyawy3dK1ldBix2tZpRQwXBkzTbxpKFNnzAdUQRpHbBuvCUgYV03rKXr4Sg3rStZ42FxghYOQYrSgmLNOB5A2aFA9qlWRLL2+RXcsmVJqJKDhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749273035; c=relaxed/simple;
	bh=EUPO/IQ1QvK0QU9RR0jmg6HiQju9jnqRGFdEOhNo2Fs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DlEAhCLh2LV193a/Ut1CdCjbeIB/k4BwrvBEsuf41SkSS3NmQThYtX7kBRys17J2TDc+ACfZdS5hUdGf1+sRjgcAUbyJBKTEzNl7XPCFF+aRyT7xd1rVLQL6hRmK8O+Wp6xVAuUA/FUj6TCMBbzUaHLBQ6/lOX2VfrKKsmAgFUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=swI33GI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="swI33GI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B9FC4CEF0;
	Sat,  7 Jun 2025 05:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749273035;
	bh=EUPO/IQ1QvK0QU9RR0jmg6HiQju9jnqRGFdEOhNo2Fs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=swI33GI80gEiG9AYKV5lnlmMx+mJMOLzi0v6HHI6TR9Pwfcc4hkrSAnQ0L2Rr/Ae2
	 nY0HEkdKSsvED+jOKeSNoeWiCF4ihw46+OkD+cdz/y7QI78vlD9Ry29WvXs2pmgTr3
	 hzpa7hdM8wCTPyp3cQFHJkS6PGxq4G5f6cK7Rz+lVGGcj7KCPrGd+o/ynotPXxMFwI
	 ZCWlM8qsxyoDuOS/gONHAIDWcCIGjv+8N2K/Vc9Gha/394rgrJXHtNnUeXNg+6iWFQ
	 8k1f4dSN/cP4hUgGXXXIwqsyywA1etTODrjLeBic39fVItvtmOSMK8lbBt/sdPpRAJ
	 6xvrB+JKnc+sQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB44D3806649;
	Sat,  7 Jun 2025 05:11:07 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250606161208.2d18790220a7c75ec18b361b@linux-foundation.org>
References: <20250606161208.2d18790220a7c75ec18b361b@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250606161208.2d18790220a7c75ec18b361b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-06-16-02
X-PR-Tracked-Commit-Id: 2da20fd904f87f7bb31b79719bc3dda4093f8cdb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3c82f618a9c2b764b7651afe16594ffeb50ade9
Message-Id: <174927306679.4099510.13690853323707861630.pr-tracker-bot@kernel.org>
Date: Sat, 07 Jun 2025 05:11:06 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 6 Jun 2025 16:12:08 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-06-06-16-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3c82f618a9c2b764b7651afe16594ffeb50ade9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
