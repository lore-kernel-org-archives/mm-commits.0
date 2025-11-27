Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE69311C3C
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282125; cv=none; b=lfYfb/bToP7xgEomlsuusKT034bIT5+kHGZuaVsGftX3yQDGdkxiKCiUvfDtBwkpbyM03sTo4B9u3Z2KmckbWgQ9ORiRJIVFtSz8KOfuULrnn9aqtQlyRe92d/uLda20c3MBXkH1zG3BETMM9AWcGj71+pBkIOhQKlLxxUDUsQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282125; c=relaxed/simple;
	bh=V2dMH0LDUZF3Ia7xTmRVWLBUCA6dXjuJq8oi66CWyRA=;
	h=Date:To:From:Subject:Message-Id; b=tVh0mgkfWLPq5m3lYk1A/Tw1Xwa2PCYpLmbsSm0rwH1Xvo6TeJlMG2WfWBLgNj+QibN88STWGbZ1ncgICQpNfHPfw8EPvUM8watue2f6XJh/5Pryo43PNdh2wvbcxKogFrqj9PNTcAHH+dHohM1u8+gdnn2yLPVl/9ibynh05lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=syHDjo0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="syHDjo0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E55C4CEF8;
	Thu, 27 Nov 2025 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282123;
	bh=V2dMH0LDUZF3Ia7xTmRVWLBUCA6dXjuJq8oi66CWyRA=;
	h=Date:To:From:Subject:From;
	b=syHDjo0M0cYaBVh6oDWlREcTHg8xHADMUR7LdX4tHndjWsNV7Vl4+wGVL0Vn1fPDK
	 1IuLa1OZIwCjuXUxqaCxvw7TQsExYGSf6gW2R8QAg9uEg+FwSgcSNkVDtAU0p6JLqO
	 XrwIRSaQT2damWde7j8Fz7bU+bJgKWy+tPcBN8tk=
Date: Thu, 27 Nov 2025 14:22:02 -0800
To: mm-commits@vger.kernel.org,xueshuai@linux.alibaba.com,sfr@canb.auug.org.au,guohanjun@huawei.com,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] vmcoreinfo-track-and-log-recoverable-hardware-errors-fix.patch removed from -mm tree
Message-Id: <20251127222203.06E55C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/driver-api: add hw-recoverable-errors to toctree
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-track-and-log-recoverable-hardware-errors-fix.patch

This patch was dropped because it was folded into vmcoreinfo-track-and-log-recoverable-hardware-errors.patch

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: Documentation/driver-api: add hw-recoverable-errors to toctree
Date: Thu, 27 Nov 2025 07:34:24 -0800

Stephen reported that commit c03fb5253a0341e ("vmcoreinfo: track and log
recoverable hardware errors") started to warn about "document isn't
included in any toctree".

Fix it by adding the new rst in Subsystem-specific APIs section.

Link: https://lkml.kernel.org/r/20251127-vmcoreinfo_fix-v1-1-26f5b1c43da9@debian.org
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20250729150042.77832045@canb.auug.org.au/#t
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-api/index.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/driver-api/index.rst~vmcoreinfo-track-and-log-recoverable-hardware-errors-fix
+++ a/Documentation/driver-api/index.rst
@@ -96,6 +96,7 @@ Subsystem-specific APIs
    gpio/index
    hsi
    hte/index
+   hw-recoverable-errors
    i2c
    iio/index
    infiniband
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kfence-add-reboot-notifier-to-disable-kfence-on-shutdown.patch
vmcoreinfo-track-and-log-recoverable-hardware-errors.patch

