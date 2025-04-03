Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE7D265615;
	Thu,  3 Apr 2025 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743708802; cv=none; b=Wn+t2IrBFZOuuDra6ozVasD1/sODGThuiA0roqOzVvQ0v3ABem3HNb3YWUH879y0Y7SZmOtGy3jhek8e+caeG9BniPSz3cydD7/8wV74IdXInvZTB3RzQoxr1tX6BbEletOzcJ1lCmXTb6dyN7Dbgyp1cYg39rJ1cwSpiFTVd/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743708802; c=relaxed/simple;
	bh=8Jb7nDyisr/dfq8PbK7EA1BkjPLOMEx/zwT7qHla3c8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LyvC/wXfDsEtcjwFhfEHJfIkGOrk7zOo8CnK5tMw2RQf7bpLW4TwAwAIfFCUJfzh5Cs98dbaDEefm587tSv7Cd5vbBpFjeXMLQQlaPXF44P8usDlk57L53uBVM+iMaGRk9mlK6n6pkWbqznZeLVcod220acLiJt1/0x5ikr03RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V12+HX0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V12+HX0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD803C4CEE8;
	Thu,  3 Apr 2025 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743708801;
	bh=8Jb7nDyisr/dfq8PbK7EA1BkjPLOMEx/zwT7qHla3c8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=V12+HX0okb3FpknKnZ+09oiieW2ULjrPSf/ITsT5wqlTzEwkYIObRdNL9at+yPfCJ
	 OXYlUjv1whoRsztTz8b00eMoYrFywuL74eOAHv6zZHaXAwVdBtXaiLlPb1SRTM9kEx
	 QNs9LGvx/EMx9o5iV/aLtL8MLcWFzce/j/vDYgSuooVF+a1gArwWzx83MXG62qtJZd
	 CDFTroDp1RBF1WcalL8FSH2uIpGJ3XF4k2/luMLAcUx+TqD2a59wWEtsBn7zilPUtP
	 lrObDjJmZLtyPVnnvywSB7xtF2Wbmd02pEhSrkWJiZosCmu6Vwwp7YAipVXo4sFrGZ
	 nGPPCtWuZZ2MA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD5D380664C;
	Thu,  3 Apr 2025 19:33:59 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250402221524.20f50c3af6f51bafc2dd618d@linux-foundation.org>
References: <20250402221524.20f50c3af6f51bafc2dd618d@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250402221524.20f50c3af6f51bafc2dd618d@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-02-21-57
X-PR-Tracked-Commit-Id: c11bcbc0a517acf69282c8225059b2a8ac5fe628
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 204e9a18f1b9685476d6480d4f26d5d7f7e2d505
Message-Id: <174370883847.2657822.5388814719781543575.pr-tracker-bot@kernel.org>
Date: Thu, 03 Apr 2025 19:33:58 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 2 Apr 2025 22:15:24 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-02-21-57

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/204e9a18f1b9685476d6480d4f26d5d7f7e2d505

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
