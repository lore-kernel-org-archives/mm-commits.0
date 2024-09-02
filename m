Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CCB15098F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248832; cv=none; b=Z+mLXF5MDF1wAb80Yl9uVr9gU5xCxorprNhSsZGQdNUFlNlk+pp4u11+6sh3aWolY/OYkC616d9/3LkQTRhQZWlTSZAQD9uicwTObWe2k51b7QVfCfm+SMu3itSk2Q43oVrkVFU3Xjl7U10Gw9jDjolweYfUwBHFPw3hfos6djM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248832; c=relaxed/simple;
	bh=fSobh8MxDdXczoUeRPaB5883MsOjdHJTv8zk8NJsRZQ=;
	h=Date:To:From:Subject:Message-Id; b=APmR6V3Fah84jtdOoSp7uEw4bNB0f7GPvXsquy9nYmsXguj79Z8T0kk/6Ep8BEuJ7qsTP2iFNwsnnu9bJju8hIzxMnVhg5tRblD5rfd2CXr/JAG4OK5X9Ianqmtaf0FJJFCk9jlWSMSOhfQ1esvnc/GYC+5x7gkPszzN+XrfO9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sEDidRfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sEDidRfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E699BC4CEC2;
	Mon,  2 Sep 2024 03:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248832;
	bh=fSobh8MxDdXczoUeRPaB5883MsOjdHJTv8zk8NJsRZQ=;
	h=Date:To:From:Subject:From;
	b=sEDidRfGO4fK/4MUudyRWQsDKcvScIuONliEHj9IZaeOv/tQfSZ+rtUab3DVacxio
	 KrXmUk0QvaU0paRCeoWNcYJoebZS+mlzvUSLzFUN2ZGjTWu9BeRSQ682ijsyWuvCiL
	 JirrQ98I2B+RJQ5BOoZmusnG+h+yLF5VwvI3e81s=
Date: Sun, 01 Sep 2024 20:47:11 -0700
To: mm-commits@vger.kernel.org,xndchn@gmail.com,quic_eberman@quicinc.com,quic_bjorande@quicinc.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decode_stacktracesh-nix-ify.patch removed from -mm tree
Message-Id: <20240902034711.E699BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: nix-ify
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-nix-ify.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-fix-folio_alloc_noprof.patch

