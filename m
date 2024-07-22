Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B77C152;
	Mon, 22 Jul 2024 01:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721610924; cv=none; b=jAuHWLntm84lTtAaYVpI/dVXfm+2ujVvGCl59zos84F3K8KQ9lLtC0CKjr+kH1tyTNSabGJllix1L1CjRcdFeXpZGOiTF68LnF3fcpq365n2lhMQWI0BcXmUO/5DhhBVUhGrTWNHk7p4tceAY7kmKNqtZRsXVqzecxAgcvnMhO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721610924; c=relaxed/simple;
	bh=qs0gXrYbCcQX8WXOavFNAGXQfERItMvGDclYZZTtw0o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sFuLtdVm8S+Z9TfuAVQ4y0K4paDGL12rdwMIXrstZGx9iNw3Fq26kzqkhEowfO8x5MdCTcltmMlnOTJUWem38oAWghWMmeUEqzZdWv9VBlJdcQN+zZm8m1D+ya9ZTMkV/6y+dNEzBLT9xsPCihojbYoL+v3UfCchDggiwljZtu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJwsLmQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJwsLmQh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC784C4AF09;
	Mon, 22 Jul 2024 01:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721610924;
	bh=qs0gXrYbCcQX8WXOavFNAGXQfERItMvGDclYZZTtw0o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cJwsLmQhYRCo+TE7bhwoWtdwTFaKSIGRNTdcWZBORqvBUANvpF1L1uz4FaIPRhWzr
	 SteAFZc1M6VRiv5Znlr0QqxPE3Dedgv87ahBW3poJ+G7nK6hwjEWo9GRJgjlHksXsH
	 jDqhSrXsjrn+fcQPqRueoZ8CwWfkrKCaEV6dm4eZnwg2fm3p3U2/5Y3Yo0t3J66i+1
	 rjP/IZ4o/JxIU5wDEqQQRHPANxv2OBcqwqokrH4tYt6pvm2LIFDpS9PLoXV13h9yLs
	 w5NdmEFVGC0I4otKyW+gCKsQzE9RGoKMwY3cKONf6rDL0YDJ2sVTkJheW4UcqkjAx8
	 Dk/O1S0AT4Fug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC93BC4332E;
	Mon, 22 Jul 2024 01:15:23 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.11-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240721151013.b9b331ce79f5f60c54c69636@linux-foundation.org>
References: <20240721151013.b9b331ce79f5f60c54c69636@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240721151013.b9b331ce79f5f60c54c69636@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-07-21-15-07
X-PR-Tracked-Commit-Id: 67856f44da381973caf4eb692ad2cca1de7b2d37
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 527eff227d4321c6ea453db1083bc4fdd4d3a3e8
Message-Id: <172161092389.21017.16605519697388783559.pr-tracker-bot@kernel.org>
Date: Mon, 22 Jul 2024 01:15:23 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 21 Jul 2024 15:10:13 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-07-21-15-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/527eff227d4321c6ea453db1083bc4fdd4d3a3e8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
