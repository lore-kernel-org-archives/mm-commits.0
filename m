Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD8633D6CC
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676300; cv=none; b=PVsLd6zkVvYExk7NXH2GiwKJ7FrNoc7cOMEaizv6WmsVXikbpSomcLVF/evB2Yyy+glAH1+ptnWOjQp7n9Ll1tr+mGDEonjZIPC4ov58CfwpdrSQ9eoout1rH8KMO2Vus4wBC/ubwADROOsiBrv0AhkORAJ/ne5/uZ/X8X+A6S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676300; c=relaxed/simple;
	bh=ehZpSz4bFLWGoLqgJtOXRYmN9P2O8G/nuO2aWBUBRxc=;
	h=Date:To:From:Subject:Message-Id; b=urVWq/oLRL9sFgOS2pZyt80ygyhkKkQ1d05pX1ARAFCmEB2ncSxRDuQGj9X20d5oii0Fy6vfG+WHHCh7oiJ1bnWJqNU1pk+ZbWPmfNh/1apYixx3CaWMb0rof7K8lqiXN64aN8HNwU/ikFVvm+miNdeENIjcEFSdennNZXiNux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hfLc4gf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hfLc4gf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8180C4CEF1;
	Thu, 20 Nov 2025 22:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676299;
	bh=ehZpSz4bFLWGoLqgJtOXRYmN9P2O8G/nuO2aWBUBRxc=;
	h=Date:To:From:Subject:From;
	b=hfLc4gf2eSvWNmhsf8xkX0+IpXBhIBr6AeSY/yVMwsnq6R8PMeOrQPAeA1P88ImAE
	 nBW6ZWiRu0pFQuF9jlnoq/xQ34ZnWmntoy+Jcs1eoD3NdPN5nOgTTodOxdRL203dsF
	 4idt4HjKmDdbc4rH8B4adAZqFADXf53g5VKVPotI=
Date: Thu, 20 Nov 2025 14:04:59 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-petr-as-a-reviewer-of-hung-task-detector.patch removed from -mm tree
Message-Id: <20251120220459.D8180C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Petr as a reviewer of hung task detector
has been removed from the -mm tree.  Its filename was
     maintainers-add-petr-as-a-reviewer-of-hung-task-detector.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add Petr as a reviewer of hung task detector
Date: Wed, 19 Nov 2025 19:08:22 +0800

Petr has been actively reviewing hung task detector patches lately.  It's
always good to have a fresh pair of eyes, so let's make it official.

I checked with him, and he's happy to be added.

Link: https://lkml.kernel.org/r/20251119110822.46566-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Petr Mladek <pmladek@suse.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-petr-as-a-reviewer-of-hung-task-detector
+++ a/MAINTAINERS
@@ -11666,6 +11666,7 @@ HUNG TASK DETECTOR
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Lance Yang <lance.yang@linux.dev>
 R:	Masami Hiramatsu <mhiramat@kernel.org>
+R:	Petr Mladek <pmladek@suse.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	include/linux/hung_task.h
_

Patches currently in -mm which might be from lance.yang@linux.dev are


