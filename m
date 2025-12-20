Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DBC24169D
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 19:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766260482; cv=none; b=J4jMkPA1IuGS8lfM+4yGUsE0qXsaJoKE5F+gSNAZWNBXMCtn13IpUtoj+VQl9E6kFQ99jGnzii1e0BEQijE2UwtRn42Xe27+7S6VKnGuJ9qOP0sIXmEgLiaGarGP5dH+gv7MJtsPyhvEQakF8aUNbVQUoGzABscHVfJirL7ct3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766260482; c=relaxed/simple;
	bh=Mgr+6u7tznCQchbDdCZzfma8Vb786kiocSHqPnIl7/c=;
	h=Date:To:From:Subject:Message-Id; b=Zmgfcd5nhMmtTueT0p9xh2/eKVdbufnaMHsSmbd2Z48KMiJKntdp6FMh920A13FLCuI0fVHijkRLOBxsKYx7P+loS6o1kRIeZTCWaUROfcEeOobAVNBMy9cYmP8HE5yvMOvPaS5GKRehKKkgmED2XRa4ANOvkiHaoIyOhROZOHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pMeriz11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pMeriz11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1B3C4CEF5;
	Sat, 20 Dec 2025 19:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766260481;
	bh=Mgr+6u7tznCQchbDdCZzfma8Vb786kiocSHqPnIl7/c=;
	h=Date:To:From:Subject:From;
	b=pMeriz11VpkuSiSmNYPGigqppBqQW8z97PCiT1nKgACq3QBVwidPcMwaz/GesSB1h
	 cFS4p9nT3WZZQ2vOiuIzmW5asE2LRLILHKup5PnZlzIDnr6xxTJcpTG5nm6DiwZrzc
	 xC35u5CwRGiGOmxLaN52Rweh7izrCoatm2m8OMCI=
Date: Sat, 20 Dec 2025 11:54:41 -0800
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,osalvador@suse.de,jonathan.cameron@huawei.com,John@Groves.net,ira.weiny@intel.com,david@kernel.org,dave@stgolabs.net,dave.jiang@intel.com,alison.schofield@intel.com,dan.j.williams@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-notify-the-device-memory-community-of-memory-hotplug-changes.patch added to mm-hotfixes-unstable branch
Message-Id: <20251220195441.9E1B3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: notify the "Device Memory" community of memory hotplug changes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-notify-the-device-memory-community-of-memory-hotplug-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-notify-the-device-memory-community-of-memory-hotplug-changes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: MAINTAINERS: notify the "Device Memory" community of memory hotplug changes
Date: Fri, 19 Dec 2025 16:03:27 -0800

The recent episode of a warning regression in memremap_pages() [1]
highlights that relevant updates are being missed by folks that care about
core ZONE_DEVICE changes.  Yes, CXL folks should pay more attention to
linux-mm@, but it also would not hurt to copy linux-cxl@, where most
Device Memory folks hang out, on memory hotplug changes by default.

Link: http://lore.kernel.org/20251219123717.39330-1-john@groves.net [1]
Link: https://lkml.kernel.org/r/20251220000327.3502994-1-dan.j.williams@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: John Groves <John@Groves.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-notify-the-device-memory-community-of-memory-hotplug-changes
+++ a/MAINTAINERS
@@ -16428,6 +16428,7 @@ MEMORY HOT(UN)PLUG
 M:	David Hildenbrand <david@kernel.org>
 M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
+L:	linux-cxl@vger.kernel.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/memory-hotplug.rst
 F:	Documentation/core-api/memory-hotplug.rst
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

maintainers-notify-the-device-memory-community-of-memory-hotplug-changes.patch

