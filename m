Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB5C148848
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417140; cv=none; b=KjfxxARoetFHq1/zqBrc/TFuBtf9mgIUpI48f/Ct+hxUY0r4zImpoy9SGmoCwzhIysk29HveVXlFSPflZprsu0uj+LMGJMHo11RbRvoyoi4lMLqkaDkIlDhEgYoJKejH14wIPsJWPpAryNVOiS8DNZWk3uCA4M55O8vPOkAW4vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417140; c=relaxed/simple;
	bh=wUMQ1JsLnyBqWDvcaeQR8iFwil7Bk0HPCqwjWGdf6Ug=;
	h=Date:To:From:Subject:Message-Id; b=nVz1Wu2c2wBUvOzK9RVLdOVW0/wSjW/KsdQFLVgJYbi+nbdc/DS4q7FhOHlBfhqoYSpC7Zz9YwPXWjPAyYb9dYGpgDQNPCB8DG5L8XAl21UUl4nsPML4eZbzRzbkTH0ACMvMUmnrwpOHtqhdcogmDpKxlZob8BHTrbdWKbAiMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IVSlGPML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IVSlGPML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818F8C2BBFC;
	Wed, 22 May 2024 22:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716417140;
	bh=wUMQ1JsLnyBqWDvcaeQR8iFwil7Bk0HPCqwjWGdf6Ug=;
	h=Date:To:From:Subject:From;
	b=IVSlGPML8KkL2Tkm94atiy6yyHDdY0SDhxnv4RFZUREqQgKtM56AZgCQFa/X0apOw
	 Fbzv6ER1cv3/0QRGjV+RFUT0czhBnou3+ibcRJb70w3UuIvtgoDfbi/DkHDrCw1ftK
	 3JK7uC3tNbNGW2wbWVn/NQU0doOTB8h18tsfxrx0=
Date: Wed, 22 May 2024 15:32:19 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-lz4hc-export-lz4_resetstreamhc-symbol.patch added to mm-unstable branch
Message-Id: <20240522223220.818F8C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/lz4hc: export LZ4_resetStreamHC symbol
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
Subject: lib/lz4hc: export LZ4_resetStreamHC symbol
Date: Wed, 15 May 2024 16:12:56 +0900

This symbol is needed to enable lz4hc dictionary support.

Link: https://lkml.kernel.org/r/20240515071645.1788128-20-senozhatsky@chromium.org
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

zram-move-from-crypto-api-to-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_config-structure.patch
zram-extend-comp_algorithm-attr-write-handling.patch
zram-support-compression-level-comp-config.patch
zram-add-support-for-dict-comp-config.patch
lib-zstd-export-api-needed-for-dictionary-support.patch
zram-add-dictionary-support-to-zstd-backend.patch
zram-add-config-init-release-backend-callbacks.patch
zram-share-dictionaries-between-per-cpu-contexts.patch
zram-add-dictionary-support-to-lz4.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
zram-add-dictionary-support-to-lz4hc.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch

