Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95D2BE7DD
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966030; cv=none; b=u3NhWzqyHCLZ2ikR+8vuWwTAeEb4aWmciNL4DJR9QLjRsWqO30kJ9RYeUxu6xztVWrRql+WrDe3qa8tGkcGIcZisIAxVKOgTXk8oqZQztpu7NGF5/5G4KYB8upJWCRoFFqT144VL/hsU+hAcjIO7pW0DJzLDus0UtSXX67IRw9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966030; c=relaxed/simple;
	bh=zSLIp7EyK8t5rEYa7k/EOJdwIiyY8fimrUshwa/IEIw=;
	h=Date:To:From:Subject:Message-Id; b=s2MtMex4AW/xC8OtAEydUOZQeE93IiDmsjAaXvB1egy7pGNNSml8ry4uiiBdaq2SmGKNyol4AsKRXmO5M8giDdSe5MHpJbzoWjz1LywwMJLhx7risqClXkmcs+t5lXUeGIYLYgu1DHz4Eb6NyyGOByGTS5WAGo7oPy7OXUlO38w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWtGbG4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWtGbG4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85654C16AAE;
	Wed, 21 Jan 2026 03:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966029;
	bh=zSLIp7EyK8t5rEYa7k/EOJdwIiyY8fimrUshwa/IEIw=;
	h=Date:To:From:Subject:From;
	b=tWtGbG4DVjR4F70RAGQ+wIiCMBV3HmBGa82iBWMHNOmNJD0kzTqXIj94wE7BQfymH
	 LejvEfVcbKW66HseVn4jidz0rW50cR3IeV9SAZ7emPU4+NhapMvkvRigi25ZqwWbSa
	 d8Klw8D/lSc75GJ8ZeKu6to/6zulV6FOWKstsk+8=
Date: Tue, 20 Jan 2026 19:27:09 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-consolidate-device-attr-declarations.patch removed from -mm tree
Message-Id: <20260121032709.85654C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: consolidate device-attr declarations
has been removed from the -mm tree.  Its filename was
     zram-consolidate-device-attr-declarations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: consolidate device-attr declarations
Date: Mon, 1 Dec 2025 18:47:54 +0900

Do not spread device attributes declarations across the file, move
io_stat, mm_stat, debug_stat to a common device-attr section.

Link: https://lkml.kernel.org/r/20251201094754.4149975-8-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-consolidate-device-attr-declarations
+++ a/drivers/block/zram/zram_drv.c
@@ -1966,10 +1966,6 @@ static ssize_t debug_stat_show(struct de
 	return ret;
 }
 
-static DEVICE_ATTR_RO(io_stat);
-static DEVICE_ATTR_RO(mm_stat);
-static DEVICE_ATTR_RO(debug_stat);
-
 static void zram_meta_free(struct zram *zram, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -3008,6 +3004,9 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
+static DEVICE_ATTR_RO(io_stat);
+static DEVICE_ATTR_RO(mm_stat);
+static DEVICE_ATTR_RO(debug_stat);
 static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

