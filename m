Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F361257843
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 23:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757807351; cv=none; b=ibbDxfhD/MiGX6EThJH47N7heHzBEVV5j8dVZMeyy8U0//qHCEypOSe1uhrGp4KbRUkBPA5fqOfL7vs2AoXK6okixy0CcShN8WcnwWqXKnvHXZWnBM8pkIKJYWfUyiH27dP9lR6Y10JdxvW4UJhD4hUywewRnpcmEdiUggde110=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757807351; c=relaxed/simple;
	bh=T/lhynqK6KF6/mLV8N7jVpRB+yK4EyQWCC0ZHiI0ah8=;
	h=Date:To:From:Subject:Message-Id; b=qM+gxg6QeipXS8Ct2j9jcZ94VyUim3B1Sk40yzh1bV3NH3dx1g8I1uDPnq+70IgAd013CTH9JU8BjwUfL5gZHqRo4NqTlvEk0clKxc2aFZ9p3ijH1jgICzyVGJtsebc2d9bYMIwbYji50JIC3567cdwz0IF6BK2+Aypnhs6WWV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oNsCT68Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oNsCT68Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0D4C4CEEB;
	Sat, 13 Sep 2025 23:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757807350;
	bh=T/lhynqK6KF6/mLV8N7jVpRB+yK4EyQWCC0ZHiI0ah8=;
	h=Date:To:From:Subject:From;
	b=oNsCT68Qoh4702h2hxeXK8LpKqTyZ4DM7iesUwvD5dN/nnUJMWGrfWjncdV1DMDbF
	 4uU04YPEgLa7VtDluLY86SwnMgSS/gJcar0d+eUTSTJOwFsffgMNpMvjNGkj++kDwt
	 tr4Hao8ioNB1nakYBz67909C/KgnBlkW+SaeBD+A=
Date: Sat, 13 Sep 2025 16:48:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,willy@infradead.org,vschneid@redhat.com,viro@zeniv.linux.org.uk,vincent.guittot@linaro.org,vbabka@suse.cz,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,oleg@redhat.com,npache@redhat.com,namhyung@kernel.org,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mgorman@suse.de,mark.rutland@arm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,kan.liang@linux.intel.com,juri.lelli@redhat.com,jolsa@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jannh@google.com,jack@suse.cz,irogers@google.com,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dietmar.eggemann@arm.com,dev.jain@arm.com,david@redhat.com,davem@davemloft.net,chengming.zhou@linux.dev,bsegall@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,andreas@gaisler.com,alexander.shishkin@linux.intel.com,agordeev@linux.ibm.com,adrian.hunter@intel.com,acme@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-core-mm-to-mm_flags_-accessors-fix.patch removed from -mm tree
Message-Id: <20250913234910.5B0D4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-convert-core-mm-to-mm_flags_-accessors-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-core-mm-to-mm_flags_-accessors-fix.patch

This patch was dropped because it was folded into mm-convert-core-mm-to-mm_flags_-accessors.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-convert-core-mm-to-mm_flags_-accessors-fix
Date: Tue Aug 12 03:46:33 PM PDT 2025

fix typo in comment

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-convert-core-mm-to-mm_flags_-accessors-fix
+++ a/mm/khugepaged.c
@@ -1459,7 +1459,7 @@ static void collect_mm_slot(struct khuge
 		/*
 		 * Not strictly needed because the mm exited already.
 		 *
-		 * mm_clear(mm, MMF_VM_HUGEPAGE);
+		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
 		 */
 
 		/* khugepaged_mm_lock actually not necessary for the below */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

