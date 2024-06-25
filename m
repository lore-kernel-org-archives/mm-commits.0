Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA8B38F9A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 03:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287561; cv=none; b=VKt0HvRdp4sayRsINzEb2o3XVBa/ACwM6umyHTrlFwUkuYymjXaYxxVK8HzgXIt72Fn7KUhRAQ4CKzPwY/2+6VUv7VSev2jfEGTsh363tVzaZ4n3NFutUdXVV4FN3pLYHUyfaG/gAMQaQU9KmXdtQM+liaLBeEbKN1Zfmj5gCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287561; c=relaxed/simple;
	bh=L/l453ScAZQ5nZef32ylAIhiGvq3D8o+QTZC2PAvXfA=;
	h=Date:To:From:Subject:Message-Id; b=giw4xWjfzFMNFdy9af5UavcFASTfdacJjLFI9l4XVOI17sW8SKdd7p6UY205xQp/8YIX/zt2/uTMtIzA6m32w6ljaSWmYKyc+bj6cnfbQhRRgsGAxJCvRpVlvWVJhcQZ9mw9M/NKt1UjHKjGf0oA2/bQ9ATnGGjpw84cXuCEV0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y9+CP7p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y9+CP7p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431D6C32789;
	Tue, 25 Jun 2024 03:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287561;
	bh=L/l453ScAZQ5nZef32ylAIhiGvq3D8o+QTZC2PAvXfA=;
	h=Date:To:From:Subject:From;
	b=Y9+CP7p3U4mKVPqRNJvfrTTS8nnT2YAq9+pY8b+svJpZahKK7PHj8W7bw2ZlIyg6w
	 l09r3Xfj0UigY7gHtndupoKrBqkaDeFsXL7P+rMAxGi9P7tG5/jU5HkNZ4c5ogjnoA
	 j0SnreObVfIo8J9zcH7ksWpuIUwQA0Ti1DCSsj/0=
Date: Mon, 24 Jun 2024 20:52:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,osandov@osandov.com,gehao@kylinos.cn,david@redhat.com,stephen.s.brennan@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-convert-page-type-macros-to-enum.patch removed from -mm tree
Message-Id: <20240625035241.431D6C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert page type macros to enum
has been removed from the -mm tree.  Its filename was
     mm-convert-page-type-macros-to-enum.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: mm: convert page type macros to enum
Date: Fri, 7 Jun 2024 13:29:53 -0700

Changing PG_slab from a page flag to a page type in commit 46df8e73a4a3
("mm: free up PG_slab") in has the unintended consequence of removing the
PG_slab constant from kernel debuginfo.  The commit does add the value to
the vmcoreinfo note, which allows debuggers to find the value without
hardcoding it.  However it's most flexible to continue representing the
constant with an enum.  To that end, convert the page type fields into an
enum.  Debuggers will now be able to detect that PG_slab's type has
changed from enum pageflags to enum pagetype.

Link: https://lkml.kernel.org/r/20240607202954.1198180-1-stephen.s.brennan@oracle.com
Fixes: 46df8e73a4a3 ("mm: free up PG_slab")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hao Ge <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/include/linux/page-flags.h~mm-convert-page-type-macros-to-enum
+++ a/include/linux/page-flags.h
@@ -944,15 +944,18 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
  * mistaken for a page type value.
  */
 
-#define PAGE_TYPE_BASE	0xf0000000
-/* Reserve		0x0000007f to catch underflows of _mapcount */
-#define PAGE_MAPCOUNT_RESERVE	-128
-#define PG_buddy	0x00000080
-#define PG_offline	0x00000100
-#define PG_table	0x00000200
-#define PG_guard	0x00000400
-#define PG_hugetlb	0x00000800
-#define PG_slab		0x00001000
+enum pagetype {
+	PG_buddy	= 0x00000080,
+	PG_offline	= 0x00000100,
+	PG_table	= 0x00000200,
+	PG_guard	= 0x00000400,
+	PG_hugetlb	= 0x00000800,
+	PG_slab		= 0x00001000,
+
+	PAGE_TYPE_BASE	= 0xf0000000,
+	/* Reserve 0x0000007f to catch underflows of _mapcount */
+	PAGE_MAPCOUNT_RESERVE	= -128,
+};
 
 #define PageType(page, flag)						\
 	((page->page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
_

Patches currently in -mm which might be from stephen.s.brennan@oracle.com are


