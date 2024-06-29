Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876D615E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628297; cv=none; b=dI0YOdURO2C4UskjDUKSc1uEfNM9AxKiSNljxn9xEoON4HHjpq0y4x+ZoyBVciWMUHmEW0teq2gqRZSSWODnrxgtwcV+KMMT6+LjWniKaKrXrBfz+ENlHAboTDWj4BErQwaqrnxwMw/cdtnvODn0nBQ7sXw3iS5iMdIN5qREHDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628297; c=relaxed/simple;
	bh=FfFmZQ+2MQVNLkQ05ZvYk7YCCPDDhFQfARyPfu8p7m4=;
	h=Date:To:From:Subject:Message-Id; b=UgpOYY0l018SnTPP0PIdoqQ75dfk53HjFif80tm31CL4cyXWeTOia2YIXuqwveLYVrtMi1bwzTyGDw1eBQoeneY0ai2wVgMokboyKz8mE12CrSg71RQuPl6PKeBuDuWpJmkTpg8N609JrE2kmruKX8c9QxSFl5M/1WeDK88MxDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rs0lPXfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rs0lPXfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D627C116B1;
	Sat, 29 Jun 2024 02:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628297;
	bh=FfFmZQ+2MQVNLkQ05ZvYk7YCCPDDhFQfARyPfu8p7m4=;
	h=Date:To:From:Subject:From;
	b=rs0lPXfEL58QSMWdrvUfhWzLAojMvsuJ0qqrHvOpNgJdxp5cCLU+Bo9UuZTkG5QbR
	 hNUXAUTBL1jvEKI6fYAxESKheY7NoYKuZ1hf/X0tefkRvNt6mkU2k//gNtEDSN/8KF
	 sX+0D32QFke7eC5A1/vCwNcjFZIa0LG+SwgmKiZM=
Date: Fri, 28 Jun 2024 19:31:36 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-drop-pointless-index-from-force_page_cache_ra.patch removed from -mm tree
Message-Id: <20240629023137.5D627C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: drop pointless index from force_page_cache_ra()
has been removed from the -mm tree.  Its filename was
     readahead-drop-pointless-index-from-force_page_cache_ra.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: drop pointless index from force_page_cache_ra()
Date: Tue, 25 Jun 2024 12:18:54 +0200

Current index to readahead is tracked in readahead_control and properly
updated by page_cache_ra_unbounded() (read_pages() in fact).  So there's
no need to track the index separately in force_page_cache_ra().

Link: https://lkml.kernel.org/r/20240625101909.12234-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/readahead.c~readahead-drop-pointless-index-from-force_page_cache_ra
+++ a/mm/readahead.c
@@ -313,7 +313,7 @@ void force_page_cache_ra(struct readahea
 	struct address_space *mapping = ractl->mapping;
 	struct file_ra_state *ra = ractl->ra;
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	unsigned long max_pages, index;
+	unsigned long max_pages;
 
 	if (unlikely(!mapping->a_ops->read_folio && !mapping->a_ops->readahead))
 		return;
@@ -322,7 +322,6 @@ void force_page_cache_ra(struct readahea
 	 * If the request exceeds the readahead window, allow the read to
 	 * be up to the optimal hardware IO size
 	 */
-	index = readahead_index(ractl);
 	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
 	nr_to_read = min_t(unsigned long, nr_to_read, max_pages);
 	while (nr_to_read) {
@@ -330,10 +329,8 @@ void force_page_cache_ra(struct readahea
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
-		ractl->_index = index;
 		do_page_cache_ra(ractl, this_chunk, 0);
 
-		index += this_chunk;
 		nr_to_read -= this_chunk;
 	}
 }
_

Patches currently in -mm which might be from jack@suse.cz are


