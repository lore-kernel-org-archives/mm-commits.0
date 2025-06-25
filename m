Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296D42DAFA0
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 20:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750883339; cv=none; b=Wee7U1Ub0OFY6s6dSSm/vS7XEOkrHMlc1NrdJp2Pyqo4AbUtvCJA39TIT1lhahXVYtBwduhEw+ZvIiUYAyXgTZDPmH4D4r50xWEQ6co7aN+27VTHxwRe/HXDyZEeXoBJy6/W6qq7Mxh+zskAEq12o2Q+VdkZRLlvNw3+jNXdg4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750883339; c=relaxed/simple;
	bh=7S8hd9UmntyCN3wwD8MwiUICpXu3x67w63rsMljf5Eo=;
	h=Date:To:From:Subject:Message-Id; b=bwa2aW0prW+GWJxVcgE0A4oRiMrpM8Vd1OfrQGgGBpVFWlkSssZ1hRRZaGtWrqezJrRs8QXUp6r/9YxblOBwbNpNhcJJJtNQPNQj5xkSdiDkkfuC42xf735U7t5P2JM8ZzNBAZUGFn2R0s+pSr5eJrWdYn5K8+S8zg5smChj+7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o47EMY4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o47EMY4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F8DC4CEEA;
	Wed, 25 Jun 2025 20:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750883338;
	bh=7S8hd9UmntyCN3wwD8MwiUICpXu3x67w63rsMljf5Eo=;
	h=Date:To:From:Subject:From;
	b=o47EMY4hlfIqMKdpefZVDVy5KhvMmtINCNhghnq7j8ddR7s7Yg7k4+qU/AQxNvB8o
	 oVm6Rn4pEOmYrBAnmH+eV4IkfuxGDBf9FwVxjNDUrG+WqIYGrlXdVJHhOxg3358SUF
	 RFHo16s+fGi56Y53BiIRjar82SNiD0a/PeBTZvBw=
Date: Wed, 25 Jun 2025 13:28:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmmemory_hotplug-implement-numa-node-notifier-fix.patch added to mm-unstable branch
Message-Id: <20250625202858.D4F8DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,memory_hotplug: set failure reason in offline_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mmmemory_hotplug-implement-numa-node-notifier-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmmemory_hotplug-implement-numa-node-notifier-fix.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm,memory_hotplug: set failure reason in offline_pages()
Date: Wed, 25 Jun 2025 10:32:04 -0500

The "reason" variable is uninitialized on this error path.  It's supposed
to explain why the function failed.

Link: https://lkml.kernel.org/r/be4fd31b-7d09-46b0-8329-6d0464ffa7a5@sabinyo.mountain
Fixes: e4e2806b639c ("mm,memory_hotplug: implement numa node notifier")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mmmemory_hotplug-implement-numa-node-notifier-fix
+++ a/mm/memory_hotplug.c
@@ -1978,8 +1978,10 @@ int offline_pages(unsigned long start_pf
 		mem_arg.status_change_nid = node;
 		ret = node_notify(NODE_REMOVING_LAST_MEMORY, &node_arg);
 		ret = notifier_to_errno(ret);
-		if (ret)
+		if (ret) {
+			reason = "node notifier failure";
 			goto failed_removal_isolated;
+		}
 	}
 
 	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

mmmemory_hotplug-implement-numa-node-notifier-fix.patch

