Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F4115ADB4
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313713; cv=none; b=ofywvFgoIYZxDjnpYtGw8a799eNq/xtGWNso0W/KTYUOvcnaLmcxP2tUo6rMvGsCRIEjujZvn3lPG/B2JeIRiGA6gFAj20hAnPugEyHKukbQCTESKo2Epn7pNq4GFku6AXiS+VgYNwt7V52Vb8kVrKtn731w/kniFLLV+eml5qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313713; c=relaxed/simple;
	bh=Frd3znnHE80H02i1n+okE7vuRwk1KWhL6LnuBgFKEJA=;
	h=Date:To:From:Subject:Message-Id; b=I1rOuIJoIL7KsYTaMzO65PkwsKv6a8QNE8FneuJJFxgjCZABP/qRVloC1TSOhSWJ/iSz0ziO4iJ1rZFqGG8mmzLBcqi0PbWKYHqNot1Ibhd/5LLXbJ5+rO/0vQ56J77QCO4TjAHP1BPE1nZ9OtoNVP4DWk7Ig/toOI/mEk0vTs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DfQc3zCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DfQc3zCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6B3C4CED0;
	Mon, 11 Nov 2024 08:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313712;
	bh=Frd3znnHE80H02i1n+okE7vuRwk1KWhL6LnuBgFKEJA=;
	h=Date:To:From:Subject:From;
	b=DfQc3zCmVKMu1WGtozGCAYGf37P3x5RvdXr9326BXoNKs1NSOugnELq3F7YDyZTqL
	 TaVwjPayCVBf/T+gjXnqzMfVjC7O2Hhn7+hhsKjwGomEyytmFUxo95afIA3tW0+t5i
	 Zzvmvl5J4r6PFdzWbla1RMp+Kg9InE+3Pct0Ilug=
Date: Mon, 11 Nov 2024 00:28:32 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,kawasin@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-clear-idle-flag-after-recompression.patch removed from -mm tree
Message-Id: <20241111082832.CB6B3C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: clear IDLE flag after recompression
has been removed from the -mm tree.  Its filename was
     zram-clear-idle-flag-after-recompression.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: clear IDLE flag after recompression
Date: Tue, 29 Oct 2024 00:36:14 +0900

Patch series "zram: IDLE flag handling fixes", v2.

zram can wrongly preserve ZRAM_IDLE flag on its entries which can result
in premature post-processing (writeback and recompression) of such
entries.


This patch (of 2)

Recompression should clear ZRAM_IDLE flag on the entries it has accessed,
because otherwise some entries, specifically those for which recompression
has failed, become immediate candidate entries for another post-processing
(e.g.  writeback).

Consider the following case:
- recompression marks entries IDLE every 4 hours and attempts
  to recompress them
- some entries are incompressible, so we keep them intact and
  hence preserve IDLE flag
- writeback marks entries IDLE every 8 hours and writebacks
  IDLE entries, however we have IDLE entries left from
  recompression, so writeback prematurely writebacks those
  entries.

The bug was reported by Shin Kawamura.

Link: https://lkml.kernel.org/r/20241028153629.1479791-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20241028153629.1479791-2-senozhatsky@chromium.org
Fixes: 84b33bf78889 ("zram: introduce recompress sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-clear-idle-flag-after-recompression
+++ a/drivers/block/zram/zram_drv.c
@@ -1864,6 +1864,13 @@ static int recompress_slot(struct zram *
 	if (ret)
 		return ret;
 
+	/*
+	 * We touched this entry so mark it as non-IDLE. This makes sure that
+	 * we don't preserve IDLE flag and don't incorrectly pick this entry
+	 * for different post-processing type (e.g. writeback).
+	 */
+	zram_clear_flag(zram, index, ZRAM_IDLE);
+
 	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
 	/*
 	 * Iterate the secondary comp algorithms list (in order of priority)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


