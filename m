Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D262848AD;
	Fri, 30 Jan 2026 00:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769732938; cv=none; b=IxdxeQBmq1J+Tf/kiifKXCobwDCcS3XFeaP9wCRdGWqPxHtdwMngX5WtavomfXYNXANf12RCv/7OxUkW/ki4rJwymbSy/TcSS+IW9ALDizcGyzhGf9gQ5CdTJgDZpTfENN9Yh15Uf+nHri1GG8LhJT//q+qJ94KHG9ZlIkR7YRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769732938; c=relaxed/simple;
	bh=//CDFm1J+twEzc2SPj9olOmFK7Gf+t8RPHxm3wf49W8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=P2G4tpRNcWARXxMqxAdf2658AlZpr6k8RrZMr4lMrZAFmMABfiXdEojcKLPvS/dV6dZxcpQMbkm2FzrSZ06jI2aOhKPv2yLgzfIJUcXNeeASMFc9dpps72j8R2F+XPtlSElEXkkEmkQj3ZfWhwk3f5kEoj9OOSLHr6OokakuLbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pt6yp52i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pt6yp52i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F64C2BC86;
	Fri, 30 Jan 2026 00:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769732938;
	bh=//CDFm1J+twEzc2SPj9olOmFK7Gf+t8RPHxm3wf49W8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pt6yp52iqEXdyfmBgXaMrJyt2LwyGKEsP2eWcCdeaWb8/4QTNFDbkTEVOSQoV+W15
	 HcY1Yz+2YmIHV8FLUg/DQF5dHsbBrY9YyH+9o47sauY+iZVqp7bXUS9a25oByj0Kh6
	 09ucj7bsHchXy9rhOBodCjZIN/z3ZHzyZ/chcUABXyRr4ulbdeTRMlM4BdjH7kzOxX
	 IAXe8Xcd0L8JAMASSXflDYXSzIRIBBdO+JbqXIcmLh3ncOG4Zt/1e3n9+QBYZZ7Rz4
	 scEuKaoP+perBtsgNGcDawNvfHstyI8elLefuocYP13EjYCjrgBBJKxJJKUBsA6EnX
	 oAn4Wau0NkxrQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8BC43380CEDD;
	Fri, 30 Jan 2026 00:28:52 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.19-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260129094513.621310717801e65dce692162@linux-foundation.org>
References: <20260129094513.621310717801e65dce692162@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260129094513.621310717801e65dce692162@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-29-09-41
X-PR-Tracked-Commit-Id: bd58782995a2e6a07fd07255f3cc319f40b131c9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bcb6058a4b4596f12065276faeb9363dc4887ea9
Message-Id: <176973293118.3113374.1837769402149740462.pr-tracker-bot@kernel.org>
Date: Fri, 30 Jan 2026 00:28:51 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 29 Jan 2026 09:45:13 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-29-09-41

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bcb6058a4b4596f12065276faeb9363dc4887ea9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
