Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6171135A7F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289912; cv=none; b=JUW2raYL6Y4CAjnZkNfFsnRDk0Y60e6MIzEeeOhWyn1/UBTFpgA6Iibq8/Bp1F14hSyjgytWNq+Dsr4PlnPtm80Sp1lA4FrMfruoDjL4o7iGpT6sAx41sxRJ7dMOdu0DFFwLJ8ipU3UOenc1ZnLzzF/WuKxTo7hGewJmn0q9lTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289912; c=relaxed/simple;
	bh=sUOZ84raFeCKT0k7iUiLx3xwrsGKG9I5GnYgDq9HVXk=;
	h=Date:To:From:Subject:Message-Id; b=UNnOlFd7UmtSVHgSfdMyFhV5ht/cej0yfEZgJKzYKRrIliioBO9AKVLeR2/6IVy1+sL2EqQldq7PpKWrLwYqtnuAWm/0DP+dHSm3V8wa8a9HMiQvYhTlJbhKrnuF3FShBf6i1Qx0RfVce0eLNWGE8LIulNDUUml7wyHPYeMEroE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DHAl1hcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DHAl1hcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A7FC32782;
	Tue, 25 Jun 2024 04:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289911;
	bh=sUOZ84raFeCKT0k7iUiLx3xwrsGKG9I5GnYgDq9HVXk=;
	h=Date:To:From:Subject:From;
	b=DHAl1hcbureEfK5qRQECLrGudVeqAr4P2wLaQ+OaAs8A9RQqnlX1pFp5FNMWuHtk6
	 pY0LrQk6TIZ1GRAgl4mxRtnCvmIM+3lMMT072TfbOswKmFIMNq27SH+GB/PsTzeoEv
	 3sbZVnjhcqr46ZYYUB2xr0a80zFN6opgGWIo5zT0=
Date: Mon, 24 Jun 2024 21:31:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zswap-add-zswap_never_enabled-fix.patch removed from -mm tree
Message-Id: <20240625043151.61A7FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-zswap-add-zswap_never_enabled-fix
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-zswap_never_enabled-fix.patch

This patch was dropped because it was folded into mm-zswap-add-zswap_never_enabled.patch

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm-zswap-add-zswap_never_enabled-fix
Date: Tue, 11 Jun 2024 23:37:52 +0000

Expose zswap_never_enabled() in the header for the swapin work to use
it later.

Link: https://lkml.kernel.org/r/Zmjf0Dr8s9xSW41X@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    6 ++++++
 mm/zswap.c            |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/zswap.h~mm-zswap-add-zswap_never_enabled-fix
+++ a/include/linux/zswap.h
@@ -36,6 +36,7 @@ void zswap_memcg_offline_cleanup(struct
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
+bool zswap_never_enabled(void);
 #else
 
 struct zswap_lruvec_state {};
@@ -64,6 +65,11 @@ static inline bool zswap_is_enabled(void
 {
 	return false;
 }
+
+static inline bool zswap_never_enabled(void)
+{
+	return false;
+}
 
 #endif
 
--- a/mm/zswap.c~mm-zswap-add-zswap_never_enabled-fix
+++ a/mm/zswap.c
@@ -137,7 +137,7 @@ bool zswap_is_enabled(void)
 	return zswap_enabled;
 }
 
-static bool zswap_never_enabled(void)
+bool zswap_never_enabled(void)
 {
 	return !static_branch_maybe(CONFIG_ZSWAP_DEFAULT_ON, &zswap_ever_enabled);
 }
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch
mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch
mm-swap-remove-synchronous-argument-to-swap_read_folio.patch
mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch
mm-zswap-add-zswap_never_enabled.patch
mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch

