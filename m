Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468801448C1
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 20:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395756; cv=none; b=a4mL5FxgfjsxtS1+2+E6Cm/ibY+ZtwERED++pRBqUw6AZjO61P8i/8drwBp/+p7sJwEJV7TbFGXc7I5hjuzBJiKZylaujlZtnJIwLknlI8WEnX2frLHsq3BqPzfLmdxGS0RwUjhB7nwY017cJuLnCcPLuf/c2fRUZDv6m1zmvCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395756; c=relaxed/simple;
	bh=ItxX9ml80GWf8b2nKse+NCEVkjc8yozalQ7LbzSIUmc=;
	h=Date:To:From:Subject:Message-Id; b=lXQCKTYUmPBE0drVfagOJrUI8jWzv8PZfj/GlCke7NoYZ8lM4tFszgUd1DB7YT00v8xKtyVmmOaKQKcSu8zRkDbKjFg8GNJrgtKCkQSFLiAr9ZS2adULFl/6+k4h6x0saoMmT7c2lfanP96+3jelG0/8uyNkH85Ye13Nm9y+JKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=okF6H+dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="okF6H+dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED68AC4CEC4;
	Tue,  3 Sep 2024 20:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725395756;
	bh=ItxX9ml80GWf8b2nKse+NCEVkjc8yozalQ7LbzSIUmc=;
	h=Date:To:From:Subject:From;
	b=okF6H+dgZEbwAJxw8xT298pUm2adFDo7ARebLZjTLLfuwj5GifBnufhF7sB4SjQFi
	 vEtfVp4Hz7bJMwDS5/npzHFC4oph/bmZvm7SeuxvkFhucGllPoLOjxQL2/tfy+DSpY
	 ofLnYxkXQqCo7NRh/EDHTxn4Li8DiUvEcI3owlsA=
Date: Tue, 03 Sep 2024 13:35:55 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-zram-add-documentation-for-algorithm-parameters-fix.patch added to mm-unstable branch
Message-Id: <20240903203555.ED68AC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/zram: trivial fixup
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-zram-add-documentation-for-algorithm-parameters-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-zram-add-documentation-for-algorithm-parameters-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: Documentation/zram: trivial fixup
Date: Tue, 3 Sep 2024 15:37:06 +0900

Link: https://lkml.kernel.org/r/20240903063722.1603592-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-zram-add-documentation-for-algorithm-parameters-fix
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -309,7 +309,7 @@ a single line of text and contains the f
  ============== =============================================================
 
 10) Deactivate
-=============
+==============
 
 ::
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

lib-zstd-export-api-needed-for-dictionary-support.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch
zram-introduce-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_params-structure.patch
zram-recalculate-zstd-compression-params-once.patch
zram-introduce-algorithm_params-device-attribute.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch
documentation-zram-add-documentation-for-algorithm-parameters-fix.patch
zram-support-priority-parameter-in-recompression.patch

