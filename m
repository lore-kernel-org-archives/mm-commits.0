Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2396F33987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810129; cv=none; b=d4ua7LE6AyxNeBHqGnTA7o2H/AeiX+OoI7Mr3vsEYWb4G1kgCEO2wgGwZrJ3snI6COQ2QQgyAsS726O57WmolTP00Wf/nE0uyiDZJmNXRHxysHPWYNNTvtSMKDgsWh/F4DAf7OrPrYdWgUf+5zx3NB950LmHlKIMJOR4Cp7xfpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810129; c=relaxed/simple;
	bh=HBfieORPyV5qhte3ZcaDZA0MY2LPDtMi6Me4v0AL6Xo=;
	h=Date:To:From:Subject:Message-Id; b=iUl4lXRfeVQ1lJame3eEoQ90zbQ4MlpK4kYYIpHF6nApCqS42S6w2GXH9kOH/DMQYYwKdpcA2VztM7r3uUqvC5t2m8pM+N+nAUIexXNqMlN5tyWuRN2Kd+IDifiXeTe6ZluB17CTMpvTb582zkXfMT2TmJDxo6ECu30bq+TOLE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UCIjxMa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UCIjxMa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3DBC4CEEB;
	Sun, 14 Sep 2025 00:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810129;
	bh=HBfieORPyV5qhte3ZcaDZA0MY2LPDtMi6Me4v0AL6Xo=;
	h=Date:To:From:Subject:From;
	b=UCIjxMa5+Ka00POzkNmMBLNmq83f/N9jIarowr5TMVSaZ4e+reBRWbm6jIDNEvuxu
	 7TFJZeyZt2TrCUXzGY1kDPJLAuDFvmzbb5pG0/eOL6rg/v53kJt4X99p8UFnnH/AMA
	 wckmDzUUL+mHyJw6uu2EU2fXtANyGL6AgSR0D3B8=
Date: Sat, 13 Sep 2025 17:35:28 -0700
To: mm-commits@vger.kernel.org,liaoyuanhong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_core-remove-redundant-0-value-initialization.patch removed from -mm tree
Message-Id: <20250914003528.EC3DBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_core: remove redundant 0 value initialization
has been removed from the -mm tree.  Its filename was
     kexec_core-remove-redundant-0-value-initialization.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: kexec_core: remove redundant 0 value initialization
Date: Mon, 25 Aug 2025 20:33:05 +0800

The kimage struct is already zeroed by kzalloc(). It's redundant to
initialize image->head to 0.

Link: https://lkml.kernel.org/r/20250825123307.306634-1-liaoyuanhong@vivo.com
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/kexec_core.c~kexec_core-remove-redundant-0-value-initialization
+++ a/kernel/kexec_core.c
@@ -233,7 +233,6 @@ struct kimage *do_kimage_alloc_init(void
 	if (!image)
 		return NULL;
 
-	image->head = 0;
 	image->entry = &image->head;
 	image->last_entry = &image->head;
 	image->control_page = ~0; /* By default this does not apply */
_

Patches currently in -mm which might be from liaoyuanhong@vivo.com are


