Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69363C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011137; cv=none; b=pcfVg0d7WpZVajSixppULyYhOKJcjYBJgyjLB0pndA2gN4a7QBAZRpcXYTWM/dhL0xPj0MuUdFLWrhfi8fwjKKjjP3n71/AkJY+khXz1o8iwSI5E9rdOg1JBgniMXCRhMQWm/omy4lu0MoRUITByukRJeeWWKbKQYcZdqb8yk6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011137; c=relaxed/simple;
	bh=3mv1Ro1Dx5fL2A1tOB8zkJnr0ewQualYm4IXce6+PAY=;
	h=Date:To:From:Subject:Message-Id; b=cM4ZdhZdQcsEy/NtcT/FxCsA6wkHN1xBlNuLul/SlOihTO2eg2zSgEohiKogMtQ54JLBZHY23ilVDREUbGU6cNlEF5g/BSMX5kw04YtOHhT0YcZTPmuVUD/PevEAOWYDoaPOQ4PTbrNlULPCYMH4ZZfr4nt7Udm7Tom6/DoAsoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SdVMP9OP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SdVMP9OP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A90C4CEE4;
	Mon, 12 May 2025 00:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011137;
	bh=3mv1Ro1Dx5fL2A1tOB8zkJnr0ewQualYm4IXce6+PAY=;
	h=Date:To:From:Subject:From;
	b=SdVMP9OPI8P0IswRmFBDDdCndwQELCAS48mWAARObPv/q+fAAl1BitF+0ndU9S1sQ
	 M7oVWrssKfxB9MWY2dOnqMWHNzcds8wkLPlKMfLqS9ll8/d5A0Jru5IQSmRISO1xa/
	 wn7anLXtSUmYLH6opOwby7EVbUlqGbuh0W6+9Cjs=
Date: Sun, 11 May 2025 17:52:16 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,surenb@google.com,rppt@kernel.org,rientjes@google.com,david@redhat.com,baohua@kernel.org,anshuman.khandual@arm.com,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-nr_free_highatomic-in-show_free_areas.patch removed from -mm tree
Message-Id: <20250512005217.40A90C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add nr_free_highatomic in show_free_areas
has been removed from the -mm tree.  Its filename was
     mm-add-nr_free_highatomic-in-show_free_areas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: gaoxu <gaoxu2@honor.com>
Subject: mm: add nr_free_highatomic in show_free_areas
Date: Sat, 12 Apr 2025 09:27:24 +0000

commit c928807f6f6b6("mm/page_alloc: keep track of free highatomic")
adds a new variable nr_free_highatomic, which is useful for analyzing low
mem issues. add nr_free_highatomic in show_free_areas.

Signed-off-by: gao xu <gaoxu2@honor.com>
Link: https://lkml.kernel.org/r/d92eeff74f7a4578a14ac777cfe3603a@honor.com
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/show_mem.c~mm-add-nr_free_highatomic-in-show_free_areas
+++ a/mm/show_mem.c
@@ -305,6 +305,7 @@ static void show_free_areas(unsigned int
 			" low:%lukB"
 			" high:%lukB"
 			" reserved_highatomic:%luKB"
+			" free_highatomic:%luKB"
 			" active_anon:%lukB"
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
@@ -326,6 +327,7 @@ static void show_free_areas(unsigned int
 			K(low_wmark_pages(zone)),
 			K(high_wmark_pages(zone)),
 			K(zone->nr_reserved_highatomic),
+			K(zone->nr_free_highatomic),
 			K(zone_page_state(zone, NR_ZONE_ACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ZONE_ACTIVE_FILE)),
_

Patches currently in -mm which might be from gaoxu2@honor.com are


