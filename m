Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DC742AA3
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 00:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744246272; cv=none; b=qpmlhqpu8vmMWP0A5/76OezZ9xj2jF89UF8PADq4DV3Fqse18EUXs8HGrkYoLGSm0PHn1NTvZhg3g9galvuBjNQOPAz27V5lpNOOOmujs+UK1GQVYGmRLRo3bh2Dxm+9afSMYJZDeoIwkskLgD88CMiXzqZKiI76Svhop2BXvPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744246272; c=relaxed/simple;
	bh=j4UOV3Kw4FH+1FmfJ6DOlhjNy7mnDeEc+GlIhhRJ7dI=;
	h=Date:To:From:Subject:Message-Id; b=M1IS6JMOJ/MD2fprWe83bBa+anUJsrPNrrb/c7qFl6VgfRfoPNcO2ZU3JMNgQvmDx/iq/TFGqWaRfQZUyhMp+swfmZnLAtu2gg5e28FTH6p1MocT8XhiKWwkPNitMh4ARSpm2K0im+ZzmNdMt4rBREaB6XBUeZ88L/I/MKouTmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bq7Fr9sS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bq7Fr9sS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB429C4CEE7;
	Thu, 10 Apr 2025 00:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744246272;
	bh=j4UOV3Kw4FH+1FmfJ6DOlhjNy7mnDeEc+GlIhhRJ7dI=;
	h=Date:To:From:Subject:From;
	b=bq7Fr9sSGYSL3UisEzbP76NUn1zg4DJ6eEs421wipcQGgbT2XImtjAu6HevdXU2QO
	 cIyGQuGPxZIWgMU5xm0lnhln7MA5mCu1Q2v1WxAIyRNJvdSKWoOIViR2WbNI3Ce5/q
	 jJ1RGbmwc/C4XBgYWsG9fJsdRjVNWsFi04EmS2kI=
Date: Wed, 09 Apr 2025 17:51:11 -0700
To: mm-commits@vger.kernel.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-modernize-writeback-interface-v4.patch added to mm-new branch
Message-Id: <20250410005111.DB429C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: modernize writeback interface
has been added to the -mm mm-new branch.  Its filename is
     zram-modernize-writeback-interface-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-modernize-writeback-interface-v4.patch

This patch will later appear in the mm-new branch at
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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: modernize writeback interface
Date: Wed, 9 Apr 2025 20:23:48 +0900

fix uninitialized variable in zram_writeback_slots(), per Dan

Link: https://lkml.kernel.org/r/20250409112611.1154282-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-modernize-writeback-interface-v4
+++ a/drivers/block/zram/zram_drv.c
@@ -741,7 +741,7 @@ static int zram_writeback_slots(struct z
 	struct zram_pp_slot *pps;
 	struct bio_vec bio_vec;
 	struct bio bio;
-	int ret, err;
+	int ret = 0, err;
 	u32 index;
 
 	page = alloc_page(GFP_KERNEL);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch
zram-modernize-writeback-interface.patch
zram-modernize-writeback-interface-v3.patch
zram-modernize-writeback-interface-v4.patch
zsmalloc-cleanup-headers-includes.patch

