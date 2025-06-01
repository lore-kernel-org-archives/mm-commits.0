Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B197D35959;
	Sun,  1 Jun 2025 02:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748746017; cv=none; b=YP+nIkvgOUhWWGuoTleTDywTMzyddKmKm2wrYIGqh+lVLvQQJly7yFm7ffGZxnHPFh6IE3fVm9xVEnzZGXFGJFbcGRkxx3GGnyzIeeqRH+0sESYpXOfcHABqyyz9k3+UfoWE9BwJh4bKvTjnZqil7GQOxR/qeCDLSTlY9Lnz3rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748746017; c=relaxed/simple;
	bh=/S1YfGPF046tB3OYAu5D3cEqn3qJhWcHbcbqG6PN6E4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=b8Q+geKZG5Kf+BhfiupEdM8gb2eTh6kDlTGvqUvwiKvU7dBll+ABnJGlC+GQS26UFSOjgN4kujzUNJ+tpGHtcCUokk61IYIIfEELYb5sdSKXRNf0FoUHhGEv/lizkE89og4ir4sOYpgqe0UoT6XTFAywbaWJbcAjrVtOk2c8CHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqSVcal7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqSVcal7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C64C4CEEF;
	Sun,  1 Jun 2025 02:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748746017;
	bh=/S1YfGPF046tB3OYAu5D3cEqn3qJhWcHbcbqG6PN6E4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=qqSVcal7N30T+Tyvg4WmxuJ5GWdaIU9WT81QTBibsHLXhXwhBLwzAfpEraOvCfFV0
	 g44BpXX8WAMSb7tX7cM8hkwaAXNgmv3Pmxus6//LWpwy/LX3d3qgl+zwDaKBb99uvE
	 FOvV8Zd7RP263qEMr7eHd1WayV5VvDIcE5HiTGVZb5SnY2/J42wOJtlk7fx/nqMycP
	 pJ7sTKrzt1MeTjf4o70lIiizOT3Q9uAFOTb64PnxYP0FH674EzSha/wRo2+KGqmzVq
	 QpvCvl6sWoOH9h/Ez84D74E4d2eE7rkHVprpmU/KYiAXubb9JFGgTbLYoKCxQEdOsQ
	 pIX2noxIE+jOQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C41380AAD0;
	Sun,  1 Jun 2025 02:47:31 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250531153157.8fd9b708ae4009f5dbe81a9e@linux-foundation.org>
References: <20250531153157.8fd9b708ae4009f5dbe81a9e@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250531153157.8fd9b708ae4009f5dbe81a9e@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-05-31-15-28
X-PR-Tracked-Commit-Id: 375700bab5b150e876e42d894a9a7470881f8a61
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7d4e49a77d9930c69751b9192448fda6ff9100f1
Message-Id: <174874605004.296823.4983054967405940250.pr-tracker-bot@kernel.org>
Date: Sun, 01 Jun 2025 02:47:30 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 31 May 2025 15:31:57 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-05-31-15-28

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7d4e49a77d9930c69751b9192448fda6ff9100f1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
