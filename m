Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00823A47;
	Sat, 21 Sep 2024 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726933750; cv=none; b=XvMHDWVJ+ukArClzOgnJX2V4wGDCfVQem15uZN1yiPastemxVUIrsZSNdmGrYHJRQiPdQy6Zg9rdWu4TyR52oC+9grcmozXHBEVCeBqFDCRR/qn06IVFEzaUUpEw0o3yWspZUlHNJ6C6D7XezyfJo79XFxYSShAxEn/Y1BEJP8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726933750; c=relaxed/simple;
	bh=HXc0Tls9nHoCIf1q3vluspAzR8vmMPaW2zcdSmVZ3OU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BCB9TA6/MGRNPWu5NKxbiNO7fu26FKOKnqNK3eAEDSnI/zFoT/31zEIjVZ5UxQCxIyZVzA44TFGTtzaGi/gE09elVad7sr0zH8NigqTElSNRUUluWcXcCbEV0UBFsyxftcfaOUxahXQWrGlDWCDfB2P7GJytX8nz3B06X+jGB3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ecp/b/BH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ecp/b/BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D765AC4CEC2;
	Sat, 21 Sep 2024 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726933749;
	bh=HXc0Tls9nHoCIf1q3vluspAzR8vmMPaW2zcdSmVZ3OU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ecp/b/BHFCF1RF5XmJw/2seBjXBlHmvTK1at4gdRXXudjE0NUf9HRXNjNxJqH2XPV
	 +ZykMVBMPd9PUKSp+RjvGV8h+OkGgXhP0TfKSrPXSUm454jy33H0tGFNsRL0xvas0q
	 h/FAc5HhZMDM3PVr8QmvDQy4K9mFo9scFQ77G4WsZ6g8bAaD5nOiY7/XHRC88uTrSK
	 PlfkaYyAdZiL8gSMFyYwin+v3mum/hTeAxIlME6fSjWfGw1A/4lXKbIMv/23ereHHF
	 dSfGAjIzMPGW0YY3wVgP0/sO49iuM4sJXrb46KM0+tlX37frHBXeA05F/MFNiNiRYN
	 FoOWb8eoItGAQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33FDC3806655;
	Sat, 21 Sep 2024 15:49:13 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org>
References: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240920023317.f20c9ecbb2a2f4bf382d831c@linux-foundation.org>
X-PR-Tracked-Remote: https://lkml.kernel.org/r/20240906111900.5fcf345e@canb.auug.org.au include/linux/lsm_hooks.h
X-PR-Tracked-Commit-Id: 684826f8271ad97580b138b9ffd462005e470b99
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 617a814f14b8914271f7a70366d72c6196d17663
Message-Id: <172693375179.2514991.4197021246978312384.pr-tracker-bot@kernel.org>
Date: Sat, 21 Sep 2024 15:49:11 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 20 Sep 2024 02:33:17 -0700:

> https://lkml.kernel.org/r/20240906111900.5fcf345e@canb.auug.org.au include/linux/lsm_hooks.h

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/617a814f14b8914271f7a70366d72c6196d17663

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
