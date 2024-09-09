Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C6718E36A
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925261; cv=none; b=X6QcGI1VpmWgR6qJa95UHwHrmHCrUxE9oQUeIJagfDKihUKqgHRIinRru70/dZiwV80Bll4ZjisUS7SD28QC2nKS0tUZ1FeDHbmew8vIJgTaXg0RGlUXuBgPNep1K0syHZ+uSdWHMmVzYJEDMuhBVyrlOHvQk1AmBTBHR0/K+Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925261; c=relaxed/simple;
	bh=zAog4FI8XpHeUnWGhUJ7aWc5UyNbdR7d4T8uumOkbeU=;
	h=Date:To:From:Subject:Message-Id; b=O4Fe+eH61wDg0G2lZn0x6ImqBHExugiqRaD6xPnQrrQmwkJWw2CcQ6RnOqKJptNm7FxpzeIIJa+yAVXE0do/CmkOPRVaDwJOsJykwWBjvd+wNQNNB3xhZ7IKnk8FjcPcuaiFiZDLpgwcZOoqhfISNCIGaPzJgi55OymYCQfWOOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lZw7gqyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lZw7gqyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AF3C4CEC5;
	Mon,  9 Sep 2024 23:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925261;
	bh=zAog4FI8XpHeUnWGhUJ7aWc5UyNbdR7d4T8uumOkbeU=;
	h=Date:To:From:Subject:From;
	b=lZw7gqyrOIfE7MXZGODZXMsu8c1Es0uEW1o0L9ciOwSFt0P8qGng6sRtyTZSYfx5O
	 ns/62vSF9xj213xsYWTCHrPD8cfSzeD2exec3QpTF1jHa7bjAZw84SJii7S1osNrcR
	 ic4qFcjLOCs7r/ZODWFV4KzR8GABoxVoIu714gKE=
Date: Mon, 09 Sep 2024 16:41:00 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch removed from -mm tree
Message-Id: <20240909234101.47AF3C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: zstd: fix null-deref in ZSTD_createCDict_advanced2()
has been removed from the -mm tree.  Its filename was
     lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: lib: zstd: fix null-deref in ZSTD_createCDict_advanced2()
Date: Mon, 2 Sep 2024 19:55:51 +0900

ZSTD_createCDict_advanced2() must ensure that
ZSTD_createCDict_advanced_internal() has successfully allocated cdict. 
customMalloc() may be called under low memory condition and may be unable
to allocate workspace for cdict.

Link: https://lkml.kernel.org/r/20240902105656.1383858-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zstd/compress/zstd_compress.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/zstd/compress/zstd_compress.c~lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2
+++ a/lib/zstd/compress/zstd_compress.c
@@ -4810,6 +4810,8 @@ ZSTD_CDict* ZSTD_createCDict_advanced2(
                         dictLoadMethod, cctxParams.cParams,
                         cctxParams.useRowMatchFinder, cctxParams.enableDedicatedDictSearch,
                         customMem);
+    if (!cdict)
+        return NULL;
 
     if (ZSTD_isError( ZSTD_initCDict_internal(cdict,
                                     dict, dictSize,
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-unique-zsmalloc-caches-names.patch

