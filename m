Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D416014AD2E;
	Tue, 19 Nov 2024 04:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731990961; cv=none; b=P3/lXLAApC3T5hrqS24upex1S08MAkGEDqSckTQ5I1SQNSr2/B+KedfFsaf8Zrx/nAtSIZDo5OYtCMBMgjrtcebGeZp3XpyvxYDZ1sOzQhjmQKVB8Mhxz6cERon6OCiOgTjWAva09/dg6kCbLHW1wAwyWc765qvzmjnoJLroucM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731990961; c=relaxed/simple;
	bh=xqKXgl+3h93ZGayYZe07es5W8/ttzXOcIBkHV2PoluA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGlbAyEJoL7Xd8sEpMVej/bmybRk8zhelhOaFgEHf+Aw4FYYQrLS4lwPSDEyDu5fWE+soRBwco9A4IxP9asxJims0/yE6QGNb+EOHVqOCU/2l0UtgxctJpdSxBqythYAMuG26CDc2NRjx0VXt70/0cGpenkNS9omealAzK+kBtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bD+Ns0SG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bD+Ns0SG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NYXK4nFnPpYMEZT3S9Dt2971MXd1ugdi63573+G36wI=; b=bD+Ns0SGIFFAmzjZjGEG4Gu05W
	It8124t3EJvCXRFnwEY80jO+xt9BaQXUIOlg8JeUjrIWZBcwda3PsMNFqMOjdeFeutEK0A/i2h/5h
	cusCExaBqIQWO/wJmf4Dy5pUFJDL7rFRItQbo4sz7dOWIC7T97B+Bt/UFrg+/qX8Gw8ykT5pPRYLo
	RFql7zmbxGE2EDJnO9/aOhf6JLOihccPny3t0K2D5BhPT1xU2FKuV4OFxY+GyiDW9YT3O2qv2HyTW
	Ui4ssg9GknGqiMqaNw82R3otvqJUDe5Ke6QSPaxdQ/3+Uwlbf/MY0TC2oLMRSraEnP0/XuGhYQ/2C
	sEJG6ksw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDFxr-00000003gdx-1TVR;
	Tue, 19 Nov 2024 04:35:47 +0000
Date: Tue, 19 Nov 2024 04:35:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.13-rc1
Message-ID: <ZzwVo0ZbuG37pHdR@casper.infradead.org>
References: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>

On Mon, Nov 18, 2024 at 07:30:01PM -0800, Andrew Morton wrote:
> Matthew Wilcox (Oracle) (13):
>       ksm: use a folio in try_to_merge_one_page()
>       ksm: convert cmp_and_merge_page() to use a folio

Unfortunately you left the crap patch in from Gaosheng.  Linus, can you
apply this fixup?

From 3d7e7319bbb3ced1dfb9c82bb7e8c7386380799b Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 18 Nov 2024 23:32:25 -0500
Subject: [PATCH] mm: Revert IS_ERR_OR_NULL check

&foo->bar is address arithmetic, not a dereference of foo.
Huawei engineers seem particularly prone to not knowing this.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/ksm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7ac59cde626c..31a9bc365437 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2261,8 +2261,7 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 
 	/* Start by searching for the folio in the stable tree */
 	kfolio = stable_tree_search(page);
-	if (!IS_ERR_OR_NULL(kfolio) && &kfolio->page == page &&
-	    rmap_item->head == stable_node) {
+	if (&kfolio->page == page && rmap_item->head == stable_node) {
 		folio_put(kfolio);
 		return;
 	}
-- 
2.45.2

