Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BBF1EF39A
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119313; cv=none; b=csmIMiJsC9MXWqTncMEFA/MymOXYee4Ag1dmGzNEWuB92py4z2Mzi5Hn6WZPgUXaMT3zCwdRE7NSWGHV7lX77cjDRD37Hq0kuXZGTXB9np+hbGA168x904yR1k8MZl04o5AtNYHdTq8t4i9bctN+H5UBjytj/Tcgcg0NnJxsEh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119313; c=relaxed/simple;
	bh=eS4y5xr0GEJhAFiMBdBaBcTL/N4h9zRxLLKdpq/k6dA=;
	h=Date:To:From:Subject:Message-Id; b=DajkGBCvk3jnYP+OE3pGbi4l5yslDWcbG84EtC9w4zyoLkMXGPPuIkXLLIqSBo1tlvq+qoYtMRunT+68eByCEa01d+1T+XJ//kwmMQkqbUlnNdv2MGqX1+wW5VblEFES9iPF/mx2l0z/Ef0udcKCPCGyb3IaOdUSDoNVj0edjl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xvqh5+QZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xvqh5+QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7620FC4CEE4;
	Tue, 13 May 2025 06:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119313;
	bh=eS4y5xr0GEJhAFiMBdBaBcTL/N4h9zRxLLKdpq/k6dA=;
	h=Date:To:From:Subject:From;
	b=xvqh5+QZusUm5GCfGOjX9LQSrJ/yoHaZoRR2+PJT+mYjLRKoWJJHyWsQENok/1uMS
	 HiwBMH+ID+XmcxOFgCelhsLb4j6f4buYbiyPgsFlk+MCXPZ4KXhF7gI3lQ7M3LjqZe
	 ZtUqXVAIBol7PB49HXkaYHOMo/4bnLm16n+6aGAE=
Date: Mon, 12 May 2025 23:55:12 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,pasha.tatashin@soleen.com,andreyknvl@gmail.com,trintaeoitogc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-flags-layouth-change-the-kasan_tag_width-for-hw_tags.patch removed from -mm tree
Message-Id: <20250513065513.7620FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page-flags-layout.h: change the KASAN_TAG_WIDTH for HW_TAGS
has been removed from the -mm tree.  Its filename was
     mm-page-flags-layouth-change-the-kasan_tag_width-for-hw_tags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: mm: page-flags-layout.h: change the KASAN_TAG_WIDTH for HW_TAGS
Date: Mon, 28 Apr 2025 17:14:09 -0300

KASAN_TAG_WIDTH is 8 bits for both (HW_TAGS and SW_TAGS), but for HW_TAGS
the KASAN_TAG_WIDTH can be 4 bits bits because due to the design of the
MTE the memory words for storing metadata only need 4 bits.  Change the
preprocessor define KASAN_TAG_WIDTH for check if SW_TAGS is define, so
KASAN_TAG_WIDTH should be 8 bits, but if HW_TAGS is define, so
KASAN_TAG_WIDTH should be 4 bits to save a few flags bits.

Link: https://lkml.kernel.org/r/20250428201409.5482-1-trintaeoitogc@gmail.com
Signed-off-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags-layout.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/page-flags-layout.h~mm-page-flags-layouth-change-the-kasan_tag_width-for-hw_tags
+++ a/include/linux/page-flags-layout.h
@@ -72,8 +72,10 @@
 #define NODE_NOT_IN_PAGE_FLAGS	1
 #endif
 
-#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+#if defined(CONFIG_KASAN_SW_TAGS)
 #define KASAN_TAG_WIDTH 8
+#elif defined(CONFIG_KASAN_HW_TAGS)
+#define KASAN_TAG_WIDTH 4
 #else
 #define KASAN_TAG_WIDTH 0
 #endif
_

Patches currently in -mm which might be from trintaeoitogc@gmail.com are


