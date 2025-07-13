Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9025686340
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752449445; cv=none; b=syB2FphfUWRPkw9xxB3QWxJeP0NUKP7L3AsfWwdH2rD5JIipLy0SOgxRLjPu8uuixu51szU3vj7HN9ZzJ4tRCVn4PE+ps+oK5B/C0y3US2xaIXSGBHOoAhRYtVexQ/RqyMruTrY4Fk8kDH2w/i490xt4TblKBgMUEaDuty0c1Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752449445; c=relaxed/simple;
	bh=WRAzjgD75ePnp9s/YwwIO/GLIcLbUN/VjNRC5fRzp3A=;
	h=Date:To:From:Subject:Message-Id; b=DLY4JdT9vvJFJ00P9pSrPyD+3YswBOnWTZCZW4ZzArZMphe2691QRrUiCz7yYbGrSmzQrbORc1Ur1/ggjOTZDeyuFOyJB6o8daYqmd7mGMVuNEshikVz0LhTo/GuQ3Mg7tr/3Ms3s5nrA7Mkq/fsFiEUK1AGPWXcOcVCNMc8Esg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qJ4l1dtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qJ4l1dtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2FBC4CEE3;
	Sun, 13 Jul 2025 23:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752449445;
	bh=WRAzjgD75ePnp9s/YwwIO/GLIcLbUN/VjNRC5fRzp3A=;
	h=Date:To:From:Subject:From;
	b=qJ4l1dtlBKyFYzYpRmdUY2XFEHEW6r+ovzLfgNJjA/4MZ70XA5U2RUF7iXJInBYfC
	 rrNJ1T521VEl1aWszVy6KY1Ljug3h3/jLnSQFq+mMTXcry28xW/bELqm/OOBVV9CtI
	 1wrvKMCGu2GkgTjmT0UOrliptmkDzsLZxtvD7tNo=
Date: Sun, 13 Jul 2025 16:30:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mmmemory_hotplug-implement-numa-node-notifier-fix.patch removed from -mm tree
Message-Id: <20250713233045.0A2FBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,memory_hotplug: set failure reason in offline_pages()
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-implement-numa-node-notifier-fix.patch

This patch was dropped because it was folded into mmmemory_hotplug-implement-numa-node-notifier.patch

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
@@ -1985,8 +1985,10 @@ int offline_pages(unsigned long start_pf
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

mmmemory_hotplug-implement-numa-node-notifier.patch

