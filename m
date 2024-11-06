Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE03F1514CC
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 21:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730927028; cv=none; b=NJLcT/ZnVW8SpdQPE4OJVxKG+PS9GyChYft6y2mXur8mh1gshHw4GgNS0TN9OaDQbDU4PdUjvQHPIO7JwqUUKfOmKu9EUScMO/SN1zPdsDYQ/0vcex3W9f3CgHd56syFpKcOvOug4Q4m5+SAbLz6aM0iDkAnVlYqI0qt6stxjTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730927028; c=relaxed/simple;
	bh=Ij46WCPnW1NW3WE6rUU1hxNUPG8gtV4JVyoBF9KBvSQ=;
	h=Date:To:From:Subject:Message-Id; b=NRhuiR3HOe6SCSYNDQYJnqSVoQpGHEYOHZ1m7JvLlm0WKq5ol6cyJCDc8gGAwcAAuRKxBslzV50bu68NKHOl1GwiKXBjD7LVRUfcQdEWraKIuSglSAeMnR74+o6uKAANr3bR5+Dwb/O+di9YCE8zPRFrzZIFkDAQkA3t3mc/i/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W6xr15pA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W6xr15pA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C32C4CEC6;
	Wed,  6 Nov 2024 21:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730927028;
	bh=Ij46WCPnW1NW3WE6rUU1hxNUPG8gtV4JVyoBF9KBvSQ=;
	h=Date:To:From:Subject:From;
	b=W6xr15pAbJpf3YRGcu6imeDKpOwJL/YE52ZtZIZb9R6I3rgL5MhY3lllrWVbtFFiV
	 OsmzgAgOhyJtzfsbwyplCnNqllOqJ+3IHc/H3ckEKq7mcoglUJIfLqr+fCZJ0zXhKN
	 JCd0xP0GZIND30uLcDDplj8BM4p1ur+0AUfM1gdU=
Date: Wed, 06 Nov 2024 13:03:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,laoar.shao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-fix-large-folio-support-in-async-readahead.patch added to mm-unstable branch
Message-Id: <20241106210348.14C32C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: fix large folio support in async readahead
has been added to the -mm mm-unstable branch.  Its filename is
     mm-readahead-fix-large-folio-support-in-async-readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-fix-large-folio-support-in-async-readahead.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-readahead-fix-large-folio-support-in-async-readahead.patch

