Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE6B288C17;
	Wed, 13 Aug 2025 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755099728; cv=none; b=OwxSsmnj4cgrF8qzz6f/c7VarqXsvkCRQNUiMyGgoqBChdEE6hw6B8M9K/aOClo3uMROJsuq/X2cx5FFwJAJ3pzZzaGtsMo6zA+l9PxQWpifhfL0H6uHlJFRdwfEAf5Dc2rU17r7PsoOkdfC4ppJ4iCipBoT/Gs2bniYOwlZPCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755099728; c=relaxed/simple;
	bh=KoILjMIrf0f+axn90tPHLT7lB7OEvJPVViVyLgwUa9I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=MQMaI3V6Skx9kdS5Hgu1BVSJ8BUAxL+GdDA8R2Q1M+ONO2MyqrbeXdBNseK6qhQrdd0geC9eaWwY7QkCrm7F6T6HTdEicIhTPdP8qUZuI19ajGDZjgqJ4qBc1B5CIK45RjJRpLpxzwyxSIDZjBKyYboxcNoADkby0IkVeTlxA2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mm3RA4Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mm3RA4Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D34CC4CEEB;
	Wed, 13 Aug 2025 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755099728;
	bh=KoILjMIrf0f+axn90tPHLT7lB7OEvJPVViVyLgwUa9I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mm3RA4CyMDL3VYfRduA5zbpAYDZlAU63kivBJOaDKlbVMV0TYNHO/79OQVXJm3yi7
	 c+tNZ3BcdM0yYMUxURFP1j9wW9hoY9adbX0Kfw6uSnEfT1PxAIum779R9lgTCkL2t2
	 LrA0PReHLzygBTade+WMvs7y2A4yy9443u0qC2aOACHo8XZRgnbgHvl30Xx01MgjAV
	 puAX8mnOzPeQ4q8ckgNSnzzIC4bLAY963vsyGFPLcR88jeOZMO95NDZoRINb89EL08
	 8DQJdEGrSuj3JK8d3/VvW/xmsxsjmHuUl8ghWEBGrBBChueDixfyP6DrsRo3pjmvFo
	 7A3KuwNdGTUTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 044A139D0C33;
	Wed, 13 Aug 2025 15:42:21 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250812205256.7782e2e483a8b12774e65dcd@linux-foundation.org>
References: <20250812205256.7782e2e483a8b12774e65dcd@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250812205256.7782e2e483a8b12774e65dcd@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-12-20-50
X-PR-Tracked-Commit-Id: c0e1b774f68bdbea1618e356e30672c7f1e32509
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 91325f31afc1026de28665cf1a7b6e157fa4d39d
Message-Id: <175509973969.3638460.11919114009221754348.pr-tracker-bot@kernel.org>
Date: Wed, 13 Aug 2025 15:42:19 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 12 Aug 2025 20:52:56 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-12-20-50

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/91325f31afc1026de28665cf1a7b6e157fa4d39d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
