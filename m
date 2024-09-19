Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B6119DF98;
	Thu, 19 Sep 2024 09:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726739406; cv=none; b=LUOQT8hr78X6jTLQ8P10VcmrKM4OxSlsH4x3T8FYY8AIihZdw6+YkvENcS0tdNBosLB8NAbhh4fmsX1AIWHs9k4pDDqxFpr+jEYo56sLTG7KKR+e4AtCPylhzkrOXpGvY19c4XpEFNQ8SDJ9rLUgU9cj1ErJ7wiEYWwqqg1Y0js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726739406; c=relaxed/simple;
	bh=mlAkWodgBtBpmr0BsLBMZtL/vspc28nvWvm3YXtF+XY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tBO/VofBOLTEqjsxOjvNRS8W8QmCa522nJyvDkh++i8Hr/KmxzcQxahlTpPBRZvHrwHp823xhO9QkeYQWaOX5b1rl/kEpS78+YSf8q8PdaZi83zzlXUDSEaTroj8G+U7A4E4Bw1H/Vob587rARw8XGCklUJ+Ms1GQ+YdMN4FKTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akjh2FGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akjh2FGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583C0C4CECD;
	Thu, 19 Sep 2024 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726739406;
	bh=mlAkWodgBtBpmr0BsLBMZtL/vspc28nvWvm3YXtF+XY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=akjh2FGr3Hmi8cCOloZakwSKoMgKQpgevLCvQrAAaULIDaGw/0zcNBO9amSCmwLjM
	 h3wwi96kgO9BImmHjjibYuY3k2KBcYT3Xm7FXFp2rR3QcdvC0iKwmLp1FWUka3ZxLs
	 RIvmwQt1bu/7uNhGzrvCBUIAH14mlPaRWftOhB/MlsK4xw0Vf4Zgyp9sbxP025cI55
	 sSBZdC9VQ522N4pWSINq/SRIsi9LSLViu78ABY2NACdQlXS7P65VXtcEt6SF/KWKfw
	 yk8z2eqnfq0tCaTd9LkYsSzr/6aAP6O6HI+qVzaYNR98xpoVZNQ/sKwajYL4WRfiiJ
	 VVScDOmmsAReg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 739E73809A81;
	Thu, 19 Sep 2024 09:50:09 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.12-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240919003557.1777673c0f759f9e4ebaa328@linux-foundation.org>
References: <20240919003557.1777673c0f759f9e4ebaa328@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240919003557.1777673c0f759f9e4ebaa328@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-19-00-31
X-PR-Tracked-Commit-Id: 22af8caff7d1ca22a1ff1a554180e53f7a6555af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 839c4f596f898edc424070dc8b517381572f8502
Message-Id: <172673940829.1480217.15889096548946577561.pr-tracker-bot@kernel.org>
Date: Thu, 19 Sep 2024 09:50:08 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 19 Sep 2024 00:35:57 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-19-00-31

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/839c4f596f898edc424070dc8b517381572f8502

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
