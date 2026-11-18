Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024572;
	b=PdQ456Y600AJAOIA1QRPt021yVrZhxwu131Z3HF76O1n5z/o0poXqE9y/hNzLjkfynjr
	 mq/cm9HIf3/z8RapzgszdGZJl9ruRJzqJapeqvES2BHv89ti1L/5nRiIy+AxB8GH+hkIG
	 5RmtneabUpIZK4dha62lORFOAxD5bv6qEiu3S4UOT5s10/HyKKfeSvyF2F9gigAp0EDHh
	 ypk8LZT6pogIY/w0S+StC6CvwCNpwPOt58im9d1zFQOEytMvpKCp/yDIUZL/rNqryhUwf
	 8GUPWxvKZePJRGnzwWRepVJc6x3c45XjLn4RL2AY/dtmLVFE2NVnNsWzD5aZIhgVlQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024572;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=13046BEyk3OL0XiJDfnqzRxyQM4EIUQxyIC+qg+uPx4=;
	b=OEFBqIC1h6/W8sDfqiSWlRD6Du/i9ZNVieyOEzBQNncJX7q39ja+giBg/IfpfjYQ4KjO
	 L532wiZxnwQ9y64yICT2Mey+yLVwD4V71ci4wAGXagek3yJ2n3zJUur8cWWQSGy/uBojA
	 tQ/GwmwIFCKwNw431ee0+mgKa5rx7xrjzdnUiBHYcYKhwUaPT5K8uNpCLs6Tp2zt3JObu
	 5vx1eZqYPMnzF2DuVR91TqHrsanxuI9sWKYVJvsbPI1oI7sPAHXgWptUHH1OWzrilY9tW
	 vBG5e8MqexxFM/gBRgYupNaFu6o5gw6hfUEjxAzzIzCvbrUzRLu7AZea/cgNRNLPcgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Gj57/5xQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0E5606A332;
	Wed, 18 Nov 2026 17:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gj57/5xQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0771F000C6;
	Wed, 18 Nov 2026 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024572;
	bh=13046BEyk3OL0XiJDfnqzRxyQM4EIUQxyIC+qg+uPx4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Gj57/5xQvx96AFQb5qSmSIAvCs/NDEgpjKn9AwD+XaaF6SCgRpFyvf2Px4UGCV/fU
	 uGHtFLLfhF7abcL36OCI0/GAHN3DrhR1QiNN5PGDKAwLtkOq6mCqn5GfBVZLmnJkrw
	 flW1AnyzCUNsiM7ds9ZqdLrybqaCBaJ+BQAQszenljMg446FHHqRx8v/dyiuYGExgR
	 UC2ogdwIW9DxiygNAlFOUNuGZx5jLHVBFV9M10er/v2KJWHUFscqCwlYjDL9MV5CGy
	 19X2Fq7si5Nu1kzGF3JNtJq2WjEGrdogLOIRpicBDaLFc48qdSJBm5Rt7/4IZCnJWk
	 dUwMnT8eubnNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 772B43808210;
	Wed, 18 Nov 2026 17:56:12 +0000 (UTC)
Subject: Re: [GIT PULL] Non-mm hotfixes for 7.4.rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261118000947.a86e7241c67d295c40eb8b71@linux-foundation.org>
References: <20261118000947.a86e7241c67d295c40eb8b71@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261118000947.a86e7241c67d295c40eb8b71@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-18-00-06
X-PR-Tracked-Commit-Id: a001666afbf9d2a6096fea95686549b9b1c9d968
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
Message-Id: <179502457112.1929586.16741761767129300180.pr-tracker-bot@kernel.org>
Date: Wed, 18 Nov 2026 17:56:11 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Wed, 18 Nov 2026 00:09:47 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-hotfixes-stable-2026-11-18-00-06

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
