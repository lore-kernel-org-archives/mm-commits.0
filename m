Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA231EC015
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 20:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731010290; cv=none; b=ntx1Mc8jqozB3NEAXBxGGzmaVVQsVdtpOaqJeO8xt93v9h1pn8OgTlGiSq+gHR7THGk+GHusqPtLUiQ5nSI1wxMgCRTOEn6Z3QZ7vIrSvkzZsK+JoaP5Z3xNhFwMAMoNOkVyYFuLIdUVqGct/YOW+4vnTo51or7jUpVWg3CRIVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731010290; c=relaxed/simple;
	bh=FdV1iPpltK4QTZ8Dq+cjoqggT41uuhVj9faLSgcaTug=;
	h=Date:To:From:Subject:Message-Id; b=KylBm50ozXUnDRDpUS7waefpvikrn/H59EWeOnP6StipAuSrfOEkdhFGtUYmMi/5WIn4PgNg5+9+TTyKBKX/Fpic24/aLNnXfJfbQo2RmOrFu8E2yNjPuH2up7X1Ui5J0qgPeM5qQSYeOie2Mfa7U+lTb2cgfzZaZvXP2quuPJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2PhcNcUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2PhcNcUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDF6C4CECC;
	Thu,  7 Nov 2024 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731010290;
	bh=FdV1iPpltK4QTZ8Dq+cjoqggT41uuhVj9faLSgcaTug=;
	h=Date:To:From:Subject:From;
	b=2PhcNcUiWUsiQxFzX4TTHPj9p9rgU2eBW8RANsHkh5q/itUoNpX6Z70SfQSBfMBua
	 pm4rUskKQ+viDNtN52vmG5h513/xzW8xyfdnx4stz2LcJoJNIWsiCImv9ZyXAp1HFE
	 yHe3IlZfl1mPusk50N3xOJ3vicxsGnMr0Xbit7YY=
Date: Thu, 07 Nov 2024 12:11:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-readahead-fix-large-folio-support-in-async-readahead.patch removed from -mm tree
Message-Id: <20241107201130.0DDF6C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: fix large folio support in async readahead
has been removed from the -mm tree.  Its filename was
     mm-readahead-fix-large-folio-support-in-async-readahead.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm/readahead: fix large folio support in async readahead
Date: Wed, 6 Nov 2024 17:21:14 +0800

When testing large folio support with XFS on our servers, we observed that
only a few large folios are mapped when reading large files via mmap. 
After a thorough analysis, I identified it was caused by the
`/sys/block/*/queue/read_ahead_kb` setting.  On our test servers, this
parameter is set to 128KB.  After I tune it to 2MB, the large folio can
work as expected.  However, I believe the large folio behavior should not
be dependent on the value of read_ahead_kb.  It would be more robust if
the kernel can automatically adopt to it.

With `/sys/block/*/queue/read_ahead_kb` set to a non-2MB aligned size,
this issue can be verified with a simple test case, as shown below:

      #define LEN (1024 * 1024 * 1024) // 1GB file
      int main(int argc, char *argv[])
      {
          char *addr;
          int fd, i;

          fd = open("data", O_RDWR);
          if (fd < 0) {
              perror("open");
              exit(-1);
          }

          addr = mmap(NULL, LEN, PROT_READ|PROT_WRITE,
                      MAP_SHARED, fd, 0);
          if (addr == MAP_FAILED) {
              perror("mmap");
              exit(-1);
          }

          if (madvise(addr, LEN, MADV_HUGEPAGE)) {
              perror("madvise");
              exit(-1);
          }

          for (i = 0; i < LEN / 4096; i++)
                memset(addr + i * 4096, 1, 1);

          while (1) {} // Verifiable with /proc/meminfo

          munmap(addr, LEN);
          close(fd);
          exit(0);
      }

When large folio support is enabled and read_ahead_kb is set to a smaller
value, ra->size (4MB) may exceed the maximum allowed size (e.g., 128KB). 
To address this, we need to add a conditional check for such cases. 
However, this alone is insufficient, as users might set read_ahead_kb to a
larger, non-hugepage-aligned value (e.g., 4MB + 128KB).  In these
instances, it is essential to explicitly align ra->size with the hugepage
size.

Link: https://lkml.kernel.org/r/20241106092114.8408-1-laoar.shao@gmail.com
Fixes: 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/readahead.c~mm-readahead-fix-large-folio-support-in-async-readahead
+++ a/mm/readahead.c
@@ -390,6 +390,8 @@ static unsigned long get_next_ra_size(st
 		return 4 * cur;
 	if (cur <= max / 2)
 		return 2 * cur;
+	if (cur > max)
+		return cur;
 	return max;
 }
 
@@ -647,7 +649,7 @@ void page_cache_async_ra(struct readahea
 			1UL << order);
 	if (index == expected) {
 		ra->start += ra->size;
-		ra->size = get_next_ra_size(ra, max_pages);
+		ra->size = ALIGN(get_next_ra_size(ra, max_pages), 1 << order);
 		ra->async_size = ra->size;
 		goto readit;
 	}
_

Patches currently in -mm which might be from laoar.shao@gmail.com are


