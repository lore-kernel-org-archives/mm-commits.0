Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3891534CDD
	for <mm-commits@vger.kernel.org>; Thu,  5 Feb 2026 01:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770256244; cv=none; b=sCaN9mwtE0ypY0TF6WdTJOiWuYFcEc5yTXUL1BEWdRnCsvP57Zz78h4YmqfFidhc5KXDk3/uqLNeI3ZT8yuYCkksk/U5lCYvY6+EMKrKyVvbjr6Yfs3U5aqVnafqav8BJSB06x2kfunRqF41qI63OUIkzQ1BHzwppyLHrDvxAjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770256244; c=relaxed/simple;
	bh=EquagluUIyCEUHu/7Z2SYS8vF1N/ak95dOaK7U5SzzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEcJVvJ0I5Rgjgax/U61HJjffGPypG4ZIRx8xwbbbX9N3xMN/w4FsdeDtiucDWX+1oXcJEwbQXRlzzNGUkpyA7g283BJ+JN3DDJNA5ppHYYA7DKJbn2WFz/FpclKsHmNqQdc2aGmYKVmclnmeVP+D119jyVeGxufQzt583UbFZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9NO/89/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9NO/89/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A19EC4CEF7;
	Thu,  5 Feb 2026 01:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770256243;
	bh=EquagluUIyCEUHu/7Z2SYS8vF1N/ak95dOaK7U5SzzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9NO/89/a2yCliiO11tfaS2rmmsawJ2D2OAfk5wXhRCehG7rZEFvY1zz0OGytGvsY
	 igGJhK1PAJ4YD5osblKQ9rnqTkZKiee7+CBA20pL19OKfagI51UJVvFnOyBKpkKEPA
	 0V7JIwb6rUD86M2a5QyKz/kuHrmb9nzrRXaY6RFi8kyNyWuray8x/iM9rY9sFImQb9
	 BzPPwSWiv33YZSYGhAvy03+ywg2uRE5O4fbAlg/0TZVD3TXI/fmWu+4sjWiJ+7OP5J
	 7AHB5LQgfUw2SJKS69yHFOWR+g8srfviIv+qGIuhdFjRdvmfXErGzGJOVfrQFlV/tO
	 UB6qMv/AI/CaA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	Liam.Howlett@oracle.com,
	david@kernel.org
Subject: Re: + maple_tree-add-cp_is_new_root-helper-fix-fix.patch added to mm-new branch
Date: Wed,  4 Feb 2026 17:50:35 -0800
Message-ID: <20260205015036.68763-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260204195637.F2B13C4CEF7@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 04 Feb 2026 11:56:37 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: maple_tree-add-cp_is_new_root-helper-fix-fix
> has been added to the -mm mm-new branch.  Its filename is
>      maple_tree-add-cp_is_new_root-helper-fix-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-cp_is_new_root-helper-fix-fix.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> The mm-new branch of mm.git is not included in linux-next
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: maple_tree-add-cp_is_new_root-helper-fix-fix
> Date: Wed Feb  4 11:54:03 AM PST 2026
> 
> s/cp->slot[0]/&cp->slot[0]/, per Liam
> 
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Assuming this is a fix for https://lore.kernel.org/20260204063620.15857-1-sj@kernel.org

Tested-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]
