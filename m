Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08761547F5
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619841; cv=none; b=nWJvV4TzfVBPCC7RnVLHOIronBCANLuEciiLuPxArVCF4QOF7cjHg9wTrXRGTimA2N22ZkIv/gSATsTrtOh0RD1s3N4iFxda5ECGzMoEhez+2wjR15euZeybPwMuy9/PHxR1WoWvqzgZkNgVDVzpRW7nFTGkUoRQ9I4BvGQqqHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619841; c=relaxed/simple;
	bh=GprA5L9dWLMPs6hRa2fT5r1ueay/T7eYUx81TscnyMI=;
	h=Date:To:From:Subject:Message-Id; b=jSwOwmrMP/0u1Ex+LT6nezqD6IkQJ89pJD/uqgj+MjxO2sArOPgk77RAfvq/5NYAG/xP0wLgegr1IaoWXz1YEjm/YK9KQPJnOnP6du4QSX8YUQ3ifiIb3K8WkpYwHobdoKub6x3MN8ejY5KaTYaZFOiQheIDw7mG0HIQgwS1Z9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=drhyguVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="drhyguVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40E9C4CEDD;
	Sat, 22 Mar 2025 05:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619841;
	bh=GprA5L9dWLMPs6hRa2fT5r1ueay/T7eYUx81TscnyMI=;
	h=Date:To:From:Subject:From;
	b=drhyguVUxCzSOncm6/N/N9wJ5UHpez9qwNxn/NE1ZU+TSz2LCDUZ921CXFs+6ySnY
	 ApJcI+5TS4JhJpVMZ64sxf20H3OgjyF12dxG3LtGQRLVBIoMbms03HNzsE5NODY76y
	 5fp51xldnoy+dSLGOlBqit1Sg4CQDceOEo1U/HSU=
Date: Fri, 21 Mar 2025 22:04:01 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,sstabellini@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,oleksandr_tyshchenko@epam.com,nphamcs@gmail.com,muchun.song@linux.dev,mst@redhat.com,mhocko@kernel.org,mhklinux@outlook.com,kys@microsoft.com,kanchana.p.sridhar@intel.com,jgross@suse.com,hannes@cmpxchg.org,haiyangz@microsoft.com,decui@microsoft.com,david@redhat.com,chengming.zhou@linux.dev,alexander.atanasov@virtuozzo.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xen-balloon-update-the-nr_balloon_pages-state.patch removed from -mm tree
Message-Id: <20250322050401.A40E9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xen: balloon: update the NR_BALLOON_PAGES state
has been removed from the -mm tree.  Its filename was
     xen-balloon-update-the-nr_balloon_pages-state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: xen: balloon: update the NR_BALLOON_PAGES state
Date: Fri, 14 Mar 2025 15:37:57 -0600

Update the NR_BALLOON_PAGES counter when pages are added to or removed
from the Xen balloon.

Link: https://lkml.kernel.org/r/20250314213757.244258-5-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Juegren Gross <jgross@suse.com>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/balloon.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/xen/balloon.c~xen-balloon-update-the-nr_balloon_pages-state
+++ a/drivers/xen/balloon.c
@@ -157,6 +157,8 @@ static void balloon_append(struct page *
 		list_add(&page->lru, &ballooned_pages);
 		balloon_stats.balloon_low++;
 	}
+	inc_node_page_state(page, NR_BALLOON_PAGES);
+
 	wake_up(&balloon_wq);
 }
 
@@ -179,6 +181,8 @@ static struct page *balloon_retrieve(boo
 		balloon_stats.balloon_low--;
 
 	__ClearPageOffline(page);
+	dec_node_page_state(page, NR_BALLOON_PAGES);
+
 	return page;
 }
 
_

Patches currently in -mm which might be from npache@redhat.com are


