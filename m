Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9480199BC
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957024; cv=none; b=kGziIBNHyhjAdSwxc+/CEKPUHO51eyLt6TK7GxAMEWZkpldW6Fyi/3oVC1b+JYa28w8FGU53JE3Iu8rt2mzNLiVyqBSsAJ9xWHchQvo1hBk9oTifyWJuXbcFlvvpRN/GSmjKYxlbHJUEOGx1vy1/Q8BENjP79VvCfdjln07OOMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957024; c=relaxed/simple;
	bh=r+XwSENKcUL2WLeU/hY0F0ZHilvgs9b+iV2KV7zkt80=;
	h=Date:To:From:Subject:Message-Id; b=T/zOj+L9oYoiRioEeJoyCQXnRHk23WNQIlb/1Y6GyxbqvdeVKRIkuE/spg+D2p/WPvw9k2YFmxVd+zXj44JNh4z85h0ZNW2ApMDgurKRik1PCPwESYMjcivn3ERknZcpm0UxKH+B+iyDFuGm2/WP68zquXogoVsbTLBdBOooZuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZpvC0Md0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZpvC0Md0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFAEC116B1;
	Mon,  6 May 2024 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957023;
	bh=r+XwSENKcUL2WLeU/hY0F0ZHilvgs9b+iV2KV7zkt80=;
	h=Date:To:From:Subject:From;
	b=ZpvC0Md0DXqpuAYxluq95qNpOKefXAFIsgz3vB7+kPowjBSDpMPSFgJMrWlpzVCVq
	 ADR3DS/EmMAiMs9tkLJrMvQqwtlmCS7ge6QsAbPu4dKqDmpAlqa4jt0M95B/CcD01O
	 5qZJ5eykokRmi2ewqQNmLFYYPdg7lmWz8HfoP8zI=
Date: Sun, 05 May 2024 17:57:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,izik.eidus@ravellosystems.com,hughd@google.com,david@redhat.com,chrisw@sous-sol.org,aarcange@redhat.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-add-folio_set_stable_node.patch removed from -mm tree
Message-Id: <20240506005703.BDFAEC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: add folio_set_stable_node
has been removed from the -mm tree.  Its filename was
     mm-ksm-add-folio_set_stable_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Alex Shi (tencent)" <alexs@kernel.org>
Subject: mm/ksm: add folio_set_stable_node
Date: Thu, 11 Apr 2024 14:17:04 +0800

Turn set_page_stable_node() into a wrapper folio_set_stable_node, and then
use it to replace the former.  we will merge them together after all place
converted to folio.

Link: https://lkml.kernel.org/r/20240411061713.1847574-4-alexs@kernel.org
Signed-off-by: Alex Shi (tencent) <alexs@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-add-folio_set_stable_node
+++ a/mm/ksm.c
@@ -1109,6 +1109,12 @@ static inline void set_page_stable_node(
 	page->mapping = (void *)((unsigned long)stable_node | PAGE_MAPPING_KSM);
 }
 
+static inline void folio_set_stable_node(struct folio *folio,
+					 struct ksm_stable_node *stable_node)
+{
+	set_page_stable_node(&folio->page, stable_node);
+}
+
 #ifdef CONFIG_SYSFS
 /*
  * Only called through the sysfs control interface:
@@ -3241,7 +3247,7 @@ void folio_migrate_ksm(struct folio *new
 		 * has gone stale (or that folio_test_swapcache has been cleared).
 		 */
 		smp_wmb();
-		set_page_stable_node(&folio->page, NULL);
+		folio_set_stable_node(folio, NULL);
 	}
 }
 #endif /* CONFIG_MIGRATION */
_

Patches currently in -mm which might be from alexs@kernel.org are


