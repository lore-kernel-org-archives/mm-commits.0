Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2361CD2B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 21:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725311878; cv=none; b=rge/3KVnpmQ+T3B/lohjpcxS0uKD578R2KSSAsObaWKmiU05e2AZ4GvfhODYZd8VRY8bu6sXV3kr7MX/fVxaXaWhdqnoxZxUro4jwr/cNMgXOS0xBByyBfSEZWC0wLMarZ6FEMrMMXib16FFYN6mwfpfh72EexohnMi+zYVJsFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725311878; c=relaxed/simple;
	bh=4KQ8/UUxKSySDVrbCkqPR/pH6PotR0sYkTjEjgj6GeE=;
	h=Date:To:From:Subject:Message-Id; b=YkmKahgoZi/D2HvHwGem/PMbwaCJ0+BppLbcsWfp334ZkR8jdFvwwCCE+EiAHOgiY8ND1xcosM/INkrU5rEYzskDAQuHOPfhKCYJs3KBBdTq75AKH4wc33dmox1T5hMF6bK1b8Pga/yIMtsB1yfo7Z7KOIfobHkaKXa79RTzIF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BnNmvCIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BnNmvCIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F027FC4CEC2;
	Mon,  2 Sep 2024 21:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725311878;
	bh=4KQ8/UUxKSySDVrbCkqPR/pH6PotR0sYkTjEjgj6GeE=;
	h=Date:To:From:Subject:From;
	b=BnNmvCITHdowK5nzOGV1hZQ/yygZrzy62q7aT2WEAUwsN0SFMwAHWdImdn+du5AFE
	 ytE6Hhncy01T3L68hoQE3Us9JukJtrw+rt8wCaF+a+Jktcd5kUx+legcdSQK8oj0x8
	 DjFlYaI4I8s7KqE8KtaQId+kAIE9GQYTDtH+fAjU=
Date: Mon, 02 Sep 2024 14:17:57 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-lz4hc-export-lz4_resetstreamhc-symbol.patch added to mm-unstable branch
Message-Id: <20240902211757.F027FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: lz4hc: export LZ4_resetStreamHC symbol
has been added to the -mm mm-unstable branch.  Its filename is
     lib-lz4hc-export-lz4_resetstreamhc-symbol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-lz4hc-export-lz4_resetstreamhc-symbol.patch

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
Subject: lib: lz4hc: export LZ4_resetStreamHC symbol
Date: Mon, 2 Sep 2024 19:55:50 +0900

This symbol is needed to enable lz4hc dictionary support.

Link: https://lkml.kernel.org/r/20240902105656.1383858-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4hc_compress.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/lz4/lz4hc_compress.c~lib-lz4hc-export-lz4_resetstreamhc-symbol
+++ a/lib/lz4/lz4hc_compress.c
@@ -621,6 +621,7 @@ void LZ4_resetStreamHC(LZ4_streamHC_t *L
 	LZ4_streamHCPtr->internal_donotuse.base = NULL;
 	LZ4_streamHCPtr->internal_donotuse.compressionLevel = (unsigned int)compressionLevel;
 }
+EXPORT_SYMBOL(LZ4_resetStreamHC);
 
 int LZ4_loadDictHC(LZ4_streamHC_t *LZ4_streamHCPtr,
 	const char *dictionary,
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
zram-support-priority-parameter-in-recompression.patch

