Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6B0F4FA
	for <mm-commits@vger.kernel.org>; Sat, 10 Jan 2026 22:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768085294; cv=none; b=hSW4c0nstQsD396o0SpNIK1kZgUZ4QfYkxDvA5i2DKippTc68hyyl779cymEWw7VDbz2LhiXGPFe8DeZiKCj2CzCnK/tVWz4tdr2iN2TpNba8BrixrNXeE7QPFPxBh7L15wPcmtwum5cYV0NUbw2xOKirwX7R0ylgsS+EYSRIUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768085294; c=relaxed/simple;
	bh=T4GG4qgwRPkE4t4ZzRkUaq52XBTf6nNmJpjT61Uo+fA=;
	h=Date:To:From:Subject:Message-Id; b=cPi1E18Co1XFLvDWV8/M2wfXou16p+ZOiyW0M70NwmOI4yV2/etkWS2DQsqpVt3Ui4T0OVo5hD4wzCjJ2gnusQGrNRvliv3Blc0bY2sA9BXCQXVPmUBS1aREO2N6Ht1Xwvu7pWaSBTFGUlVW5iZDa8edrfwPGkcSixOrqVM7XNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U9MHZq0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U9MHZq0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66AFC4CEF1;
	Sat, 10 Jan 2026 22:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768085294;
	bh=T4GG4qgwRPkE4t4ZzRkUaq52XBTf6nNmJpjT61Uo+fA=;
	h=Date:To:From:Subject:From;
	b=U9MHZq0AjkBKanGAQG4tjNP3zgrmBs7eWL4QSv+1nJnaBCXBNtrYtrgJwhkmzpdlm
	 FBavXZX6tQ0nk0i2YP+cxs67kOKID85srZ1+9rvHKTdXyeub+8ipa8bIEPvgJwgi7R
	 FSAwsAQV+3aKvv85ZVsebhuRqYKRxl9BJAeLrgaA=
Date: Sat, 10 Jan 2026 14:48:13 -0800
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,john@groves.net,joao.m.martins@oracle.com,dan.j.williams@intel.com,John@Groves.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + add-some-missing-kerneldoc-comment-fields-for-struct-dev_dax.patch added to mm-hotfixes-unstable branch
Message-Id: <20260110224813.E66AFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/dax: add some missing kerneldoc comment fields for struct dev_dax
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     add-some-missing-kerneldoc-comment-fields-for-struct-dev_dax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/add-some-missing-kerneldoc-comment-fields-for-struct-dev_dax.patch

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
From: John Groves <John@Groves.net>
Subject: drivers/dax: add some missing kerneldoc comment fields for struct dev_dax
Date: Sat, 10 Jan 2026 13:18:04 -0600

Add the missing @align and @memmap_on_memory fields to kerneldoc comment
header for struct dev_dax.

Also, some other fields were followed by '-' and others by ':'. Fix all
to be ':' for actual kerneldoc compliance.

Link: https://lkml.kernel.org/r/20260110191804.5739-1-john@groves.net
Fixes: 33cf94d71766 ("device-dax: make align a per-device property")
Fixes: 4eca0ef49af9 ("dax/kmem: allow kmem to add memory with memmap_on_memory")
Signed-off-by: John Groves <john@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax-private.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/dax/dax-private.h~add-some-missing-kerneldoc-comment-fields-for-struct-dev_dax
+++ a/drivers/dax/dax-private.h
@@ -67,14 +67,16 @@ struct dev_dax_range {
 /**
  * struct dev_dax - instance data for a subdivision of a dax region, and
  * data while the device is activated in the driver.
- * @region - parent region
- * @dax_dev - core dax functionality
+ * @region: parent region
+ * @dax_dev: core dax functionality
+ * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
  * @id: ida allocated id when the dax_region is not static
  * @ida: mapping id allocator
- * @dev - device core
- * @pgmap - pgmap for memmap setup / lifetime (driver owned)
+ * @dev: device core
+ * @pgmap: pgmap for memmap setup / lifetime (driver owned)
+ * @memmap_on_memory: allow kmem to put the memmap in the memory
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
_

Patches currently in -mm which might be from John@Groves.net are

add-some-missing-kerneldoc-comment-fields-for-struct-dev_dax.patch

