Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89C64685;
	Thu, 23 May 2024 00:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716423873; cv=none; b=W98MqEa6hH+jf+/iL7jhpeKNVHypY7kaJ/xg9EMbCBPI5Ml63E2UJW+0lDqqQ7OkKQ7mk96y+gfHUjPuAEODDb7aLR1wb5G1EG/HeeuwWPO4ej3912g246tQFlmkeTEvqsXaQQ0yMzrNSjov81AMQQSuz+oXTSqC88sTYwmS3Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716423873; c=relaxed/simple;
	bh=tQUwEwqaIrLh2dcvKeTuI68qLcnsESgtm1sngts63H8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=XJJMC5PSfnkihAQK2ksrfZcLjfNzTR0N+1zKIg1yOBhIFK7MavaYsTxPz7P6IGUvxxUcJzrsUvsUOgQCLQok0N3192BuOmSJmxWnjXOfzYtdIBtASJf6ptd7oFB7cql7ZyQOax8+pMnq7xIK6Pz/BurP199aWobFQTGHod07H/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qa6lwTvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qa6lwTvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C98C2BBFC;
	Thu, 23 May 2024 00:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716423872;
	bh=tQUwEwqaIrLh2dcvKeTuI68qLcnsESgtm1sngts63H8=;
	h=Date:From:To:Cc:Subject:From;
	b=qa6lwTvcD+jtpUkPPXMnYrPiMCkkkVqfi9f2SVm6uKfFKAsh3HDbqBo+lT+/lAXtW
	 TBrRt71JvvjDFVze6n9GT5a0MQOjUCksvbI6+68QQzxNxsCIpXVd6xw+1US8Ln9lRr
	 mIwTPFPaA/VnnYqfxNb67MtiHCy0ebQYMx8cqTzM=
Date: Wed, 22 May 2024 17:24:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional MM updates for 6.10-rc1
Message-Id: <20240522172431.d2aa8775d7a48999afbc29b4@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull this small series, thanks.


The following changes since commit eb6a9339efeb6f3d2b5c86fdf2382cdc293eca2c:

  Merge tag 'mm-nonmm-stable-2024-05-19-11-56' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2024-05-19 14:02:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-05-22-17-22

for you to fetch changes up to 99b80ac45f7ec351c2d1c9fbfec702213dcae566:

  mm/page-owner: use gfp_nested_mask() instead of open coded masking (2024-05-19 14:40:44 -0700)

----------------------------------------------------------------
A series from Dave Chinner which cleans up and fixes the handling of
nested allocations within stackdepot and page-owner.

----------------------------------------------------------------
Dave Chinner (3):
      mm: lift gfp_kmemleak_mask() to gfp.h
      stackdepot: use gfp_nested_mask() instead of open coded masking
      mm/page-owner: use gfp_nested_mask() instead of open coded masking

 include/linux/gfp.h | 25 +++++++++++++++++++++++++
 lib/stackdepot.c    | 11 ++---------
 mm/kmemleak.c       | 12 ++++--------
 mm/page_owner.c     |  7 +------
 4 files changed, 32 insertions(+), 23 deletions(-)

