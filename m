Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4002D32695F;
	Thu, 12 Feb 2026 21:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770930020; cv=none; b=SfaHHKzznY5ATd40wQ5QGOnkDUpq7Ld4xfVw0iopLMunUiUxPSCPhkR+Bn3Yv88dYoLke0+WuojSYV2Evy0olNKuglUW8/0QcQ9vkmcE/BMuE5pgEIO/1LGAiBsnjWi+0gejCqYhjQ3fbx2cgfhLWlJzPc+ik0w7udPzgPSeCSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770930020; c=relaxed/simple;
	bh=DGZLLIs2weEORyQ83w6L0bf66JmLwadJuIns9tYBheA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JRzrwMZ7MVZjGPte2nvI+gUS/gCKuWD3Zak203EqjAZT4fBk4K7efOthCn2XztS42brg0Ml9cPMzf8u8F58Fdp2mJDLhtNvpr1Z/T8UcFGtLbbMxsK2LkR7EMug9a9c47UCN9Dq/s397ne1ZIpF1qf8SQyXU8+0e3G69w2FiLJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYzn7vSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYzn7vSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23581C19424;
	Thu, 12 Feb 2026 21:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770930020;
	bh=DGZLLIs2weEORyQ83w6L0bf66JmLwadJuIns9tYBheA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tYzn7vSUMw2+xoccUN9IKE952g+0X+p7atAMYuTYzvn1pZ/b72qzC7t/Yc/qJlXA5
	 DQgGMDweD/0yKXZMPoSfd5kCgoS6JhMksQrowyH6lNdi73jjO/F0tmLbPd/pBP9547
	 fGCxyPWu0ldZHtIRJ2rgXrYk1plcErur5WsEHPtnef8zP5WDq/nkPIKe8DqP8IqtlQ
	 11kfcejQFN6YH2XHlx91KaIME+xJlJD8VLlmNW66COTgg0/7fn9QBKbv0l2xnAKGrw
	 ZqwiuHiFTDvL4zbTPoeFC/QHDq2O6vEUSZ29aKtF0qabSY+0BpGfmyfEm9bBhgViil
	 aLnR0sEb0ec7w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id A0A6E3800347;
	Thu, 12 Feb 2026 21:00:15 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
References: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-02-11-19-22
X-PR-Tracked-Commit-Id: fb4ddf2085115ed28dedc427d9491707b476bbfe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4cff5c05e076d2ee4e34122aa956b84a2eaac587
Message-Id: <177093001447.1706748.1376321274128551760.pr-tracker-bot@kernel.org>
Date: Thu, 12 Feb 2026 21:00:14 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 11 Feb 2026 19:23:51 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-02-11-19-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4cff5c05e076d2ee4e34122aa956b84a2eaac587

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
