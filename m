Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A51C5F06
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274547; cv=none; b=sVZcSd4A/K/xehSREHO+vtl6frcPvMH6SFZ/sgQE6eWk+7Im+WW9/LtQRqYhUsnxl2a4/d14hzoINaQM3cJPfJ+BqDlV4BUf6VwIEA19a1zWuOvsioWQipaB/F6uyZDUN5bUQznCcSA1JXEtKpr8x0bp0JmKx++YDRMj5j7WFmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274547; c=relaxed/simple;
	bh=fmaHYgWfCPrjI08O/muR/nnyjCS0KfE2BTucIpIOeDM=;
	h=Date:To:From:Subject:Message-Id; b=U0o+d0bUtNicWAEDS7PKTGH89iwMZzMiJqX6zWsuYAW0AUzI7dLnRligpUnJpqbUGTYr5KyT4GEXEju0vPhzQViXj1A7KekTv8bBpPvju5FklSICDn1y/0PybKgCXr+Ey8o6BCfvUrJEBs1oR2MhRgMGgfXimPdICVgyf45ml0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YHFZLMrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YHFZLMrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55001C4CEDD;
	Tue, 18 Mar 2025 05:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274547;
	bh=fmaHYgWfCPrjI08O/muR/nnyjCS0KfE2BTucIpIOeDM=;
	h=Date:To:From:Subject:From;
	b=YHFZLMrsWXvRk7Mn+CB2u82SoRGkUJxe0rp40TYl0HNUKOKnZwyKM5BQaubOUVYei
	 8UD8SWke1ZH9Fg9lVrtdQsUt2NNE1d/O0ChVAGk6P3Lcj+ugqGrza/vF9whp+GdHmX
	 Qz57CI1lqIGmo5mrxe8s4I8vrgI02Wf3RkgiWZfY=
Date: Mon, 17 Mar 2025 22:09:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch removed from -mm tree
Message-Id: <20250318050907.55001C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: CONFIG_NO_PAGE_MAPCOUNT to prepare for not maintain per-page mapcounts in large folios
has been removed from the -mm tree.  Its filename was
     mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: CONFIG_NO_PAGE_MAPCOUNT to prepare for not maintain per-page mapcounts in large folios
Date: Mon, 3 Mar 2025 17:30:08 +0100

We're close to the finishing line: let's introduce a new
CONFIG_NO_PAGE_MAPCOUNT config option where we will incrementally remove
any dependencies on per-page mapcounts in large folios.  Once that's done,
we'll stop maintaining the per-page mapcounts with this config option
enabled.

CONFIG_NO_PAGE_MAPCOUNT will be EXPERIMENTAL for now, as we'll have to
learn about some of the real world impact of some of the implications.

As writing "!CONFIG_NO_PAGE_MAPCOUNT" is really nasty, let's introduce a
helper config option "CONFIG_PAGE_MAPCOUNT" that expresses the negation.

Link: https://lkml.kernel.org/r/20250303163014.1128035-16-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/Kconfig~mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios
+++ a/mm/Kconfig
@@ -887,8 +887,25 @@ config READ_ONLY_THP_FOR_FS
 	  support of file THPs will be developed in the next few release
 	  cycles.
 
+config NO_PAGE_MAPCOUNT
+	bool "No per-page mapcount (EXPERIMENTAL)"
+	help
+	  Do not maintain per-page mapcounts for pages part of larger
+	  allocations, such as transparent huge pages.
+
+	  When this config option is enabled, some interfaces that relied on
+	  this information will rely on less-precise per-allocation information
+	  instead: for example, using the average per-page mapcount in such
+	  a large allocation instead of the per-page mapcount.
+
+	  EXPERIMENTAL because the impact of some changes is still unclear.
+
 endif # TRANSPARENT_HUGEPAGE
 
+# simple helper to make the code a bit easier to read
+config PAGE_MAPCOUNT
+	def_bool !NO_PAGE_MAPCOUNT
+
 #
 # The architecture supports pgtable leaves that is larger than PAGE_SIZE
 #
_

Patches currently in -mm which might be from david@redhat.com are


