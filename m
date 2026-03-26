Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC2516CD33
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 00:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484479; cv=none; b=obFn54lgPbGhgXaJhRjMsVCFa7cf41jK/H4XKkvMDy+dVRoMeseGrL7bjRe+x6WWeuBKZLRfqvemnro6O+Vwgi74nb/w/OzqFuJmiU0+U2XU+LtxNDU+CyihyFG/dUcr+o/soIEPxA+14jMJgVxCShVC1I4F0H7WKWYZs9guPow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484479; c=relaxed/simple;
	bh=QXDp4H//mD9C7CCIX7D9TCMSEdRA3C1xjGL2+vIaN1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrcPpTOJiuQkcdQaC02Ms/uuH5MD87kqvDm6rDEVY3svX4+7Ff7sLu8WgIdXQU4WcShvd69ixOvWGKXAc3IAIGiTHeIArpkb1A9BpK5Z5w+lx1GeB1EtG9WJ466Qn6mp8gZVWMxu61vHXmTudb+flvwQolbs49GcG1PxwtbPWQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQgTqOan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQgTqOan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36722C4CEF7;
	Thu, 26 Mar 2026 00:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484479;
	bh=QXDp4H//mD9C7CCIX7D9TCMSEdRA3C1xjGL2+vIaN1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQgTqOanQLvBX5EvSrNW1dqZ+O5kDx6LHpXDZTaFs78y2O2mRNa+K+4yzpVxunyjG
	 oVqBzhr4qfZeDZ2c6WjncMQu1bhBaLgftwqN6M6YMasSrlGGCKjrtHK8swFd5OEqmJ
	 Zhell1o1xJ4RGdGGCyHTXiGGNUlONB20KaoVjgBED5yDZey1sOfRUIkDdP1Q2jM50y
	 XMfBJDWk/4omNmqPtUXmvUZZIpADsvwoJWhEYQ/miQwfm5awR598Fxpl8cakqh1sQR
	 0RvcQ0sThMHi9xgdXwnPQ+zBIT22D9Aun1hesKsDneLW/9NwoiIS/OfSyyB5yFQybA
	 grinjpoAwysWQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	skhawaja@google.com,
	shuah@kernel.org,
	rppt@kernel.org,
	pratyush@kernel.org,
	dmatlack@google.com,
	pasha.tatashin@soleen.com
Subject: Re: + liveupdate-prevent-double-management-of-files.patch added to mm-new branch
Date: Wed, 25 Mar 2026 17:21:11 -0700
Message-ID: <20260326002112.77105-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324150331.BBF14C19424@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Andrew,

On Tue, 24 Mar 2026 08:03:31 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: liveupdate: prevent double management of files
> has been added to the -mm mm-new branch.  Its filename is
>      liveupdate-prevent-double-management-of-files.patch
[...]
> ------------------------------------------------------
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> Subject: liveupdate: prevent double management of files
> Date: Mon, 23 Mar 2026 20:31:44 +0000
> 
> Patch series "liveupdate: prevent double preservation", v2.
> 
> Currently, LUO does not prevent the same file from being preserved twice
> across different active sessions.
> 
> Because LUO preserves files of absolutely different types: memfd, and
> upcoming vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd). 
> There is no common private data or guarantee on how to prevent that the
> same file is not preserved twice beside using inode or some slower and
> expensive method like hashtables.
> 
> 
> 
> Currently, LUO does not prevent the same file from being managed twice
> across different active sessions.

Seems the usual "This patch (of X):" line above this paragraph is mistakenly
not added?

No issue for me, but I just wanted to inform you for a case that you care about
that.


Thanks,
SJ

[...]
