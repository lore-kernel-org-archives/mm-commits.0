Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D7817C9E
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628296; cv=none; b=n14eYDKNhEF+yiKuOYFX2dBp5ixAp+qk2z0rUeRpPMvXaIsbyxx3GZxMifkBhoRZ4VhC0vroCYqvjnG9z/Zrt+xWg/qVOwwbReJKUheaq+9wHCZVd5waNLDkMFkHUArdN6njyL6aky855XRGGr9EG8q6JdhmqjqKontifrbaAss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628296; c=relaxed/simple;
	bh=KsJQK7khpLVGjzK8Qld5A+s8U0J5WVmauS+PUtrzjd0=;
	h=Date:To:From:Subject:Message-Id; b=QzJtkY/1HaXpOZQoAYit4s7roP6CvSAIEUctMSrVRxKuZaRf0BlfZIlaTjEbi89VJzTMOQWKSXzN37I7y+8k6xmw+eTr6flF6yJf+sQ99PQLdRPhrUUSe7PjXDU/AZXSx/4Mj21LD0vXGsVoCbDI2wAdnN/kUR0XDaxeJeP+7/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f33h7/YJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f33h7/YJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5826AC116B1;
	Sat, 29 Jun 2024 02:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628296;
	bh=KsJQK7khpLVGjzK8Qld5A+s8U0J5WVmauS+PUtrzjd0=;
	h=Date:To:From:Subject:From;
	b=f33h7/YJSbdyyFf/R25460D2MIpXAMdqPdIL1WFKITfv957UK9zh5Kki2MHsXJ5/j
	 M71RuPMEAM2brTGMPoKwoIe63mwvfrgrIZUcEFe2kgIbWYNsc7EITkRNvh2x+W/jIA
	 YLRWkgvy9vzzeBUmfSv5MU5uKhUifF4fZ79ad6zE=
Date: Fri, 28 Jun 2024 19:31:35 -0700
To: mm-commits@vger.kernel.org,zhangpengpeng0808@gmail.com,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch removed from -mm tree
Message-Id: <20240629023136.5826AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: properly shorten readahead when falling back to do_page_cache_ra()
has been removed from the -mm tree.  Its filename was
     readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: properly shorten readahead when falling back to do_page_cache_ra()
Date: Tue, 25 Jun 2024 12:18:53 +0200

When we succeed in creating some folios in page_cache_ra_order() but then
need to fallback to single page folios, we don't shorten the amount to
read passed to do_page_cache_ra() by the amount we've already read.  This
then results in reading more and also in placing another readahead mark in
the middle of the readahead window which confuses readahead code.  Fix the
problem by properly reducing number of pages to read.

Link: https://lkml.kernel.org/r/20240625101909.12234-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Zhang Peng <zhangpengpeng0808@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/readahead.c~readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra
+++ a/mm/readahead.c
@@ -491,7 +491,8 @@ void page_cache_ra_order(struct readahea
 		struct file_ra_state *ra, unsigned int new_order)
 {
 	struct address_space *mapping = ractl->mapping;
-	pgoff_t index = readahead_index(ractl);
+	pgoff_t start = readahead_index(ractl);
+	pgoff_t index = start;
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
 	unsigned int nofs;
@@ -544,7 +545,7 @@ void page_cache_ra_order(struct readahea
 	if (!err)
 		return;
 fallback:
-	do_page_cache_ra(ractl, ra->size, ra->async_size);
+	do_page_cache_ra(ractl, ra->size - (index - start), ra->async_size);
 }
 
 /*
_

Patches currently in -mm which might be from jack@suse.cz are


