Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A54C30C60A
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764273918; cv=none; b=OKr3pRO1i/VQbhSvxKuYyqw6Ip5n23/LW8pgvobabtt5s5XLRRO6hQSKcsxw/J2+4DWPRIEtTqv1kzX/zXvth1o7aJIGFs643J0l9rncMqWB1LLAfvr2q1AXoNcpr6x2WHJUexCYv+7XFJSTZqHLak+YPkH4mF5soazWksUq3O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764273918; c=relaxed/simple;
	bh=0SYGh/DWWAA6yayNwEAGFom1eTRnVTwllX0wP5vvBOg=;
	h=Date:To:From:Subject:Message-Id; b=CPbWtgDpgec0OiGMM/nYGnLL1xMABHYvoVat4lSKPHynqzkE1S6AuigGcWBWqYtuuCKMkVUDTklpQ39Pg3/Y0rIe/b0ybFnoqP/CCTNRE3EniAsvpTIsWOYh2wGK+H1GohgaCffwA07VYCB+99nslTEUQcuz48suIUF4RSOq5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O8fYWBl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O8fYWBl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC9AC4CEF8;
	Thu, 27 Nov 2025 20:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764273917;
	bh=0SYGh/DWWAA6yayNwEAGFom1eTRnVTwllX0wP5vvBOg=;
	h=Date:To:From:Subject:From;
	b=O8fYWBl/wODkksZ/8DTDg9n48SfVVLkkFi3r4tHqpw8RPBe2S9f0/Xc7vEkb2Jez9
	 QW8uARhQ/59uqD3wGtoTSpGQo/XYN0Po28Ao/UVvZpsG5S2oEjvZYlscM9GDK2GZxk
	 ZqElG4WOloNXmatHDk18r0tsB1KUjTpzv9n6FK1g=
Date: Thu, 27 Nov 2025 12:05:16 -0800
To: mm-commits@vger.kernel.org,xueshuai@linux.alibaba.com,sfr@canb.auug.org.au,guohanjun@huawei.com,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcoreinfo-track-and-log-recoverable-hardware-errors-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251127200517.6DC9AC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/driver-api: add hw-recoverable-errors to toctree
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     vmcoreinfo-track-and-log-recoverable-hardware-errors-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcoreinfo-track-and-log-recoverable-hardware-errors-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
vmcoreinfo-track-and-log-recoverable-hardware-errors-fix.patch

