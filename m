Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3A4158DA3
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 19:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772394077; cv=none; b=Mvd/bZ7MLBZ/NsSuOPZ4ZCw3f3jugzVLvAqS/0G1FaCtZaEe77PbxRkpS+4GrTLAZ3z2AkKBbCjUoHSxUFjaPWzDqb7vLzhwsgayCGpk15PFkXT5PojGh1VdJQMAgcmXWUUq9bqQVMXheLhErpuOdxCdAGmoD45YBD8YAyhC0c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772394077; c=relaxed/simple;
	bh=qJawhyJ2RJTGNsjXOQYqiGpA51e0y3rdDzwxQEFS8Qw=;
	h=Date:To:From:Subject:Message-Id; b=r0xOxD2WIGXyGUkPVgPLoRA0urIUMxr9K1+L9B0Yjv9IWU4MDR4qtSFnWSYWL+DMo9oNLiN3vl73mYVkAk/Gi09frB1OCTA/SmM4a+bwpV0irss7DyBJ4HfYTFbBuj1MwylgBYrjUuGR45pyZh8UyjP/aUK1RHWXZfR/YeOF1rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XT+rtw1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XT+rtw1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736E1C116C6;
	Sun,  1 Mar 2026 19:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772394076;
	bh=qJawhyJ2RJTGNsjXOQYqiGpA51e0y3rdDzwxQEFS8Qw=;
	h=Date:To:From:Subject:From;
	b=XT+rtw1Obeq/JOYkH0eslvcHJIqtlwKO9Ec3zsVI+GfCkXgND6pfokwaSoM3jOcrn
	 4d/FVag6Srw5XFBVXoyx5y8G7R7f+g4DF6HO8iizVnua+yM4GnJ05E8iEU5ppe2pfj
	 Gm4GwkvBdSt9Ic8mIjxvF8EJbMJAL1OcB62HG62k=
Date: Sun, 01 Mar 2026 11:41:15 -0800
To: mm-commits@vger.kernel.org,zanussi@us.ibm.com,axboe@kernel.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-relay-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20260301194116.736E1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add RELAY entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-relay-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-relay-entry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jason Xing <kernelxing@tencent.com>
Subject: MAINTAINERS: add RELAY entry
Date: Sun, 1 Mar 2026 10:09:02 +0800

RELAYFS was originally developed by Tom Zanussi and Karim Yaghmour in
2005[1].  Jens Axboe converted it from filesystem into a generic API in
2006[2] and made it widely known through the notable I/O tracing tool
blktrace.  In the decade, there remain a few users scatterred across
different subsystems, like recently added wifi commit[3] that is an
example to show how to communicate between users and kernel.  Last year
I've already done some maintenance and added/corrected some diagnostic
counters.

At Tencent, we internally maintain RELAY as one of most crucial components
of network observibility platform which was shared a bit at LPC 2025[4][5]
and hopefully will be published in the paper this year.  RELAY has proven
highly efficient due to its inherent design essence.  This design becomes
the indispensable way to build a 7x24 platform monitoring various hot
paths even without any selectively sampling (yes, sampling is commonly
used to avoid the overall performance degradation).  One of the
recommended usages is to use its zerocopy function relay_reserve() to
transfer data in a raw format that can be recognized and parsed by the
corresponding application to userspace without introducing heavy locks and
complicated logic that appears in other types of approaches, like printk. 
More details can be discovered by reading through the Documentation :)

Credits are given to the all the contributors and reviewers for
RELAY/RELAYFS in the past and future! Many thanks!

[1]: commit e82894f84dbb ("[PATCH] relayfs")
[2]: commit b86ff981a825 ("[PATCH] relay: migrate from relayfs to a generic relay API")
[3]: commit c1bf6959dd81 ("wifi: ath11k: Register relayfs entries for CFR dump")
[4]: https://lpc.events/event/19/contributions/2055/
[5]: https://lpc.events/event/19/contributions/2010/

Link: https://lkml.kernel.org/r/20260301020902.56476-1-kerneljasonxing@gmail.com
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/MAINTAINERS~maintainers-add-relay-entry
+++ a/MAINTAINERS
@@ -22284,6 +22284,16 @@ L:	linux-wireless@vger.kernel.org
 S:	Orphan
 F:	drivers/net/wireless/rsi/
 
+RELAY
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Jens Axboe <axboe@kernel.dk>
+M:	Jason Xing <kernelxing@tencent.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/filesystems/relay.rst
+F:	include/linux/relay.h
+F:	kernel/relay.c
+
 REGISTER MAP ABSTRACTION
 M:	Mark Brown <broonie@kernel.org>
 L:	linux-kernel@vger.kernel.org
_

Patches currently in -mm which might be from kernelxing@tencent.com are

maintainers-add-relay-entry.patch

