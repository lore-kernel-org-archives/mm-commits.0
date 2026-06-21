Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DB6306744
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066759; cv=none; b=pc8GHirzC3upsIKgjp5ybX10whT54Qz79OwuWl8ubZcVznNsFH/bpGOk/qqyFNdzZEZXC17iyFAQkTUfmg0EE5ivdkhEFrCfRbJ0cEjNVjYkJ1DZ3Tk7JswyHcYyG47TfJxD4EDv1iLu7E7HDa6fyHY2hh3PERHdQ26wVh6dkZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066759; c=relaxed/simple;
	bh=odpJ5NJn63LTLq/VyRF/LNfDP5gEGC5aQOSLeFLc1vE=;
	h=Date:To:From:Subject:Message-Id; b=i6RUlMn/hD5d6rXSFV0Y9RUbziOvkI/Mg5mJIUzhuVp4eGO7oF3dOZeay1YySc3F8E93a3sOnP93JhXsrydP6F05ryoFmCPvh+ycXFBnMvuhtXKID/cgjSDZQbEIk2JSmrt+aHFqSmeGwDjFPwgU6WVqrZmz78DqX6xSp78MuFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RtrfGlew reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RtrfGlew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3CB1F000E9;
	Sun, 21 Jun 2026 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066757;
	bh=kq5GgEb1Y1feyyZp93Wk6o/WdP65rQp3rxewbx230D8=;
	h=Date:To:From:Subject;
	b=RtrfGlewfL07PEzPwk73fmBf4+1CRIgoBZJDVjstAhLn0qgvZkop/LDoFHl4W4JNi
	 XgL32Q6dZu+YQz4bh1QFwtLIBu5bSl4/jL5Idf5cZO3MPk9HzeIDDoiPKfRUqSLciA
	 8l5wIKm9T+wrKAY63KZJaTxKAcc2Py4zFhYD8aEM=
Date: Sun, 21 Jun 2026 11:32:37 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usama.arif@linux.dev,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.co
 m,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch removed from -mm tree
Message-Id: <20260621183237.8A3CB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: skip collapsing mTHP to smaller orders
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Fri, 5 Jun 2026 10:14:14 -0600

khugepaged may try to collapse a mTHP to a folio of equal or smaller size,
possibly resulting in a partially mapped source folio, which is undesired.
Skip these cases until we have a way to check if its ok to collapse to a
smaller mTHP size (like in the case of a partially mapped folio).  This
check is not done during the scan phase as the current collapse order is
unknown at that time.

This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].

Link: https://lore.kernel.org/20260605161422.213817-8-npache@redhat.com
Link: https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/ [1]
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-skip-collapsing-mthp-to-smaller-orders
+++ a/mm/khugepaged.c
@@ -697,6 +697,14 @@ static enum scan_result __collapse_huge_
 				goto out;
 			}
 		}
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (!is_pmd_order(order) && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
_

Patches currently in -mm which might be from npache@redhat.com are


