Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7E18E053
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925260; cv=none; b=uAKb253AqJg+hX24Q17TAU8/MdDRuM6kcQZBK/sYU3ddajWYzIfVjDLjMIZdeFkj2YTqpv9FAkvRHh0RRW2LEbi44heMKTmKd75jM1L+d7YQiCO8aLcbVQhOZiZtXGP8lBv1UQF4WGOdBUCRMvXWBZn14G4hHtZoaRy7/oRPnzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925260; c=relaxed/simple;
	bh=BTsHd2S+f0QDFSn49jqkvOSrn7rOSISJd9InxnfGsUA=;
	h=Date:To:From:Subject:Message-Id; b=jRQ62VZdOosNWuTdOCP45PsqUr0UOt5RncyHsZnzafoR/CX0dhaDMesthM0Cci9YtQj+ISHh1KpgZq9sveMEka89cjxx62AALpc4bh+PW5vFofugzcbeHR4h367pbl34TeHg4OQ99KA/hVRJF0grS1xxjueU72M0psAe+5C3duU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nB/37CdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nB/37CdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042D3C4CEC5;
	Mon,  9 Sep 2024 23:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925260;
	bh=BTsHd2S+f0QDFSn49jqkvOSrn7rOSISJd9InxnfGsUA=;
	h=Date:To:From:Subject:From;
	b=nB/37CdLYJSfFg1dTk9+2eQS/zuudxKXuUbA+32AdeBIS8ip4WXaXNhzlGRIXKlzH
	 EeGDVsa9BIW1/O51SC2EkfKBA8UXFn4/v4ymQPPSOoVtf7oT3OUaoSe20GMn46G0tQ
	 aCN8YVYptsJrE6V3rTF813bgLFEUScadQ3eS295M=
Date: Mon, 09 Sep 2024 16:40:59 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-lz4hc-export-lz4_resetstreamhc-symbol.patch removed from -mm tree
Message-Id: <20240909234100.042D3C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: lz4hc: export LZ4_resetStreamHC symbol
has been removed from the -mm tree.  Its filename was
     lib-lz4hc-export-lz4_resetstreamhc-symbol.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

zsmalloc-use-unique-zsmalloc-caches-names.patch

