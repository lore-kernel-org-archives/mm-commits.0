Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983943CA48F
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646313; cv=none; b=GMqSbIyJpQy27nojvCg+DhZJ1YRxe3DUzFXvaH+pscUNSUCzVmDzhuqOcpc1C1RoAtE3Pi3zxIIjeLsXgR2zhK+J8fUB+XgxOS/4hPULuNWMzuzIetjeDG1TXrz8kejofA4Khv9g+AGqhqF7jtInviW6rwuGMKUpcYc1+3f0ACs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646313; c=relaxed/simple;
	bh=D60TNH7OxQszhdKZeWeACENNKneOCHu5fxTHkbmUtlo=;
	h=Date:To:From:Subject:Message-Id; b=kEua8DJtLKewsloJ75K4X4tzLUys60WP9i+BZATAhdQ09jy6UZAHtTAzKD3661obb6gxKx2HmWEQ7hO4pd1VyL/jvaEswO3mEwnaQRleOIuuQHYW5XDdR8e6cJ3ferV09MKO/IVbIaWQWF3lcU68rj3La2UPvXAg4IjOIQYUBAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yU60XLCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yU60XLCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E74AC19425;
	Wed,  4 Mar 2026 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646313;
	bh=D60TNH7OxQszhdKZeWeACENNKneOCHu5fxTHkbmUtlo=;
	h=Date:To:From:Subject:From;
	b=yU60XLCGn+HB/bm/hERGvDH5S1zhgzKkTFhKDsT/IsANZe4ewr6lzP6uqdIwqUls4
	 sogtXXk1h86UQgck6I6aZieO8zBXg2q+fZK5sarH0KEgYzesmr2KGAwigXSYCJLRtc
	 lMTNS/xnmOjeyvQ6nNM+ng8/crSMSgxWzrzbAJ0g=
Date: Wed, 04 Mar 2026 09:45:12 -0800
To: mm-commits@vger.kernel.org,zanussi@us.ibm.com,axboe@kernel.dk,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,kernelxing@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-relay-entry.patch removed from -mm tree
Message-Id: <20260304174513.2E74AC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add RELAY entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-relay-entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


