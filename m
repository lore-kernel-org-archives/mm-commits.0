Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5030619E819
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 23:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779145519; cv=none; b=BTtrEKJUr6ycOLOjkOE7At/juxdEqHHTb3gl9NEwo1b4wvun/nKhcQYrtjYujYFl2Bk51dIt/GRSj9t5Ll+wt3KnURhzGP51/GeJXPR2BotL7Dtl9/B122TxgSi3S6XeVjbUD4mDCvtc7uNN5A5wu8XtsVL95ydpfDlj/tVsBvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779145519; c=relaxed/simple;
	bh=9oeX3kKyntb+RLSscfbJd3Vn7ZriMSDB3HJjuZQwQ9M=;
	h=Date:To:From:Subject:Message-Id; b=BBhpZ5d+Dxmcz0aymVpGewdXWjzRqPiAV07Cjgagahan/xSVEXrfYzTEUbAJD/WwyYssemGRxmdIBDA91xa/lnkhHbFUqCQ7Iq8g3qxm+yD9rFvt2EaV1AcPG5tpnE5bE/bANbvS5CAy+g8TPBRGzlf8gmLGu5KhIrLsvoIBJXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hx5ocVOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hx5ocVOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45F0C2BCB7;
	Mon, 18 May 2026 23:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779145518;
	bh=9oeX3kKyntb+RLSscfbJd3Vn7ZriMSDB3HJjuZQwQ9M=;
	h=Date:To:From:Subject:From;
	b=Hx5ocVOvZQdUtzGTE1TGZLgT6mk+g6+3iyHsCEKpTDQ91TG36wz+rc16ryEPaIwYc
	 JRgyVMoSk+tRA65zwlOBMohuLqiz1kua70siIVmiyH+DpuTztAZse0EbpWtEtM9Llg
	 hW8vGl1xvBOBi+yMwUN5b1BGv2iczutRDQii4g7E=
Date: Mon, 18 May 2026 16:05:18 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20260518230518.B45F0C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-v2.patch

