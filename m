Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D3A171C9
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768281000; cv=none; b=dTO5fSxSN553DaynoSXUSJRT1IkKU9jaK2O6ln18C1PkN1rNtuoM+eSndvqFY5SoP19BkXs8m/WYhlKbbl3LdqL34T0FFF0T/326xpI1Rhhf1B6q8zCTe+c8FqBxsbX6e1gD5fz9DCg5w6RCP+RE4+ZrMT6amxCKplXJ76lohys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768281000; c=relaxed/simple;
	bh=MfMZKkEEpjuBJ67DVTsE3ojlioJ3/qRsQ16jGPC1OyQ=;
	h=Date:To:From:Subject:Message-Id; b=DF7wLcPk1S1lASLMA1WdZqlrbAmErG8tQlfjsx5v9X05BcQQjT9qTMqFGOyLYZPrCYAgkE4AbArrUfSj0r5Rz/PDCkOy4dk34j9xlgKMXnVmRNUL/Lc8mFoTxcN6qWpW1GU/7bLiVAiR4ELQfyV616jELnkX3G2X6fcfKd2SdUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KvUw2/NL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KvUw2/NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F213EC116C6;
	Tue, 13 Jan 2026 05:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768281000;
	bh=MfMZKkEEpjuBJ67DVTsE3ojlioJ3/qRsQ16jGPC1OyQ=;
	h=Date:To:From:Subject:From;
	b=KvUw2/NLuIlW9praTZIDAd0vaGEeEj/DQB+BJ0KnPCF1D0TebHsrg0AtLEpKnH5I2
	 tFfZzIPpq7AqhtdQ2Hw40c8iNjmF6uCciiSQkbKR/rjAhLfwDp17fCj5ac2UwZzlQ1
	 dLBE5rWvB7AzesCONAP06wmDFKAOaA8P37oTBkHY=
Date: Mon, 12 Jan 2026 21:09:59 -0800
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,john@groves.net,joao.m.martins@oracle.com,dan.j.williams@intel.com,John@Groves.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] add-some-missing-kerneldoc-comment-fields-for-struct-dev_dax.patch removed from -mm tree
Message-Id: <20260113050959.F213EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/dax: add some missing kerneldoc comment fields for struct dev_dax
has been removed from the -mm tree.  Its filename was
     add-some-missing-kerneldoc-comment-fields-for-struct-dev_dax.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


