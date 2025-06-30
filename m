Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5AC28E605
	for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2025 19:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751312221; cv=none; b=aA+USAf2EJHNNcSZpVOgN3nibROFSlD/AKDHw/dw54+kCWQDzELUT/SlwnzPB0asH7OeWBMNLykvEtBhdqTm/wwW9ckHBCPydTecVp/V7h3TkFKBvtZHJd/rMJhIX+XBFH+oDYXwtlQL6VXdd09PljOfT9/Ij7pkVlIjT+fJzTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751312221; c=relaxed/simple;
	bh=U+Z63q3nY20X0jcnDQg9gGYHFnNweYt9c8K+yWgrV/4=;
	h=Date:To:From:Subject:Message-Id; b=tUQQxh0yFFuBEzWBSQy4rHYd/mG7/2jmw0/iYYdkrUR74OKqV2o5k1UyXtApM4O0OyxzcpJc7KbN5Y1jl4UScDtJmZZ+xICDKaxIvtd+7jA9NBr5jXBoyB6GxSmGGGAsrJ0MBmkmGAe28c3/k2BLrSOXwFJbkP4DKo8x/UuwB90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rnpVibCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rnpVibCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A44C4CEE3;
	Mon, 30 Jun 2025 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751312220;
	bh=U+Z63q3nY20X0jcnDQg9gGYHFnNweYt9c8K+yWgrV/4=;
	h=Date:To:From:Subject:From;
	b=rnpVibCm/UQXT1kLjMwAE7qWvwN/KQ9SUw/LWyzaV4C2k3suMnqkYaVHsyum4A26T
	 TOFswVAilVoHE5NPUDiOCR1EwSKO7GAfgojg2GF3ikIfUvhNJnxMeIL+MRBh/smIXh
	 7EqY3fl/4JIgt9iM8WiNYtilIkgQTXA1Yup2X4PA=
Date: Mon, 30 Jun 2025 12:37:03 -0700
To: mm-commits@vger.kernel.org,ojeda@kernel.org,nicolas@fjasle.eu,masahiroy@kernel.org,wen.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] scripts-headers_install-fix-a-false-positive.patch removed from -mm tree
Message-Id: <20250630193700.64A44C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts: headers_install: fix a false positive
has been removed from the -mm tree.  Its filename was
     scripts-headers_install-fix-a-false-positive.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wen Yang <wen.yang@linux.dev>
Subject: scripts: headers_install: fix a false positive
Date: Sun, 29 Jun 2025 23:52:07 +0800

The current implementation only handles C89 style comments (/*... */) in
the code, and there are false positives for C99 style comments (//...).

This patch fixes this issue.

Link: https://lkml.kernel.org/r/20250629155208.16174-1-wen.yang@linux.dev
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_install.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/headers_install.sh~scripts-headers_install-fix-a-false-positive
+++ a/scripts/headers_install.sh
@@ -44,6 +44,7 @@ scripts/unifdef -U__KERNEL__ -D__EXPORTE
 # Remove /* ... */ style comments, and find CONFIG_ references in code
 configs=$(sed -e '
 :comment
+	s://.*::
 	s:/\*[^*][^*]*:/*:
 	s:/\*\*\**\([^/]\):/*\1:
 	t comment
_

Patches currently in -mm which might be from wen.yang@linux.dev are


