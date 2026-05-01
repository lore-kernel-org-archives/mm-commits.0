Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF05307492;
	Fri,  1 May 2026 18:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777661009; cv=none; b=bStiWYQIw8XNzTP7u3l+GXdw7UNgONRY046mVibWS5A0NZD+NEd/+j9A87lutGCrGb59N4rGN8jKTJysbKvl0ovSDYy1Cyqd3Jy/Q5Nv1En3HfaGGEWpfM6H6okPp7d3obsDpbobv8wdrTzQIxxyHJDW+GnzALw5ja8ymKPEp7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777661009; c=relaxed/simple;
	bh=94Oin6CedKLtGQvhO6opbhFX+jLJB3nE7cq5zlxD8N8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eOjgcuoBIFnu9SjjGgN+pfe5wqa9Ha980d70DNyfJkDGBrSP8H4V6FQFKb/y34u/fZIMgYb3BP4u0L6qtyh33zii11ohu+CFOcx/D0KzQA3DMhs7GMkWslZfX+UsCLzlj1mFHzt7apMtkqOxbb+/HQ4QlVnF1zOdnQDKWG7eu2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwJP4jJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwJP4jJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4696C2BCB4;
	Fri,  1 May 2026 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777661009;
	bh=94Oin6CedKLtGQvhO6opbhFX+jLJB3nE7cq5zlxD8N8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OwJP4jJ6BhBFpMZkXjDDuxXjlbIqLNCJORM+17jjpEJ+xU2uB9JY+8BpF5I9Ep97Q
	 mn3bnlu5Oehjg+OesPv4BCjOEkq7W1ZP245kTNR428EqDQDhdhOfziMiLtNdU9KJsx
	 51mtgMyMX/0S1B1FS4XlfQdJbLSx05VduGjhsqUB9OXbwnnfil3+jWZK+bQL2xrUaM
	 kerscP0g02MvmGqIV+QN/BsHnY5Ofx7M4Jo/qMJQIz5G+4Qw9IdPellSK9vs2pCm+v
	 6xcNza8fYTYW6VlkDfPIr+CxSAeUNNRQSO+a166wWtX7YWftAZ7ZwihOOx8K8nRCLC
	 V+z73P1hjBzlg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 6168A380CEE6;
	Fri,  1 May 2026 18:42:44 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260430154158.4739147fd0129804c9e6766a@linux-foundation.org>
References: <20260430154158.4739147fd0129804c9e6766a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260430154158.4739147fd0129804c9e6766a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-30-15-39
X-PR-Tracked-Commit-Id: 99ebc509eef52675ae5bae86aa2a53e15594e4a3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2b4d0215bec0f09bfb872e9a8aa1e1943a42d5e7
Message-Id: <177766096316.3581397.1600456892750829896.pr-tracker-bot@kernel.org>
Date: Fri, 01 May 2026 18:42:43 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 30 Apr 2026 15:41:58 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-30-15-39

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2b4d0215bec0f09bfb872e9a8aa1e1943a42d5e7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
