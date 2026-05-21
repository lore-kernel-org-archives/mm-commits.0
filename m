Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D631242D67
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 23:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779405360; cv=none; b=AmFlYWWfSdfajO0rD7lxmkzJ0YgxGgkKvJjycL5p2atsiV51yr+9W3J4CE+VrcpFdAwEGyMR/DLVgY03jEICKlV38sb3IXw9bExHAAK4W2FlARL5PW/8AAhWM/zP7pLTnA6rp7jS5FTn8u4tHB8vi6MX7bDLRCAecowgZv7K/aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779405360; c=relaxed/simple;
	bh=AC8ONJB8x9s0+W3ZfwMOMuCWamlPu8nvLhSCLZuSSl0=;
	h=Date:To:From:Subject:Message-Id; b=kljqiN1Iy59jb7VblZlNZQwPok7NCihzC8EHMJ8UFuWHgowN23fRoNJZYJLwKfrIK+cwdsbdK7fvMCUHgSl8dKlceRx9sQlF+1dVreb2YqRqtYt52XSPOleOtRNpp+zMziLR9uapLFTY2Y59dxtU95mwc6f/FUN7sX1YhUH9Suw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RPO+EMS5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RPO+EMS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22B71F000E9;
	Thu, 21 May 2026 23:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779405358;
	bh=M2r/z4R9fxcqRFCxQZr4RENKM1xdxZIPOZC0K/VypJg=;
	h=Date:To:From:Subject;
	b=RPO+EMS5N3D3bpufpbsOC+HXeqkUSDtbk76VY22Rr9MJ1MK50PfHeslziScS8bjZz
	 ToNCJTbGjTkMa2VC7X1XYW9jqiaHy+5hMXtmjLPHCMCGGBZQmtF2LrvT4fwIPqyNOt
	 fWFv7I+rzvuhBUBjeFooRzg1VBwakvJ9F5xyr2xk=
Date: Thu, 21 May 2026 16:15:58 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2.patch removed from -mm tree
Message-Id: <20260521231558.A22B71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2
has been removed from the -mm tree.  Its filename was
     kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2.patch

This patch was dropped because it was folded into kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2
Date: Fri, 15 May 2026 18:22:30 +0200

remove unused constant KCOV_MODE_REMOTE, per Dmitry

Link: https://lore.kernel.org/20260515-kcov-simultaneous-remote-v2-1-56fde1cfa509@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kcov.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/kcov.h~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2
+++ a/include/linux/kcov.h
@@ -21,8 +21,6 @@ enum kcov_mode {
 	KCOV_MODE_TRACE_PC = 2,
 	/* Collecting comparison operands mode. */
 	KCOV_MODE_TRACE_CMP = 3,
-	/* The process owns a KCOV remote reference. */
-	KCOV_MODE_REMOTE = 4,
 };
 
 #define KCOV_IN_CTXSW	(1 << 30)
_

Patches currently in -mm which might be from jannh@google.com are

kcov-refactor-common-handle-id-into-kcov_common_handle_id.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix.patch

