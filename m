Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D0A25A2D1
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085556; cv=none; b=FECazVQWPHLMApVYlQhRdPOIvRq5/ceWQHbGd+rqbhkQveh+WqsDXl3qBGaDXd0rU5MQdWH+mbn9m8RlBP134sZZoMDW8imHzhu9WTVmBRrQrRQOAhjUlA1dZh/rOdT9CbOQVd6S1ZAhDulMW6LF96EG0bA4ysuNkmt4Cicy8BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085556; c=relaxed/simple;
	bh=+mFV/eJIktrfZdQ1D2l2k88shbBMnwCX3SIpBzHbUXg=;
	h=Date:To:From:Subject:Message-Id; b=Ik9IvJ3tP50jAtPl8iftbanP+KHwtQX3L9b+EkDMBC+Y6Ti5loORg40A2A9h3giCY2RiSPbzLbh/PFMCxqI6rpz0G7zQo04jrM6k18YAuF4zReUmYw/thfTJkVUG/gP4E3+5KQ2grNvVjo22GsjXVh2Gd+izjSwBudDsBfl6fSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WbefvnO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WbefvnO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95117C4CEF0;
	Sun, 28 Sep 2025 18:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085555;
	bh=+mFV/eJIktrfZdQ1D2l2k88shbBMnwCX3SIpBzHbUXg=;
	h=Date:To:From:Subject:From;
	b=WbefvnO8h6sogm1MH5Q/eLvQHh0VQn9uxjvNkq/wfmORGl8T4aBM5e153xPZI4MBr
	 F/BPL4s09kvHJgy/5mQImd2ZNsnXYLltDVxH9XL7hNCpHg4gra/U0RA2J0R/du4JpY
	 sOlQI973k7WYmQ/ZXkmQarHqUxVnUNg4cSsYWpx8=
Date: Sun, 28 Sep 2025 11:52:35 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-folio_page-back-to-a-macro.patch removed from -mm tree
Message-Id: <20250928185235.95117C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert folio_page() back to a macro
has been removed from the -mm tree.  Its filename was
     mm-convert-folio_page-back-to-a-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: convert folio_page() back to a macro
Date: Tue, 23 Sep 2025 16:00:58 +0200

In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
we converted folio_page() into a static inline function.  However briefly
afterwards in commit a847b17009ec ("mm: constify highmem related functions
for improved const-correctness") we had to add some nasty const-away
casting to make the compiler happy when checking const correctness.

So let's just convert it back to a simple macro so the compiler can check
const correctness properly.  There is the alternative of using a
_Generic() similar to page_folio(), but there is not a lot of benefit
compared to just using a simple macro.

Link: https://lkml.kernel.org/r/20250923140058.2020023-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-convert-folio_page-back-to-a-macro
+++ a/include/linux/page-flags.h
@@ -316,10 +316,7 @@ static __always_inline unsigned long _co
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-static inline struct page *folio_page(const struct folio *folio, unsigned long n)
-{
-	return (struct page *)(&folio->page + n);
-}
+#define folio_page(folio, n)	(&(folio)->page + (n))
 
 static __always_inline int PageTail(const struct page *page)
 {
_

Patches currently in -mm which might be from david@redhat.com are


