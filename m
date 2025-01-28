Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D681465B8
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 01:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738029595; cv=none; b=nceWhQP294VvmJgvrLRDjnrxE8aXquiqtzjtmgdedkSwvTn9YUMzPYfoSUYvRoAOolTOY8yc3BSstnBT2+DIYrTx1sc4uLIS5dFG0At3G1VD3u5DMUwNgXDY+YuOAIK9r2rz0PbA6TZQ/EJulGESIRlkTms+VExjDIIFsUwNY+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738029595; c=relaxed/simple;
	bh=bV90GGgGpeHMfpvrrj32iWQU1rGnAkzjIvI4ZWwmY6k=;
	h=Date:To:From:Subject:Message-Id; b=Fbg0NqFAUDygOJPXtaScGYHKWWJJ0HwvoZU7GHPVGwKh4IbvfjDTkIeKAGgcMfBxgIO1TsC5jdrnQKsazWKopJLvM59I8G3zg7rNG0FfZjQvG+mhhProfk9PW4UKtSm8LFzponb5chrS9cnXJvJ4UjferaaO31NXbG2ZVVVSKR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ydwxLjUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ydwxLjUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96510C4CED2;
	Tue, 28 Jan 2025 01:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738029594;
	bh=bV90GGgGpeHMfpvrrj32iWQU1rGnAkzjIvI4ZWwmY6k=;
	h=Date:To:From:Subject:From;
	b=ydwxLjUjb+jAah3/EydQ9635xSABCFnNgjWXm0gQinZXHXKJwpLUUHL+zVAM3mYo4
	 tldxrvpilpCQZmzA75YhiiEE+Rw3V3FUS4bw3pdGK/9uC+YxSshoc+O/uJpC3dMIKA
	 pJ+HFLz1bCUTbOf3AESvNKxBuRNY6z6MA+yrxidk=
Date: Mon, 27 Jan 2025 17:59:54 -0800
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,david@redhat.com,ruansy.fnst@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-simplify-outputting-of-valid_zones_show.patch added to mm-unstable branch
Message-Id: <20250128015954.96510C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/memory: simplify outputting of valid_zones_show()
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-base-memory-simplify-outputting-of-valid_zones_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-memory-simplify-outputting-of-valid_zones_show.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: drivers/base/memory: simplify outputting of valid_zones_show()
Date: Wed, 8 Jan 2025 09:52:23 +0800

No need to specify position at the first writing to the buf because the
@len is always 0 at this time.  Use sysfs_emit() instead to simplify it. 
Also avoid setting/checking default_zone with a conditional operator.

Link: https://lkml.kernel.org/r/20250108015223.1522887-1-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-simplify-outputting-of-valid_zones_show
+++ a/drivers/base/memory.c
@@ -455,7 +455,7 @@ static ssize_t valid_zones_show(struct d
 	struct memory_group *group = mem->group;
 	struct zone *default_zone;
 	int nid = mem->nid;
-	int len = 0;
+	int len;
 
 	/*
 	 * Check the existing zone. Make sure that we do that only on the
@@ -466,22 +466,18 @@ static ssize_t valid_zones_show(struct d
 		 * If !mem->zone, the memory block spans multiple zones and
 		 * cannot get offlined.
 		 */
-		default_zone = mem->zone;
-		if (!default_zone)
-			return sysfs_emit(buf, "%s\n", "none");
-		len += sysfs_emit_at(buf, len, "%s", default_zone->name);
-		goto out;
+		return sysfs_emit(buf, "%s\n",
+				  mem->zone ? mem->zone->name : "none");
 	}
 
 	default_zone = zone_for_pfn_range(MMOP_ONLINE, nid, group,
 					  start_pfn, nr_pages);
 
-	len += sysfs_emit_at(buf, len, "%s", default_zone->name);
+	len = sysfs_emit(buf, "%s", default_zone->name);
 	len += print_allowed_zone(buf, len, nid, group, start_pfn, nr_pages,
 				  MMOP_ONLINE_KERNEL, default_zone);
 	len += print_allowed_zone(buf, len, nid, group, start_pfn, nr_pages,
 				  MMOP_ONLINE_MOVABLE, default_zone);
-out:
 	len += sysfs_emit_at(buf, len, "\n");
 	return len;
 }
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

drivers-base-memory-simplify-outputting-of-valid_zones_show.patch

