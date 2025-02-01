Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644A57DA84;
	Sat,  1 Feb 2025 20:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738440501; cv=none; b=Fb3FP0tooVloVUal5kEmSfLuBDXhk8dwX+ulcfIt74i8zAwT3OCdYzIuGNKPoL/0Zrvio/I8i+8l6mdByu/pCRu8ci9Nh9UJXHB78jlWDL9h5LfC6dAWMy0863uRrrOSEN4UFORLC2TkQGBMETDcRv4yfYJApD0HJ29GRH+2w2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738440501; c=relaxed/simple;
	bh=3u3DcHEhnBkG2uPUBL/PYvCx5XsS+0SHMBboSVrdspg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aSptSeoKHnpxRhCU5j7oq37+yzaoKuO3yqmhIXQiuNbVQ+LW2Wyi4FJy8uWsyoc329Bc5PUv0HSGuOHgahC80DUYvDds578jAPWgokCmhavWpP9a71XIauFNpcvoPOlkF5ylmGi0LLhTv72euZajRNA22ybc4G3+ILuMJ7959Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJdYyECC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJdYyECC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5C5C4CED3;
	Sat,  1 Feb 2025 20:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738440500;
	bh=3u3DcHEhnBkG2uPUBL/PYvCx5XsS+0SHMBboSVrdspg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OJdYyECC5lMbYBaXMkcTCHPUWyosThYznZytXJ59whwgtZlxGWU1/ACLJOEdANPpi
	 0lyNnCKpVnmVtJzAw9bWTUgMaGAscWFij/lf9M7tj5scbXoS67q+J0jCUejPumrE+6
	 UwtAvZN58N5Gzd0v23wy3dI/3bDACv8SIfk9RqmYjZdpF0j2MhraSa0sK00PTYTcLQ
	 Vuzy711mM0q4aFb7rBs3kbJRvjUOwoy7YWbLVOgD0bJwgC5817meSUhyZw70T/wiU+
	 oIpiHn3nFnUOeumWQREqKPnt16yP/9h7VvQ36x09JY+5luma8ouIT0utt2U8jUqeNu
	 OZm9gR8H8A8ow==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE93F380AA68;
	Sat,  1 Feb 2025 20:08:48 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.14-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250201035903.6b2e2113f5b6cd38b07b46b5@linux-foundation.org>
References: <20250201035903.6b2e2113f5b6cd38b07b46b5@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250201035903.6b2e2113f5b6cd38b07b46b5@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-02-01-03-56
X-PR-Tracked-Commit-Id: e5b2a356dc8a88708d97bd47cca3b8f7ed7af6cb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 03cc3579bc617ba7615068bedbb5331043e62142
Message-Id: <173844052723.1982916.2524234222522964221.pr-tracker-bot@kernel.org>
Date: Sat, 01 Feb 2025 20:08:47 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 1 Feb 2025 03:59:03 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-02-01-03-56

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/03cc3579bc617ba7615068bedbb5331043e62142

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
