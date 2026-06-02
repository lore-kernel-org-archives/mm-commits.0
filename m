Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C493C37BD;
	Tue,  2 Jun 2026 22:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439127; cv=none; b=ngmxPaQRSg6aJcIG/P1oRg3DthvwfikVYBMTWLAeOY0cQzwUHZUWDQXlrZ2AoOloDUYOLZoWmj2+gWBZAePTFNkmcrbrgGPmUzbVUg43YGxzVsbBsmTCVIR612MEMDYYL3cotQb4xTBmAiRtRIOJWFjrZ391kGx5QUlYtD1dtr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439127; c=relaxed/simple;
	bh=3SkRT+UFxHrKgNVjhsR7L0IKxkTpWHk/XbgCujmvnMY=;
	h=Date:To:From:Subject:Message-Id; b=tHn2+Fw5v3nBluk9AkiDkQkPCJMEi8HVsf5RAa6PFpnG3ClN27syZ7uMZVgHUrlUnHaP8yJ/oqTQaKm14HYuzYJfKExtGI8d+VyXSzJw76vNkVoYFS1ft1PEpqbKaCRgwCvUitbIxawGfOb/HDE98FVHVQSQeKJ7ZDkkKhyefgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZYF1Ekxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZYF1Ekxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A97E1F00898;
	Tue,  2 Jun 2026 22:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439126;
	bh=vUTlZ9WIcewarp0dujyeKsrIDM1ICFDV6BrEERvCYik=;
	h=Date:To:From:Subject;
	b=ZYF1EkxyLLWMNLa6SCLi197R2lp/ObaOLDcdljKvQ1NB7lB1w2QDMWFbBC6EZNjEX
	 aNZK9HEtomJ7Tq0DCwKe1hd04D07xW51/Yde/HIdtdzZTpjyykJa3y78YPzPW/xTtE
	 nrMN5EHHQmYsBnllU4yyiBCyqjJ+3hfeygBz2Wq0=
Date: Tue, 02 Jun 2026 15:25:25 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,stable@vger.kernel.org,rppt@kernel.org,rafael@kernel.org,osalvador@kernel.org,icheng@nvidia.com,gregkh@linuxfoundation.org,djakov@kernel.org,david@kernel.org,georgi.djakov@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-memory-set-mem-altmap-after-successful-device-registration.patch removed from -mm tree
Message-Id: <20260602222526.0A97E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: set mem->altmap after successful device registration
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-set-mem-altmap-after-successful-device-registration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Subject: drivers/base/memory: set mem->altmap after successful device registration
Date: Thu, 14 May 2026 02:26:57 -0700

If __add_memory_block() fails at xa_store() (under memory pressure for
example), device_unregister() is called, which eventually triggers
memory_block_release() with mem->altmap still set, causing a
WARN_ON(mem->altmap).  This was triggered by modifying virtio-mem driver.

Fix this by delaying the assignment of mem->altmap until after
__add_memory_block() has succeeded.

Link: https://lore.kernel.org/20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com
Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
Signed-off-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Richard Cheng <icheng@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/memory.c~drivers-base-memory-set-mem-altmap-after-successful-device-registration
+++ a/drivers/base/memory.c
@@ -797,7 +797,6 @@ static int add_memory_block(unsigned lon
 	mem->start_section_nr = block_id * sections_per_block;
 	mem->state = state;
 	mem->nid = nid;
-	mem->altmap = altmap;
 	INIT_LIST_HEAD(&mem->group_next);
 
 #ifndef CONFIG_NUMA
@@ -815,6 +814,8 @@ static int add_memory_block(unsigned lon
 	if (ret)
 		return ret;
 
+	mem->altmap = altmap;
+
 	if (group) {
 		mem->group = group;
 		list_add(&mem->group_next, &group->memory_blocks);
_

Patches currently in -mm which might be from georgi.djakov@oss.qualcomm.com are


