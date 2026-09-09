Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0887A4825C4
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788993464; cv=none; b=rOyi5hCpVzX9A1J1l8abf7tdfJLOerp+VSchdIsvzt60mJUWebdZ4SfXuLP/9U1blZPdC7PHFN8Wp/JXK8kbn2GnleHUtr45IkdjXC0+4feXtKcvEb1R4hU6OGJ1AvttVtNKB1IyjV67DlhcuVnbc1h5G/lOoyHaNkFc/fySZik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788993464; c=relaxed/simple;
	bh=5Nr7t7NTNGu3OIsS0a4tonV9VLK6o5kvGaMLOeiJo8I=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Bf7uqAMRnyK0OVPY3q50q1qnJjGFOzjnYZNASkQL9yr9XkJd/SFLj9h40NVx92S45digdQR14cTYayTWAN1Ze0gB7qjgF0Q5PHeo8wzg8mo+WlZHMS/aVY1FiXm4eRv0XNRFbb2vHQv+ahyeE9Ixxff6lXIYKqu086W7fWexjHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krP9gce9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krP9gce9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AEB1F000FF;
	Wed,  9 Sep 2026 22:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788993413;
	bh=G1qBdSpwsZDx9917VKBaeIKL8pVnAWB5+0VSGaiWxVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=krP9gce9sViQZ9kWxwxUg8BfupMM4UwEYvgfsqyijIDlIk0ZmOyYCe//9fsrdWYDG
	 Bzu7543h/RoNqhrtZsvqitKdj0M55aPL8JDjB0E6UxaOKnn5V7+UmwPP9MgOiTzIJL
	 OyQXxTggDoZVEOERpjqvZy0cxh7ir7csGMd3VzSc=
Date: Wed, 9 Sep 2026 15:36:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Muchun Song
 <muchun.song@linux.dev>, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 0bffe67ab8a72b3725cc31c4b525709bd3a3e223
Message-Id: <20260909153653.9e19f1d1f61a080d5bd6d2e5@linux-foundation.org>
In-Reply-To: <202609100517.0DrzxrW4-lkp@intel.com>
References: <202609100517.0DrzxrW4-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Sep 2026 05:56:22 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 0bffe67ab8a72b3725cc31c4b525709bd3a3e223  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202609100351.ALNh2KwC-lkp@intel.com
> 
>     include/linux/mmzone.h:1692:10: error: call to undeclared function 'NODE_DATA'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     include/linux/mmzone.h:1692:26: error: member reference type 'int' is not a pointer
>     include/linux/mmzone.h:1780:35: error: conflicting types for 'NODE_DATA'
> 
> Error/Warning ids grouped by kconfigs:

Thanks.  That's Muchun's "mm/sparse-vmemmap: switch device DAX to
shared tail vmemmap pages" not liking CONFIG_NUMA=n.

I'll try this nasty thing for now.  Muchun, please make it less nasty!

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

