Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E4A364EAB;
	Fri, 21 Aug 2026 03:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787281876; cv=none; b=SSrKeGMJJh4NrV6IddidNmowIosJ5Ry+CA6T8ciFY3h01EfNKvqlMOfKhZoGdgvZsfeyjp+eC7cl76AdhpXpGJegZqlX24mUpoMqSoxxf/Xqpas5GHW0EeaP/YZgg04V/DQBTXhpB1kd3KQQSyNTT2p4QdW2f0QOC+vtNxh0tiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787281876; c=relaxed/simple;
	bh=HSgZPRMEmQzpYUy5JvYYZwORSkCsN36OJij5LajhBg8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OhKMct3dOtulswlPTYMYKHNlQW33joTMfPkQGJmTaQcKJFcGwJ1mGXCGo6+Q9GzbmAAjmh/EXYi4J6Ki2u99E5XXdmAWh+xmN/ISa+fr12mmbOGklugAyb+AksNqmmGz0kIPmURES+CAwGeHXJ9mMnAdIADMh/z1wWIIUxDIu1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edLACQGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edLACQGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E6B1F00ACA;
	Fri, 21 Aug 2026 03:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787281870;
	bh=huI46asYGhW1cU6sHzdmW2xNyrPSFaE/MtnTwoNiwpU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=edLACQGyMXerZN29nMXS29tIJCXltY/wgT5xJgm+kgrPlrGWFhNE+VBTsPFJrOnCM
	 c2Xt2CnvEDMWV/RBpVkSMKGui2uHyNKYus8jltssk1LPaviiRM4lRLxlyZ5DBexOHM
	 dAphSD5Kv2dfBXIgTYoTeK9/BRL+Kdsh74beBKPNdZgwtDmTNVSCWwc9LZT956c0ie
	 DhFD1OvvfwYPA2AXcKhV3XBFb/qRiaX3liOOzm3KYqqfbySZXqYQp4KCpitAuNyP2G
	 o0EJMU8tDK0D2F7/E9dbLCSzOdb8vKOM5KfT7YhTxqDuNEujpaVUPwJpHHTgpWsL2A
	 G9cq/+n5qt+XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D4F2E3924A4D;
	Fri, 21 Aug 2026 03:10:21 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260819213548.4160b501de0b9ab41029cfcf@linux-foundation.org>
References: <20260819213548.4160b501de0b9ab41029cfcf@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260819213548.4160b501de0b9ab41029cfcf@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-19-21-33
X-PR-Tracked-Commit-Id: aedf2efd18977e0cef7eb963166e2b1fcc0aa321
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8dbbc7e188949b6e1f6be4e82a44dd1d8b1d6c8b
Message-Id: <178728182060.600189.10570474833709100570.pr-tracker-bot@kernel.org>
Date: Fri, 21 Aug 2026 03:10:20 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 19 Aug 2026 21:35:48 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-08-19-21-33

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8dbbc7e188949b6e1f6be4e82a44dd1d8b1d6c8b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
