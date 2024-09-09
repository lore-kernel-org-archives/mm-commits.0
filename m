Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CFA18D63C
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924896; cv=none; b=NdNd4eNl8bptQJ1ixSJENi36vTF+qL9nYSP09KF90VuPUyEy6CVOUdzn5vChlbAsGbQztoWkwQ7V07qvn0fGaSS2KtWrS1Eg0nJjuuYAfGWbF/dZKr2LSS9hCnXanhPXWit/OtWFvYrAkD/Sd5/B7Egku5ggf7FoQVu9skFntho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924896; c=relaxed/simple;
	bh=M/0Nh9UmPxJEpXgHVJH0goAmR36IryqhinuB/pcK7N4=;
	h=Date:To:From:Subject:Message-Id; b=u4Tk/f9E4YlRvFFxqXL6rTBuRpzNW5RzrrkE0LQMTknIX4BWurevwCJyzb7MErdENyjr8vjGOnmv0Zc6dCe8wuPb7cMCfL414eWVbvewgd5f6jI6QnX75TkjRH1nvdOZL+so2HZZe5yazQp0lUblrHOYerBntkrneHXG4dF7Y6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=myk7wZVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myk7wZVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B7FC4CEC5;
	Mon,  9 Sep 2024 23:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924896;
	bh=M/0Nh9UmPxJEpXgHVJH0goAmR36IryqhinuB/pcK7N4=;
	h=Date:To:From:Subject:From;
	b=myk7wZVEunsKAS/RifxHWF+ISgbUzug5kA+r43VAfzAwm/Q9uG9fkkjwefumGe4+K
	 fiqsc/FlOZPd9lMNbXimhFD/dG+FKvcG1I/yDOkP9C7GghLYIYwLMWwTwa1BY4kfaJ
	 rkiZEf+o6CtvrlCm8dJMPcd42TOVxj+h4ZXfl/ZM=
Date: Mon, 09 Sep 2024 16:34:56 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] documentation-zram-add-documentation-for-algorithm-parameters-fix.patch removed from -mm tree
Message-Id: <20240909233456.93B7FC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/zram: trivial fixup
has been removed from the -mm tree.  Its filename was
     documentation-zram-add-documentation-for-algorithm-parameters-fix.patch

This patch was dropped because it was folded into documentation-zram-add-documentation-for-algorithm-parameters.patch

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

zsmalloc-use-unique-zsmalloc-caches-names.patch
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
mm-kconfig-fixup-zsmalloc-configuration.patch

