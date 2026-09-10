Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6581DB92C
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 05:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789018399; cv=none; b=i//Phn/9kQgXLphfYOHrkEmPVAhiq+mhISFVfxo95OPjSNJIQzJ8BkiGY10twysScYBU6tGpzkRwfW71AlLBdSc4tZuSqw5UlVOwbwoJjEsYAfNe6WjvRqMVaaQKPHoZrWB5XFGBEJ3pjLQ0/DlQS2byceCHjUs/QWQMIRnJ+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789018399; c=relaxed/simple;
	bh=ZuUPs4vI780UvxWNO7oVGCnUkuJ0KySA4EfNCwAeG9k=;
	h=Date:To:From:Subject:Message-Id; b=JsfsVFT+ZjKHgQ2tZHJUSz3/2CE6YEc9s9zO9I7s2Pi32Rj4nB8hK3vXvvZnyTZyJpRG7198V87jic7m+EcPc/X40zJ6Vbt9e/d7eHe7e7AUSMnaEOvhRQY3ciBIBxgcNBvkd+RJDW7GLqWM7bvDQoYnlBr/5gsjfarRmjy7ijI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQ3U0fzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQ3U0fzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4921F000FF;
	Thu, 10 Sep 2026 05:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789018398;
	bh=L2eKVOVY15BHC9OG8iNUNerZrSKV8cDl4dswxtes09k=;
	h=Date:To:From:Subject;
	b=nQ3U0fzlx+7sa2jvHJkv5mbRMYmrJdf4mmjsQKJmDt7izvjGowyR0SFWxGtpLPsJs
	 G/5h0F4Cw6fDx2/uytBAT9iXVkVc5TADaW4eIe7+5LkUSS6D7CnlnrUQv4hURjBUSl
	 xL9/n18a6b59O5gnpQlKn7abx8I9U9p7qunna1oQ=
Date: Wed, 09 Sep 2026 22:33:17 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch removed from -mm tree
Message-Id: <20260910053318.1D4921F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
Date: Wed Sep  9 03:33:07 PM PDT 2026

hack around build error

https://lore.kernel.org/202609100517.0DrzxrW4-lkp@intel.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/mmzone.h~mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
+++ a/include/linux/mmzone.h
@@ -1687,16 +1687,20 @@ static inline bool zone_is_zone_device(c
 	return zone_idx(zone) == ZONE_DEVICE;
 }
 
+#ifdef CONFIG_NUMA
 static inline struct zone *device_zone(int nid)
 {
 	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 }
+#endif
 #else
 static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return false;
 }
+#endif
 
+#if !defined(CONFIG_ZONE_DEVICE) && !defined(CONFIG_NUMA)
 static inline struct zone *device_zone(int nid)
 {
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

