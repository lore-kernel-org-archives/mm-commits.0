Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11663BA235
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439118; cv=none; b=q9hhkh3ELvUkSpoHqBix5IX6QQdu4xvC4+hku0rKg6B8MPE7yA7gnPeoYsKC5kEYyskzk1romxhiufilZWsrNsucm7HzYS4YM+b1Y+wIr7bv6yWAzNMpJPN1JyTjyMTIindkmw3tZuPRWibGLU/MISgcDXv6eOsjvPh7sUmhbJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439118; c=relaxed/simple;
	bh=MRZqAEVSI3+AbtA8UE8uiYpWWOUvx8lHcKAIXqNbdog=;
	h=Date:To:From:Subject:Message-Id; b=JA7uCcUyOkkXUvE04/2BqnaC5Cpmvi4Umgtxp5FU+vaD7/2RtQXFYAuTHdyMAASmnHVnKy/9gyLuYScdZE97S1WToZi7ltM9mqXCwJYjrVuXfK1xrkHWS+o9nlTTUZrY+sGYLPHux5/SIzD/RGRCtMBaL9W5qoVBZncp8P67/c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FwuGDglI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FwuGDglI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756D31F00893;
	Tue,  2 Jun 2026 22:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439117;
	bh=vqAas2FN0SOAfbV7H9DxDvEzXkVKzw7A/36MSnUNt68=;
	h=Date:To:From:Subject;
	b=FwuGDglIpKtLp+Awqoslph9M/es+HYdlodEL4Q4Zln0wGUzEVkUmRAGpOYwO6uDuG
	 gQwGvdZVXLowksO+oBazaY+i14a3nMKLrwr39JDAM+/TO7ihX68gpsk7ll9W5U1ahW
	 0uOLhDUMpkWt+yOxpmGtwAdL4JTUWvcu21SVglQo=
Date: Tue, 02 Jun 2026 15:25:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-update-for-memcg-damon-filter.patch removed from -mm tree
Message-Id: <20260602222517.756D31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: update for memcg damon filter
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-update-for-memcg-damon-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: update for memcg damon filter
Date: Mon, 18 May 2026 16:41:15 -0700

Update DAMON design document for the newly added belonging memory cgroup
attribute monitoring feature.

Link: https://lore.kernel.org/20260518234119.97569-28-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-memcg-damon-filter
+++ a/Documentation/mm/damon/design.rst
@@ -293,8 +293,8 @@ registration is made by specifying a pro
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` filter type is supported for data
-attributes monitoring.
+filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
+for data attributes monitoring.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

