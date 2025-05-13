Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557861EEA46
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119304; cv=none; b=hV/gtOYVCDcXOsGlxkHec5itArDjTUOcfagDZKNYkiaNY5/E4eoBpjw8RrNUOwcYjZG/rtFTSO1nHkwb1T2EI1tBJkSRfHFFPpWM+Uaup0OxLAg3EtVgRdxr+MtgEZfV9GAtv44ymBFckgK31d9XifSBIIMLzNlEAo7qAzsxbdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119304; c=relaxed/simple;
	bh=0E2vufiqaqmqSRyfhrokdTRffFYTsAyOHxgJbRc01e4=;
	h=Date:To:From:Subject:Message-Id; b=oxm5QsitA+P9aGS6ruCjTL4mZRMm0GMOxaT8PN6YTmKpiWSJ1An3ikQzLlaIfCFQMK3TLEZMDL84bqndPMBaudg4cO02hyqe1ngdGIbw7/X8OfGwLvR/7qeLq82RD+PoGbghh4gvZeRi2+MQWdfgXp2FSwxZxZQl3xbvmr6NTGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6ONEzha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6ONEzha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2504DC4CEED;
	Tue, 13 May 2025 06:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119304;
	bh=0E2vufiqaqmqSRyfhrokdTRffFYTsAyOHxgJbRc01e4=;
	h=Date:To:From:Subject:From;
	b=H6ONEzhaqi38yhybN036IlwKoxbB0IAr4ZWpmIunWvwCK6KBGlHLSDXqZDBM3rAVg
	 PK2pa16I7raeVNhJqasZ5d54yl/JpWtMmv5JIOO1ug4J7CJ4/lvRAHEfP1r9onBuwk
	 cqaae2UFtd5CZNiiAz9mNH5Mb9a6jerJcC6BZCfc=
Date: Mon, 12 May 2025 23:55:03 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,catalin.marinas@arm.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-mark-variables-as-__read_mostly.patch removed from -mm tree
Message-Id: <20250513065504.2504DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: mark variables as __read_mostly
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-mark-variables-as-__read_mostly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: kmemleak: mark variables as __read_mostly
Date: Wed, 30 Apr 2025 16:59:47 -0400

The variables kmemleak_enabled and kmemleak_free_enabled are read in the
kmemleak alloc and free path respectively, but are only written to if/when
kmemleak is disabled.

Link: https://lkml.kernel.org/r/4016090e857e8c4c2ade4b20df312f7f38325c15.1746046744.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-mark-variables-as-__read_mostly
+++ a/mm/kmemleak.c
@@ -210,9 +210,9 @@ static struct kmem_cache *object_cache;
 static struct kmem_cache *scan_area_cache;
 
 /* set if tracing memory operations is enabled */
-static int kmemleak_enabled = 1;
+static int kmemleak_enabled __read_mostly = 1;
 /* same as above but only for the kmemleak_free() callback */
-static int kmemleak_free_enabled = 1;
+static int kmemleak_free_enabled __read_mostly = 1;
 /* set in the late_initcall if there were no errors */
 static int kmemleak_late_initialized;
 /* set if a fatal kmemleak error has occurred */
_

Patches currently in -mm which might be from luizcap@redhat.com are


