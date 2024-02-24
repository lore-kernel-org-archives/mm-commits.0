Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A872579F4
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739458; cv=none; b=qF01+63Np9rJIxjD8odHP70QZcUEASeZERCSXiET4aR1sHiXZgG8F3uFRSa8oG/5h6U+skpSkCgz1/1rwr7ic/vTgquy5d1qtgdYHamBw3uTLhK81RYU3mXTdBNosXFS/fJZu2i13ENolTwxIVEcCzobr1ve6Ztt5LzPkG5eUho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739458; c=relaxed/simple;
	bh=hmJG1Wot8T8gf9wPg5QW/gHY9VgexmVwK/tb4XMYVmA=;
	h=Date:To:From:Subject:Message-Id; b=USy3PnML1bGSwLzylQ/4qBG3WwLhMdg0Gyez2R0TChrFNkBHufjrFmW6zaJJ0nEtdZxrXLGnVcchRG3TiGq2CWFxMWAXqzNcPEEjHehpG3nCb0pQwsaVsbupR3G/PdkX1f9mVKQjBNfWHjdaJc79y9XveBfEO6bDOigdLlxeC7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lA38ZtxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lA38ZtxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C403C43394;
	Sat, 24 Feb 2024 01:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739458;
	bh=hmJG1Wot8T8gf9wPg5QW/gHY9VgexmVwK/tb4XMYVmA=;
	h=Date:To:From:Subject:From;
	b=lA38ZtxFVSaC4DUg2aobjC2KMUPBjQmqSgMqoSn33ZvW/It3+2/WhWLF7A8Jp+Gwg
	 N2N01U2FibTvW6jFNrkr/F1uOiOZOoJ/8/65pcP8VFCVKOtkrlk3J8zL7h5wtjXZn3
	 YcpljqjdpYHiC+aDgy5RsnfBxWvzzbIfC/CnhiYo=
Date: Fri, 23 Feb 2024 17:50:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,dhowells@redhat.com,dchinner@redhat.com,brauner@kernel.org,bfoster@redhat.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch removed from -mm tree
Message-Id: <20240224015058.7C403C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: writeback: fix done_index when hitting the wbc->nr_to_write
has been removed from the -mm tree.  Its filename was
     writeback-fix-done_index-when-hitting-the-wbc-nr_to_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: writeback: fix done_index when hitting the wbc->nr_to_write
Date: Thu, 15 Feb 2024 07:36:38 +0100

When write_cache_pages finishes writing out a folio, it fails to update
done_index to account for the number of pages in the folio just written. 
That means when range_cyclic writeback is restarted, it will be restarted
at this folio instead of after it as it should.  Fix that by updating
done_index before breaking out of the loop.

Link: https://lkml.kernel.org/r/20240215063649.2164017-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page-writeback.c~writeback-fix-done_index-when-hitting-the-wbc-nr_to_write
+++ a/mm/page-writeback.c
@@ -2505,6 +2505,7 @@ continue_unlock:
 			 * keep going until we have written all the pages
 			 * we tagged for writeback prior to entering this loop.
 			 */
+			done_index = folio->index + nr;
 			wbc->nr_to_write -= nr;
 			if (wbc->nr_to_write <= 0 &&
 			    wbc->sync_mode == WB_SYNC_NONE) {
_

Patches currently in -mm which might be from hch@lst.de are


