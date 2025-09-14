Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EA433987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810121; cv=none; b=pIbEXkrd+TQ7Sx1fgY89gzwOY/wfw7VJePAEd3uVgHwYBRvH33abj4cHE0kOKc1VkMyQNooRYygjrkUFBzcfH4oVR9+92FjcgjZ6vm4yNbs9Ld3stXLiUiOkj3ESGm9qTpLlySepT6054+JaqWphQuLqPSfmY2/kvACW198N+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810121; c=relaxed/simple;
	bh=80nRSV7LmkBdt60/1IMSMYBn47nHpoBiaCC6PfIz784=;
	h=Date:To:From:Subject:Message-Id; b=ieYRAWx5StCAC8bO22zZNPnw8g0z33g6abnTAG9B+E2bDL4n4RwYsQiGLPSr2fj/saicV+9BPn73z84c99h4JyhbrF9b5gbLTtbH6BoCq08X00AyzKhSKPFv0VQnMfJOfTj8LsN5MDeKF+7xpkvRXVZ277i74gFvSR34PYdBm8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cYhNot3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cYhNot3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A108C4CEEB;
	Sun, 14 Sep 2025 00:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810121;
	bh=80nRSV7LmkBdt60/1IMSMYBn47nHpoBiaCC6PfIz784=;
	h=Date:To:From:Subject:From;
	b=cYhNot3LGZ9kSpBSZaaD5P4+CjF1D1YgwO459t66ADThv6lRE5XDZTvSTSi21GKzr
	 hfMTn7GPZJukryaDy7XyiVBysTTokkK97k12HfHn37Nx7ysK02kofPcL1po8Gq5LaY
	 xOEUOM6BMouyZ9LeE+hSB0yd8ivBI2d/RoDUaC4A=
Date: Sat, 13 Sep 2025 17:35:20 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,jbohac@suse.cz,hpa@zytor.com,coxu@redhat.com,brgerst@gmail.com,bp@alien8.de,bhe@redhat.com,liaoyuanhong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-crash-remove-redundant-0-value-initialization.patch removed from -mm tree
Message-Id: <20250914003521.2A108C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/crash: remove redundant 0 value initialization
has been removed from the -mm tree.  Its filename was
     x86-crash-remove-redundant-0-value-initialization.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: x86/crash: remove redundant 0 value initialization
Date: Mon, 18 Aug 2025 20:35:28 +0800

The crash_mem struct is already zeroed by vzalloc(). It's redundant to
initialize cmem->nr_ranges to 0.

Link: https://lkml.kernel.org/r/20250818123530.635234-1-liaoyuanhong@vivo.com
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/kernel/crash.c~x86-crash-remove-redundant-0-value-initialization
+++ a/arch/x86/kernel/crash.c
@@ -172,7 +172,6 @@ static struct crash_mem *fill_up_crash_e
 		return NULL;
 
 	cmem->max_nr_ranges = nr_ranges;
-	cmem->nr_ranges = 0;
 
 	return cmem;
 }
@@ -332,7 +331,6 @@ int crash_setup_memmap_entries(struct ki
 		return -ENOMEM;
 
 	cmem->max_nr_ranges = nr_ranges;
-	cmem->nr_ranges = 0;
 
 	memset(&cmd, 0, sizeof(struct crash_memmap_data));
 	cmd.params = params;
_

Patches currently in -mm which might be from liaoyuanhong@vivo.com are


