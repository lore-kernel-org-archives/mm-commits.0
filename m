Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90111E3DD5;
	Wed,  9 Oct 2024 23:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728516604; cv=none; b=JC6+W1MB6oqgwwQKBkHSgfHnErwXvH9gj8XdurIZ2sPLYmsQfb8RK8qG3xgKVnjWLv+WUgziE2dd5ORBVgbTj2FM7iDtDM85qtLlZKhYJLTDsSSTKTDyPqgCl08VrSytBobO8lZwtzl/y27OCPYJiSsPJ15aZOJnQbWheyBtwIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728516604; c=relaxed/simple;
	bh=au3Vp4Y8pYuONjLQnkndHm8rK/atD1AIVU9Gic4+F+g=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=V4zpjuieH+px+V93auwfFsgZRI5IhirBS8mdaKsX+1/cK99iEzvT7Gd5BIGGhwdjVJEakLLoBQoO/rlgC9aM0kT1XIH1w1+3Y89Bu+DwfaeF7V0B7WOaFtE7/msPKRGYHFLNLDfP3mX9bcle53CYseX+2MI+Q8z4pAo47MLu6AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCkW9ISZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCkW9ISZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11EAC4CEC3;
	Wed,  9 Oct 2024 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728516604;
	bh=au3Vp4Y8pYuONjLQnkndHm8rK/atD1AIVU9Gic4+F+g=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FCkW9ISZLAqzB4IvjELfli/EmdEl4uiWZLA1dc3TGnbHWa0onspdaEI74jvgl0M8v
	 dfREqkYgmjB2JL8pisgqHi2wNJppYUiPzW8j9+IvXFpcFfLC9cvr7jpUBAL2HMZKv2
	 wtItEBpPBah+1fHtL7sNSqATT2I4uwiM/CT2T/WfiIpki9MYG33Tc9m0r8IRm6liNz
	 /LGxrDxeg71PYCPqcBJjHtHsHKV4sP5H1oKKHYDXAaHZMnZnpCQcz6MmDjThcRZ5r0
	 J/sKyzkb4BMExVG4yNh8scOjiVU4OZC5gTJ1zX6E6M0LMbZ8DANzD9M1iqhFBot9qO
	 Jw4D+p5toa2Pg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34CB43806644;
	Wed,  9 Oct 2024 23:30:10 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.12-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241009155033.485bc6df1a01b6dfca93a9d9@linux-foundation.org>
References: <20241009155033.485bc6df1a01b6dfca93a9d9@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241009155033.485bc6df1a01b6dfca93a9d9@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-09-15-46
X-PR-Tracked-Commit-Id: aa5f0fa6af38d96bc6f1b7e1534f5b5c025930a6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3d1556696c1a993eec54ac585fe5bf677e07474
Message-Id: <172851660881.1506208.17995588113913054999.pr-tracker-bot@kernel.org>
Date: Wed, 09 Oct 2024 23:30:08 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 9 Oct 2024 15:50:33 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-10-09-15-46

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3d1556696c1a993eec54ac585fe5bf677e07474

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
