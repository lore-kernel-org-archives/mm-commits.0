Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D6C13AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744941; cv=none; b=sbEahRFkdtMdKtQpSxDUIFd77vbjvi77/Z7MR8eComF3UBEewGjN6/4iqVrhNw6sbbLYDYq4nSjNOg6o9JhLL7E3XsCbYZMPryrz7ecNM3XtCngf2EflQwDM/sD/NB0WK5Cjarv/lvDoPrC+GRYwtGsHuuFRY0djlFQGCHrg2tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744941; c=relaxed/simple;
	bh=iTN2vvzpXqjJpzsL7W9XT+iWIRzggMMYH+4RGCodc8Q=;
	h=Date:To:From:Subject:Message-Id; b=ULm8T5NZYLubOzRhWJOayEjnH468e5iS1a8C0TdMXpkIK/SH8hz0lo13EdqESqzcuetGvFw4cv/DGsNUCrNi1P0rW9V54GB5KdkJdsB0iWTTNIYa6cyXjRt4FGSb0DdPO9p1FwLLUhXCpNVjIWC+IVxBGLqXNOhVzfW4wEPobGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Td0vnnK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Td0vnnK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0962EC4CEF7;
	Sun, 29 Mar 2026 00:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744941;
	bh=iTN2vvzpXqjJpzsL7W9XT+iWIRzggMMYH+4RGCodc8Q=;
	h=Date:To:From:Subject:From;
	b=Td0vnnK2qa6PDVhqJXHBUWGxsJirf3yuqRpd9m8a0S5WCXl0xZ++8fGdS5i5upRpG
	 viVKJSOdvFZUtWD9UE8zyKr/DlV+dnFlkap6hzojdNbUAlhp35/XL2tfxpbxvGiYnd
	 ZNI1Kmm8P9jw/floYqakN0ea4vEHHpJh+TIvvU/g=
Date: Sat, 28 Mar 2026 17:42:20 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-move-__section_mark_present-to-internalh.patch removed from -mm tree
Message-Id: <20260329004221.0962EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: move __section_mark_present() to internal.h
has been removed from the -mm tree.  Its filename was
     mm-sparse-move-__section_mark_present-to-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: move __section_mark_present() to internal.h
Date: Fri, 20 Mar 2026 23:13:46 +0100

Let's prepare for moving memory hotplug handling from sparse.c to
sparse-vmemmap.c by moving __section_mark_present() to internal.h.

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-14-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 +++++++++
 mm/sparse.c   |    8 --------
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/mm/internal.h~mm-sparse-move-__section_mark_present-to-internalh
+++ a/mm/internal.h
@@ -986,6 +986,15 @@ static inline void sparse_init_one_secti
 	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
 	ms->usage = usage;
 }
+
+static inline void __section_mark_present(struct mem_section *ms,
+		unsigned long section_nr)
+{
+	if (section_nr > __highest_present_section_nr)
+		__highest_present_section_nr = section_nr;
+
+	ms->section_mem_map |= SECTION_MARKED_PRESENT;
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
--- a/mm/sparse.c~mm-sparse-move-__section_mark_present-to-internalh
+++ a/mm/sparse.c
@@ -161,14 +161,6 @@ static void __meminit mminit_validate_me
  * those loops early.
  */
 unsigned long __highest_present_section_nr;
-static void __section_mark_present(struct mem_section *ms,
-		unsigned long section_nr)
-{
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
-
-	ms->section_mem_map |= SECTION_MARKED_PRESENT;
-}
 
 static inline unsigned long first_present_section_nr(void)
 {
_

Patches currently in -mm which might be from david@kernel.org are


