Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32B328DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489841; cv=none; b=ChrbvZxAbclNKfcX6r1YQ6HG0ulnh3ewJrSlyiKg8ZWH5evnWzryHNRccPi1u9Zu4Kw3CFuSYtUDFZE+3DDG+W1M4yDXyDjnvsAgCDjPsogUNT3QLjxaWiBFz0emtrsLm+oocgYt/FCJo1vAPw9TkaN2WIcZH8xy2PlsT+GgoLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489841; c=relaxed/simple;
	bh=qG8P+rtAHWDpYiG2YNRpTtLBDXumvoaNRvlxpZ6KkuE=;
	h=Date:To:From:Subject:Message-Id; b=vFO5NtAhh6ejnuJ+Uj//ea6caPKiz676FRdUqC6ChDJzMoE4W1+78U2OremO2Bpo1YRUfM3rKmyCC0OCtFttn26RQ3rpIwsQ06pEXz58nCPbuch7CTQGqBC2dBh6cRsq3I8rdz5g9XlDYRiqKl67Cf7ojDAbc6syVb08L4Vi0XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GlPwnKV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GlPwnKV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877F5C4CEE7;
	Sun, 21 Sep 2025 21:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489841;
	bh=qG8P+rtAHWDpYiG2YNRpTtLBDXumvoaNRvlxpZ6KkuE=;
	h=Date:To:From:Subject:From;
	b=GlPwnKV2biwd9r+YNHo7OC7mwMa8c2QN1qAPU4UecaRY0qqESeVqWB52nRemOCN+9
	 qZzp0OB3jjxubisFRVaGTrDlO9GhezUMlnd1w/A+UwTQQ6sVT2Ypirf5HyM6SppPv3
	 iTZvx8H4nZAnV9Jyutq7mhdoxGxAhx4xFkB7YDeg=
Date: Sun, 21 Sep 2025 14:24:01 -0700
To: mm-commits@vger.kernel.org,ulf.hansson@linaro.org,oakad@yahoo.com,lorenzo.stoakes@oracle.com,lars.persson@axis.com,jesper.nilsson@axis.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmc-drop-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212401.877F5C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mmc: drop nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     mmc-drop-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mmc: drop nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:50 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-30-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tifm_sd.c    |    4 ++--
 drivers/mmc/host/usdhi6rol0.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/tifm_sd.c~mmc-drop-nth_page-usage-within-sg-entry
+++ a/drivers/mmc/host/tifm_sd.c
@@ -191,7 +191,7 @@ static void tifm_sd_transfer_data(struct
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
+		pg = sg_page(&sg[host->sg_pos]) + (off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
@@ -240,7 +240,7 @@ static void tifm_sd_bounce_block(struct
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
+		pg = sg_page(&sg[host->sg_pos]) + (off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
--- a/drivers/mmc/host/usdhi6rol0.c~mmc-drop-nth_page-usage-within-sg-entry
+++ a/drivers/mmc/host/usdhi6rol0.c
@@ -323,7 +323,7 @@ static void usdhi6_blk_bounce(struct usd
 
 	host->head_pg.page	= host->pg.page;
 	host->head_pg.mapped	= host->pg.mapped;
-	host->pg.page		= nth_page(host->pg.page, 1);
+	host->pg.page		= host->pg.page + 1;
 	host->pg.mapped		= kmap(host->pg.page);
 
 	host->blk_page = host->bounce_buf;
@@ -503,7 +503,7 @@ static void usdhi6_sg_advance(struct usd
 	/* We cannot get here after crossing a page border */
 
 	/* Next page in the same SG */
-	host->pg.page = nth_page(sg_page(host->sg), host->page_idx);
+	host->pg.page = sg_page(host->sg) + host->page_idx;
 	host->pg.mapped = kmap(host->pg.page);
 	host->blk_page = host->pg.mapped;
 
_

Patches currently in -mm which might be from david@redhat.com are


