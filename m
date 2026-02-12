Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F047532C925;
	Thu, 12 Feb 2026 21:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770930022; cv=none; b=R4CeYr88SxkxQdSgd8Jm6zaLkEiriUPmSzYYbCRONsSxU/kwevfzTqayEpm18g593yPTMBb2I9e3Z/56u5JBxLPT6hUM6frTQw013lKRHUEBOc1VCavEjkaVer26BN7TpVOdfz0hGz4GIT+YHIVbETHQdw4nMJeJuTWigu0oVog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770930022; c=relaxed/simple;
	bh=V64I1236CIfrgUaqmjRGFTjLIvjPIpIm0axC06vlKX8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=AmbVLWzMdJCaw+Z0igZN4HwBshtXRMZpLYC0qjL37doh9lCmlM+NcM6+hzL5QduWgiC/Nu4Q0Q7h4SINS/OR39qOyuk6iqKn9jTKnel75swuhzmUKSH64Bamo0Ek0mhGz7AwqjwsiKcaf9PZvIdeoAzqMPE+bb9wBMb3PBSzepU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFKV2XFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFKV2XFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26FFC19421;
	Thu, 12 Feb 2026 21:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770930021;
	bh=V64I1236CIfrgUaqmjRGFTjLIvjPIpIm0axC06vlKX8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=eFKV2XFjiY676JVAmRjorHshK1QZHX9irf2LGJkHXf731tGNGMAuC/sKlCn5Jvh6e
	 yFx/tRht1y9cRmRTKNz60K5kfHgkRuWUwWqQUvEflGTs1NvXEC1m8qXzlr5at+Gkgq
	 v+iBYFCNa6jlMZ/t0ajB5+2GUW+tn7sE5TMae7fPrmUNQUge26uUE0L3gzpGpvmnB1
	 08OQvZZo9YnSUMBwooaD5500E/VzlyvrDHMHkj8qYkAz9Ais/zS0eyDXqtEztl4K1l
	 T9OePkOBWSqb3A2jDHPwQvh6jUB+LkHtJEx0UW2MWdSK5jhgX/M3jziv31Y7ci0o1L
	 NRTNJNj4rHxDg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5FC9A3800347;
	Thu, 12 Feb 2026 21:00:17 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
References: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-12-10-48
X-PR-Tracked-Commit-Id: 0dddf20b4fd4afd59767acc144ad4da60259f21f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 136114e0abf03005e182d75761ab694648e6d388
Message-Id: <177093001626.1706748.10510676231178541216.pr-tracker-bot@kernel.org>
Date: Thu, 12 Feb 2026 21:00:16 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, mm-commits@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 12 Feb 2026 10:49:56 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-12-10-48

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/136114e0abf03005e182d75761ab694648e6d388

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
