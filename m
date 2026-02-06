Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077FA2EC097;
	Fri,  6 Feb 2026 20:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770410623; cv=none; b=lgiLSe5pyifyNRTt1y3OVkdQWY1blRk/rXtACbq30MsH996h7wpdlo4ESzXN9QlcjVARbWH5erkLfde47waZTmDigBRu5LfWjRUCO82vmcx0nVRgH3tapojERYRrEwkOIeQ0N7xl+VC50hK+LBTm0CSpqbul9KYQnA0Mm9PFXyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770410623; c=relaxed/simple;
	bh=/TnX09Hv5t15PMPchOzqwIa2F9kys99mKm/6GSVU3rI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=juM4NM/3AyWTIj/0wbxcSaFJbguKUHvySMPqWIz+ERbfTXeTp1a3UPtQr3U+AFcXgdthRPdp8QkBAnYM6qULxsuil2LI/+aiD80RB0/pmoxVxFsjxQMvMvDUXZu/2IJpDAO4Y2bTtMPWM7wgr37Ji1Kfw/gvr3M3twYxkY/97Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cEc/bc8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cEc/bc8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723EEC116C6;
	Fri,  6 Feb 2026 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770410622;
	bh=/TnX09Hv5t15PMPchOzqwIa2F9kys99mKm/6GSVU3rI=;
	h=Date:From:To:Cc:Subject:From;
	b=cEc/bc8j40oDPNKYjkoeIt5QOpwDrrjfVP7k8Z8eVNzsNwGXtdV8uhbFatg0YSP+9
	 NafyI79ICSPkzS/NH8SdBKHhVCrmMvpTbFc4+w+U03rGk69A1EO3sagAUm1hPFDxG2
	 HSkjpUl/e6yHxm53HCkjDKqk9I4HVshr9oiDpmuo=
Date: Fri, 6 Feb 2026 12:43:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] more hotfixes against 6.19-rc8
Message-Id: <20260206124341.c7dc8fc55e0f0f9ea68d3951@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge these two MM fixes for the upcoming release, thanks.


The following changes since commit 1a47837bfafed7e9ef93f5dfdea6d70869b0c3ab:

  Documentation: document liveupdate cmdline parameter (2026-02-02 18:43:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-06-12-37

for you to fetch changes up to ae9fd76c111bb4a5293c2831a1ad373605251dd6:

  mm/memory-failure: reject unsupported non-folio compound page (2026-02-05 14:10:00 -0800)

----------------------------------------------------------------
A couple of late-breaking MM fixes.  One against a new-in-this-cycle patch
and the other addresses a locking issue which has been there for 1+ years.

----------------------------------------------------------------
Andrii Nakryiko (1):
      procfs: avoid fetching build ID while holding VMA lock

Miaohe Lin (1):
      mm/memory-failure: reject unsupported non-folio compound page

 fs/proc/task_mmu.c      | 42 +++++++++++++++++++++++++++---------------
 include/linux/buildid.h |  3 +++
 lib/buildid.c           | 42 ++++++++++++++++++++++++++++++------------
 mm/memory-failure.c     | 42 ++++++++++++++++++++----------------------
 4 files changed, 80 insertions(+), 49 deletions(-)

