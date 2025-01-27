Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735051DC998
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 23:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738019340; cv=none; b=VO7m+wKNyoHGZvix//geJOj+SdQR2pbnUbfpoCcQC9fj6X4Q2j64OIsmu9IKlykrvEFW5+IrDfJu1RwT/PWFPu3P5BHPsdO0bf60BJrT3GUf28lQbCJAppOnNTv7Xqg94TbJ1EzDOHrKlwwaGHKIvt5FbOF0w4YNoQQd5RQtQrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738019340; c=relaxed/simple;
	bh=iaLX28LzISQl9n43A5uMdTabPrv3bikaW8gBZlz4Esw=;
	h=Date:To:From:Subject:Message-Id; b=M/GO4pRspkkC9titd0+VDVdNNfmzyvmnY1Fa9/rLH/k2892WGL4XhggvJEEhTlQKjCyLYyGBpMfc6CT4nHkD1xJpQf0UKsnGEw3+bMNXGoCPplpWrF0uUYcFZm4kM4HxxObsG8q+a1LV3oK0Q5G0cjj8evbrdkmlTWxMRr0EuGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mFSg9CvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mFSg9CvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6CEC4CED2;
	Mon, 27 Jan 2025 23:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738019339;
	bh=iaLX28LzISQl9n43A5uMdTabPrv3bikaW8gBZlz4Esw=;
	h=Date:To:From:Subject:From;
	b=mFSg9CvRm93dnmmeBNM+QsZD7Rft2UX31UGZ0/tTHX6k+yYXsuH8dE7HEPSdwqTQn
	 ND5lquFTxu63DJuhLksF9HZu5Pm3RxGeQ1aWJoYDikeTJjbs4NoPWRi9TXqmjM6kP3
	 7ABu/6pJcWLt7+tQW5IESCs4kOoBpEgZdUP4y0K8=
Date: Mon, 27 Jan 2025 15:08:59 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,wangweiyang2@huawei.com,vbabka@suse.cz,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,davidf@vimeo.com,chenridong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-ofp_peak_unset-instead-of-1.patch added to mm-unstable branch
Message-Id: <20250127230859.CE6CEC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use OFP_PEAK_UNSET instead of -1
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-use-ofp_peak_unset-instead-of-1.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-ofp_peak_unset-instead-of-1.patch

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
From: Chen Ridong <chenridong@huawei.com>
Subject: memcg: use OFP_PEAK_UNSET instead of -1
Date: Fri, 24 Jan 2025 07:35:11 +0000

Patch series "Some cleanup for memcg", v4.


This patch (of 4):

The 'OFP_PEAK_UNSET' has been defined, use it instead of '-1'.

Link: https://lkml.kernel.org/r/20250124073514.2375622-1-chenridong@huaweicloud.com
Link: https://lkml.kernel.org/r/20250124073514.2375622-2-chenridong@huaweicloud.com
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: David Finkel <davidf@vimeo.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-use-ofp_peak_unset-instead-of-1
+++ a/mm/memcontrol.c
@@ -4004,7 +4004,7 @@ static ssize_t peak_write(struct kernfs_
 			WRITE_ONCE(peer_ctx->value, usage);
 
 	/* initial write, register watcher */
-	if (ofp->value == -1)
+	if (ofp->value == OFP_PEAK_UNSET)
 		list_add(&ofp->list, watchers);
 
 	WRITE_ONCE(ofp->value, usage);
_

Patches currently in -mm which might be from chenridong@huawei.com are

memcg-use-ofp_peak_unset-instead-of-1.patch
memcg-call-the-free-function-when-allocation-of-pn-fails.patch
memcg-factor-out-the-replace_stock_objcg-function.patch
memcg-add-config_memcg_v1-for-local-functions.patch

