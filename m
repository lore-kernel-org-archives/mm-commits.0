Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BAE1862
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 05:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724131895; cv=none; b=HYjM62UaNOGq8vyL1hz895rMuI2JO4jtc8/IwlbcdbsCEF/besNNdB1byxiFibVp0HL1E6hK+bYoMz0Zp89oOm6BA+LtgwfU/93x+vqtQO/2cuJTBU5SpXGUJx4fVuvDAgghdTPfG2zwvZ3symiSJq4SmGua5RG2HfzDoIf9IPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724131895; c=relaxed/simple;
	bh=RVmLxDlUmLbiGwDEU+UpsH01oCeaKdBCAlzwaVOHV5k=;
	h=Date:To:From:Subject:Message-Id; b=WqoUofcanhOllgKvufmuFHTtgHxdi1bm3c4bu3Qjxl+oHvBgmV9RmuL4CuEtSI+raSSSLyC2xH9nOETmX4BvfpGvd486bJ1XmjZuchQyg2VzzfBsVory2aQm1V0gUHQvFctC+qqHij2i9G5ujiJIouG1R8G401al+85KyyNgTY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nkP7+/Zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nkP7+/Zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369D5C4AF0B;
	Tue, 20 Aug 2024 05:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724131895;
	bh=RVmLxDlUmLbiGwDEU+UpsH01oCeaKdBCAlzwaVOHV5k=;
	h=Date:To:From:Subject:From;
	b=nkP7+/ZmkYj9wVYC0SdBUuH+gQdW6JfS4F3PEqKCjkPpsB73IZUOI21cC6+fn15Hg
	 p3yc5/p73QdudtQ2K7BBcVnJxNc2eQC9AuHeDIcbGGoMIjsmsYc6twCR71pb35Cs14
	 q7Uqu6dMLg7sHyoIidHBQtWnpvvUMv2AcmkGLKhE=
Date: Mon, 19 Aug 2024 22:31:34 -0700
To: mm-commits@vger.kernel.org,xndchn@gmail.com,quic_eberman@quicinc.com,quic_bjorande@quicinc.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-nix-ify.patch added to mm-nonmm-unstable branch
Message-Id: <20240820053135.369D5C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: nix-ify
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-decode_stacktracesh-nix-ify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-nix-ify.patch

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
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: scripts/decode_stacktrace.sh: nix-ify
Date: Sat, 17 Aug 2024 17:50:25 -0400

nix only puts /usr/bin/env at the standard location (as required by
posix), so shebangs have to be tweaked.

Link: https://lkml.kernel.org/r/20240817215025.161628-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>
Cc: Xiong Nandi <xndchn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-nix-ify
+++ a/scripts/decode_stacktrace.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # SPDX-License-Identifier: GPL-2.0
 # (c) 2014, Sasha Levin <sasha.levin@oracle.com>
 #set -x
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

scripts-decode_stacktracesh-nix-ify.patch

