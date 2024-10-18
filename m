Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675338DE5;
	Fri, 18 Oct 2024 02:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729216848; cv=none; b=RBSmE7LGiPoQKyjoZTJBUJU5pCq9pSvGBDrmzmC72USIcuTtZz9i6QcWjxWi8VuDDina5jhKZpDJAzyuTTMW4eK0dth+1arVhb4ChxFUH1v+6rDbT9hdY8aYM4ota6DdJhOtYVP56a5OmAwGomci8iG1rje6EXO3rcwdTQ1lVm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729216848; c=relaxed/simple;
	bh=77juGJg8SGze4IKOuitRBCW0/JBZjitXAvX0VmGHCYw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GqrKDSTuGcF7wpIb7kIHAqEJ+wvldu2+6ypM+VARUtjurF25CfO/7Rw3l9V4hRy4gya+F/h8Jc5sZZWGuarh4gEivqpsBVugctB3G7R2duodjr+4xrtriGnftKBgo4UBcD4MHK7pvBTtDLfXHCvNNzITYF1yKilisK2XzaGCcVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PaG4MKHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaG4MKHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC45C4CEC3;
	Fri, 18 Oct 2024 02:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729216848;
	bh=77juGJg8SGze4IKOuitRBCW0/JBZjitXAvX0VmGHCYw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=PaG4MKHGr5d3WDBSwG22Zx8FuRtdTyWLWUL65Y9az8fWfJEAS2d8UujC7YgGeFikb
	 RMvHDYxdZejJkYTd8P2R8nwbIWBbPyb0yHUJBHxqv0TSvSBtms2r/bTebLyqFDl4fB
	 S6VGfilOHQofU3eVKiZvl2oGXI7eNWLCXy0MjlPPU8+hHyPkTzYnfFiXn3c4MbocrA
	 NG65lpvB2mKhM+/6wA/CO4M4NEiTk+DQ6E7WBi/xOn4b5V4AWQQGkaMP9qTzlkDuRu
	 OYDeUY1+NNZYHm6DGDPBAJbhpcxD2eazC5yIHD9r4V4j5ibzWn0hCfZezi4r81AcJ2
	 E9jYeMy3gG4Ew==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AEF3C3809A8A;
	Fri, 18 Oct 2024 02:00:54 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.12-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241017161027.f7fd7303fd91dbd1e6e18537@linux-foundation.org>
References: <20241017161027.f7fd7303fd91dbd1e6e18537@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20241017161027.f7fd7303fd91dbd1e6e18537@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-17-16-08
X-PR-Tracked-Commit-Id: e993457df65896696e165defa8a468a831d0da1b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4d939780b70592e0f4bc6c397e52e518f8fb7916
Message-Id: <172921685329.2658289.16836366969548092918.pr-tracker-bot@kernel.org>
Date: Fri, 18 Oct 2024 02:00:53 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 17 Oct 2024 16:10:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-17-16-08

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4d939780b70592e0f4bc6c397e52e518f8fb7916

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
