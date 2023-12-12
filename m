Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E8480029;
	Tue, 12 Dec 2023 18:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vEZe5Pve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAA8C433C9;
	Tue, 12 Dec 2023 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407584;
	bh=E3PG24pcH2YO5+ITHb2+lwTv1+0A7YHlh9K/VdvtriM=;
	h=Date:To:From:Subject:From;
	b=vEZe5PveND1Jh83lnyKJntP2O66zxqGxQKLdueacmjmmGTF7DAC7vqi1mQgagMmxG
	 BK9NSjokGXIiadbOxY3DnUvkKyDGVIMcuLVhDThYZsR2xmm6gTdc75b8PpWjJm6SGR
	 Plj2LFETnR58XVn+d5tfL96RzmVvLFgFgz7nQdbE=
Date: Tue, 12 Dec 2023 10:59:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,david@redhat.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-fix-misplaced-parenthesis-of-a-likely.patch removed from -mm tree
Message-Id: <20231212185944.6DAA8C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: fix misplaced parenthesis of a likely()
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-misplaced-parenthesis-of-a-likely.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: mm/rmap: fix misplaced parenthesis of a likely()
Date: Fri, 1 Dec 2023 14:59:36 -0500

From: Steven Rostedt (Google) <rostedt@goodmis.org>

Running my yearly branch profiler to see where likely/unlikely annotation
may be added or removed, I discovered this:

correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0   457918 100 page_try_dup_anon_rmap         rmap.h               264
[..]
  458021        0   0 page_try_dup_anon_rmap         rmap.h               265

I thought it was interesting that line 264 of rmap.h had a 100% incorrect
annotation, but the line directly below it was 100% correct. Looking at the
code:

	if (likely(!is_device_private_page(page) &&
	    unlikely(page_needs_cow_for_dma(vma, page))))

It didn't make sense. The "likely()" was around the entire if statement
(not just the "!is_device_private_page(page)"), which also included the
"unlikely()" portion of that if condition.

If the unlikely portion is unlikely to be true, that would make the entire
if condition unlikely to be true, so it made no sense at all to say the
entire if condition is true.

What is more likely to be likely is just the first part of the if statement
before the && operation. It's likely to be a misplaced parenthesis. And
after making the if condition broken into a likely() && unlikely(), both
now appear to be correct!

Link: https://lkml.kernel.org/r/20231201145936.5ddfdb50@gandalf.local.home
Fixes:fb3d824d1a46c ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-fix-misplaced-parenthesis-of-a-likely
+++ a/include/linux/rmap.h
@@ -261,8 +261,8 @@ static inline int page_try_dup_anon_rmap
 	 * guarantee the pinned page won't be randomly replaced in the
 	 * future on write faults.
 	 */
-	if (likely(!is_device_private_page(page) &&
-	    unlikely(page_needs_cow_for_dma(vma, page))))
+	if (likely(!is_device_private_page(page)) &&
+	    unlikely(page_needs_cow_for_dma(vma, page)))
 		return -EBUSY;
 
 	ClearPageAnonExclusive(page);
_

Patches currently in -mm which might be from rostedt@goodmis.org are


