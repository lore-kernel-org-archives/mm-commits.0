Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13063A48CE;
	Fri,  7 Aug 2026 04:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786075711; cv=none; b=hbtpsSp4Gfwg6p1D7JvoydVKc2OGlNq0GaAOBIIwgN2Sya2n6vJYzarguHJede+4Ba7Ry7gfyidFgp/By+Om/7ctgCbAbJ4jEtSkFJ6v+5xkb0ERrPHccgeR5yrQJGLrbmh/doHzhMPYUasAficyv8DtChlAa6GXvLEPWXC+q6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786075711; c=relaxed/simple;
	bh=qAYiYWRxCXnLbP6AHGXOR7KaxuqxcKZqFEPz25jjWt0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ju7pKsYQSW4LJ3d9HW7P4nlGD/V1gdGuyVGj61e8r0Jz5EiR7HYeXXNDsG2wKzx7yvHlnzdvmLec/BJcamoOOtFloU3tl/0d4IMfDNVSi+tyj+MPDNOg0DL0MiNHwSFPCPLi3nw3lkiA/LfCGkAfmDICgpiVDrUAhgVA3LTQUF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mI0oX2dx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mI0oX2dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C381F000E9;
	Fri,  7 Aug 2026 04:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786075709;
	bh=e8s2N54zY/bbELSt5BbVGt6jOlG3by3mfpiE4yKygt0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=mI0oX2dxshiVeL+d0LriJyMtoIlMmlgAPuxmvYxxh3psR7/qMsBNBggn4/fX//JlI
	 Zfb+TIulVeM+6EageGtJ903OYd3r4UUoDrdf6VxsOOfBi2xlB5UI/FbsmEOZ/pEMCq
	 fRok3mLFclbK4JEC62tZX8O2eEmjVciNcvy9jDRI+0xDsRPRXaqO+66evD/2nRTtPW
	 VqYVAEVW6UALZbLZRPJb860z/cz14kwKsuGmX25kK+rJo7UU4zetr1nbIz+VvVGJFD
	 9UYFVwE+uG/YOUoyAHiWHFEl+3vvkRGiI8e4rNox8fCXtkFHV8wKA/QkoeZP6pV9eE
	 RH2JCIWSQUW7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BD5380A95E;
	Fri,  7 Aug 2026 04:07:49 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.2-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260806184655.1e970cdcb799e433d91cb8fa@linux-foundation.org>
References: <20260806184655.1e970cdcb799e433d91cb8fa@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260806184655.1e970cdcb799e433d91cb8fa@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-06-18-44
X-PR-Tracked-Commit-Id: 1ec0e6b6f7321feb769f50d2f094a0aa6c2eda63
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f9a2394a23482bfd330911e9c8295b71724feacd
Message-Id: <178607566852.1595133.5054272560908207098.pr-tracker-bot@kernel.org>
Date: Fri, 07 Aug 2026 04:07:48 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 6 Aug 2026 18:46:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-06-18-44

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f9a2394a23482bfd330911e9c8295b71724feacd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
