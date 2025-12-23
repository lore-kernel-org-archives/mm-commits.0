Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3F3279DCC
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517868; cv=none; b=NpgKaTPNaO3u45zMRNuCu4AnEWAP7vHsiAaMGoDOB1Myd6ccR257JMqUTiNaq/456KYp2dQUlTkJP0rG5nhdcz2UVYEPOy2iQDqXIQotI5YBE9O3jj0SQPovlvdrLF8KrF9aAPunT3lWX0rnmqHd5+WONbEMnnJBT4uetmlqzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517868; c=relaxed/simple;
	bh=ekLCoP0q0hr5p2IRisvxpEfQr+cDKJXqH9slpXXwpVw=;
	h=Date:To:From:Subject:Message-Id; b=CvFGx3W50O62OmKBIr+elAA1ZJB3cUwd20kc9xYRpuUrJBvp8NhQYLUVQG/0tCfylFwaVqtOKNUxqNc9MG+1CzFNxtMCB4ogdnsDrIhdJQLt6QQYT22dZMPbzp5fZdi8m3lvmC7fit43dHqcB54zFZsTWyeuS+yoNACosGsTTXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G2lxdgV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G2lxdgV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F87C113D0;
	Tue, 23 Dec 2025 19:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517867;
	bh=ekLCoP0q0hr5p2IRisvxpEfQr+cDKJXqH9slpXXwpVw=;
	h=Date:To:From:Subject:From;
	b=G2lxdgV0NjOTkHVSv7JeIbSiaz2qMv3dHsZgafh5+vO4VnhpzQgzA+RTajzvR78qz
	 +Bg69fMENMAcB5uBqhkJm59C8vquIo/PG/piGu9QrZDdePYXFMYL2dCGuiWo4JR1dZ
	 plVj0/fLBLjvz5A6KQyzVkmANB2GgEI/kqSgQ+U0=
Date: Tue, 23 Dec 2025 11:24:27 -0800
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,osalvador@suse.de,jonathan.cameron@huawei.com,John@Groves.net,ira.weiny@intel.com,david@kernel.org,dave@stgolabs.net,dave.jiang@intel.com,alison.schofield@intel.com,dan.j.williams@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-notify-the-device-memory-community-of-memory-hotplug-changes.patch removed from -mm tree
Message-Id: <20251223192427.B2F87C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: notify the "Device Memory" community of memory hotplug changes
has been removed from the -mm tree.  Its filename was
     maintainers-notify-the-device-memory-community-of-memory-hotplug-changes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Acked-by: John Groves <John@Groves.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
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


