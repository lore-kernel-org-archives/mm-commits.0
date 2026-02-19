Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C331E0B86;
	Thu, 19 Feb 2026 07:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771484976; cv=none; b=lfqJt2RayyKj83gnBIfB49sTFjefTwp0Kl/Twtql1AWj9BLp+ViErmLRH8bUptBRFBOcrPgOFeZpPV+8B4m6SwX88zpokEkkChOg1c+6Z3BT8iIdvFwuz3gwqXk5jArbYyMWQ6yDfTV/iToFBa7CQCoL0oCRubLfIM6LATrFhFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771484976; c=relaxed/simple;
	bh=80HNN+Ktu36EddKK6+i7GfuUWmvXE8/CMclew4WJTT8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Dw/9wfk72RHhGX43rSJ78fG5W3QX+Bmh2E6dxjvxw5Yde/ViNcEepM/DDJ4BBOVpPxwwNtaZwLqCCRpPG3CuMP89CobwcK2RjHWkxQy/JZ3LVrFt5nUrqqAzS3B8VPH7ePxHmpPg+vZB6J7kv/cnZj9Qh27fSWbVfYtFtivQW9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3p5Imrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3p5Imrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3184BC4CEF7;
	Thu, 19 Feb 2026 07:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771484976;
	bh=80HNN+Ktu36EddKK6+i7GfuUWmvXE8/CMclew4WJTT8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=p3p5Imrpbw9SgaIbKw17FXLhjanK1O+EEmBslnfZaWz5ff2bfOSq3X1WyhlL7sAA8
	 DUPzVHHJuGUMdlJKSg5oZdp25KRfg43F95bEOCz3Ep4bIowl6QNt6HbttXcTZdbmBX
	 G4/bxPOXy7r/3z8hl6SI9b2NmSyDHHCXZ3yKOTpCdyv5CuwARo9t+LDaXk9XHZIJgz
	 Pu9jd05HvqCwj5OLsh15h01tNX/0XITcGt6it6d5KR/uxt8k+pK+nNpkqKfu/Su1KH
	 wxc9ZIyfIx6OBZzE8WEw9IgP6AuZ3xFcmPe9Fz1iIEjOQmbh5UqatsapsjdoLBDxF4
	 Vygc4lFzwU4GA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 85261380CEE2;
	Thu, 19 Feb 2026 07:09:28 +0000 (UTC)
Subject: Re: [GIT PULL] additional non-MM updates for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260218200029.835bc4072e58269d27599e62@linux-foundation.org>
References: <20260218200029.835bc4072e58269d27599e62@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260218200029.835bc4072e58269d27599e62@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-18-19-56
X-PR-Tracked-Commit-Id: 90627a1e08e602b8b7bea970d7d5007626be7527
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2b7a25df823dc7d8f56f8ce7c2d2dac391cea9c2
Message-Id: <177148496708.1707664.6851903123215314911.pr-tracker-bot@kernel.org>
Date: Thu, 19 Feb 2026 07:09:27 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 18 Feb 2026 20:00:29 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-18-19-56

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2b7a25df823dc7d8f56f8ce7c2d2dac391cea9c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
