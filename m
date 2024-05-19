Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B052F26AEC;
	Sun, 19 May 2024 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716137380; cv=none; b=pGLDk8+zB9aGtN2suqOq5VKmqlBXT2Dky1nbhJ9l6pSi0f2PEwcv/iq94agrtPI8PVgHVkZu+6PNYVvKkMpRxFi9WDIRRRs0eUivCZJKAwHYynkdzPlJ70CMOE9ZI5CiDl+8Dqe3TwOKUp7GJyEq+AnjIGZXe39b6bSBelGD0vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716137380; c=relaxed/simple;
	bh=ZdL1P3gDLeD7UcWsgjDS5BynTw8GaFR9nqjQy4PwtOk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cllfyz9IZ2923jvexQp813bqIceyWuk6WdsezGLh7DgOPPPwsseOHBsS7qqneSKztSoU/y0CnQVh1obXg72ZhA9pNbLBB+XTfHans6UGORwS33O+3lOjDD/UPffzt1ARgg9KjD4QocafdqPBnNCief7toqMdgOEr3GAVRVskR7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBhFY90R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBhFY90R"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40046C32781;
	Sun, 19 May 2024 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716137380;
	bh=ZdL1P3gDLeD7UcWsgjDS5BynTw8GaFR9nqjQy4PwtOk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=vBhFY90RT1qs+GUnN+yjijJYE7ctYfW3txPoLG3J5MvPyhrEOWxKB7SQxgNHCi+iZ
	 RYZOevU7n1wBSxC9uCUi8yd4E6BA0jfvVwWcbupC4d0DVUG3K4s7JF98T73/uIpl3u
	 6OSpvh42DDOjm8vaN9MzH7RD+p+xK5fAjIRJ0ByGrW6pO+4Qxy5tglCh6HhcDnym7N
	 +WVDw8/Ja+wllbCc0IG6gMJ1NiJVFIUZV4OaN/VYQPsGxt63nXyuapsQSFxU63jtZi
	 1wUjaNUnwBNErrS3C2q3k9DoNezW/Nnf58az/t6LgAKFFMH64snUFddcGmW8RrDB4z
	 TGIzs3nnQV6HA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38F28C54BB2;
	Sun, 19 May 2024 16:49:40 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
References: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
X-PR-Tracked-Remote: https://lkml.kernel.org/r/20240412120421.27d86c34@canb.auug.org.au io_uring/io_uring.c
X-PR-Tracked-Commit-Id: 76edc534cc289308130272a2ac28694fc9b72a03
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 61307b7be41a1f1039d1d1368810a1d92cb97b44
Message-Id: <171613738022.16746.1562405680951035145.pr-tracker-bot@kernel.org>
Date: Sun, 19 May 2024 16:49:40 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 17 May 2024 19:22:39 -0700:

> https://lkml.kernel.org/r/20240412120421.27d86c34@canb.auug.org.au io_uring/io_uring.c

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/61307b7be41a1f1039d1d1368810a1d92cb97b44

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
