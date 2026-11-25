Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795649472;
	b=U0OOChNJebMaP5E36XfdTm61HVguJuTz1ftZIB/9k1e1Vxgkor2jvv/B1MtMzGssDgDv
	 wMzr35kjXgNL815dY/mrTfsojNOQs7C/3wI+oy4Udqha7727i06niRGiaPVRVDlqv0ORi
	 Ba+s0tLQfFTO1XWWmgznTwGeABZvI/NpC4K/Wi/bnlorkMi+vxCsgNQWgQQIfPk6nLGSK
	 NIbXE/buUL5Zixicg5S83N8frk2qo96BWGVxzsCD1G2gr7sVDnNu4T66eJT0G+VSRl2Zl
	 t8cFBnppRm01YflSO4ZFiHqHogUMQEULCYLGUxkZLcDN0xr5q6OFtAWIRt/2mrveXLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795649472;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=IaQ8G7FsZ0ue/JnonyL9MzaOsIPjfxBpTMXEtTIO4eM=;
	b=cpxfQxQftPB9OGuCC1sjt3I+Ovkji6uBSwJSQzgZ/PVDPe28LynWWckgFvckbXD+Vj1B
	 3GrpDncRs+jtCHIqRJuu8azmHgES576YcsCR4uRTHf57s3/B2cWSBK3w9Qm70SzNKVFIN
	 wuTCeyDrVEMP6SQiGfdgJyIWSJ82KnS+AV//DO8syo77JWNMIUjFSZcIZPQwh887ABWqb
	 Z8GwjGPxf2zMp/Xaa3sWDWS1suWs7jRza74F4f234CrakbksGnrxFUiDJhuu3feIP+hlY
	 efWPtop/lWAWBzqzcBJX2MbUNHHv0xI5TlUePkE3Thody00tE1xdvWxG/OzNk1cY4Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFlEGBr3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3935606A31E;
	Wed, 25 Nov 2026 23:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFlEGBr3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896A61F000CF;
	Wed, 25 Nov 2026 23:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795649472;
	bh=IaQ8G7FsZ0ue/JnonyL9MzaOsIPjfxBpTMXEtTIO4eM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=nFlEGBr3DuFs0gttzSMUwUrwo0VdEDEAH4Lwp/lblcB1ELqPskzCFSaoBcKHQ+VhY
	 tVQbDZ/RREyJenVJAGV+IYXDJDYdMKTG2H2BKsRnQdUpc53CcHB1OhI5ubpm5GTMW9
	 GQURxM2/UEE2s9xTTpA4WLK9bZ0N+B7ML19O3uymOO8yHsvpLWTsY+Mmq+ob8+qjzY
	 qgrNsTrsF18Gb6m1hZKAADv2x3Fx2I6mhLNdTj0vPt2ScL84DJlE4ZxEGSKGYbiK4I
	 p7Mx+Heq8KdTclXd63wjHXQEemH3O921guuo9QCGHzyzjkXsAe6hMke1q4kR8J5KzY
	 GarDrwnscPXKg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7772C3809A29;
	Wed, 25 Nov 2026 23:31:12 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.4-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261124224409.56e65d8ff1f72a1d485450ad@linux-foundation.org>
References: <20261124224409.56e65d8ff1f72a1d485450ad@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261124224409.56e65d8ff1f72a1d485450ad@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-24-22-39
X-PR-Tracked-Commit-Id: 448293c44d86abaff45d6f6919e6056ad97eaa31
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b312ada03437d5874a8dbac6b4a1d479c2af3da9
Message-Id: <179564947119.1391833.9076043211055122022.pr-tracker-bot@kernel.org>
Date: Wed, 25 Nov 2026 23:31:11 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, David Hildenbrand <david@kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Tue, 24 Nov 2026 22:44:09 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-24-22-39

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b312ada03437d5874a8dbac6b4a1d479c2af3da9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
