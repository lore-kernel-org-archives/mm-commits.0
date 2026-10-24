Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832278;
	b=EkrxC3DTnBmomCq7V5/e5w+h5lADEJR53aAj4QOnlU4nJ8r7ubkbxhDLLUs0/XePdjzG
	 mjz+JFWzDB9mtLUANZaq0vo3fmB93uVFkcGxFAQATTkAla9fJcxDGgNkXa5JTjR0thJEt
	 RIny2RXHPrUqRIRyUr4639WXGsoAbyh6drmXkRSKtuE1XztXuoaQvtwbqtJWMhZhiKhG6
	 VeyXf6DtOFEX3/I4WyBdhDuVKhMK0GJX1l5rzJ7Gx0zFAP+nYKXzPvPJYPaLLOKHqp0I6
	 34rJz1Wo6FW8B+/tdgXmFdb8bsIqSQ9OHcveHZS0h1ZVGpiiNC01CDl4Kqv9EeH9Icg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832278;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=S0uVukROr4J0w6dwxHCACUCHwsb/WVK1XKHNoUFycSg=;
	b=b0QpoHkPBtqB+U7O4s2m3E/oDLT0/TqtsGHq4PkydbhNwFTQTj7G8mlwgIJWrCHLAf0a
	 qK2YdgyPLjaT7hGU6g6EbVUc4GNZzYYi0oN7/cIi0ulzL75ADsLL/tp5VzCpIEarov//v
	 lymqtz/wbKRuKhGm9i8VdXM32c/et/GUeb80dhLhRIVS9/rMpgT008Lk7FfHD9g/JnyZ6
	 DpsAJFh6MdLZqT6UXbTExmzbnlHG+Dqe3F1C38zmsxw3m+89sq2zfQ1WxbXBNFo+14KO7
	 tA0QtTFJlviqlfiqWRS4yDHgTM8PGRQBLwI9qHoAPoq/yAxOLlPPGAX1iBvsZm1PMSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uXFnX2yk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8F9606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uXFnX2yk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9661F01825;
	Sat, 24 Oct 2026 08:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832278;
	bh=S0uVukROr4J0w6dwxHCACUCHwsb/WVK1XKHNoUFycSg=;
	h=Date:To:From:Subject;
	b=uXFnX2ykNS+lm8r4ynS9/9yN02JSx9GErR4Z6VUv8ioJhW7tW5RHDhbmBaCyIhI9P
	 hMmOY5IpS+ttULrQXq017k1OsnDH7NWmkXXQ+0h3rBlGBuNtPmdfBflzi4SanjMj0m
	 0pywDyv7EFkkuAv1jK7ezR+IThw2GiUx8KaJsZ6c=
Date: Sat, 24 Oct 2026 01:57:57 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,qi.zheng@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,kas@kernel.org,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-unused-zone-unaccepted_cleanup.patch removed from -mm tree
Message-Id: <20261024085757.EF9661F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove the unused zone->unaccepted_cleanup
has been removed from the -mm tree.  Its filename was
     mm-remove-the-unused-zone-unaccepted_cleanup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: remove the unused zone->unaccepted_cleanup
Date: Thu, 24 Sep 2026 12:11:03 -0700

Commit fefc07518227 ("mm/page_alloc: fix race condition in unaccepted
memory handling") removed the zones_with_unaccepted_pages static key and
the work that decremented it, but left the work_struct behind in struct
zone.  Nothing uses it anymore, so let's remove it.

Link: https://lore.kernel.org/20260924191103.3475117-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 include/linux/mmzone.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/mmzone.h~mm-remove-the-unused-zone-unaccepted_cleanup
+++ a/include/linux/mmzone.h
@@ -1077,9 +1077,6 @@ struct zone {
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	/* Pages to be accepted. All pages on the list are MAX_PAGE_ORDER */
 	struct list_head	unaccepted_pages;
-
-	/* To be called once the last page in the zone is accepted */
-	struct work_struct	unaccepted_cleanup;
 #endif
 
 	/* zone flags, see below */
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-zswap-use-separate-compression-and-decompression-requests.patch
mm-zswap-use-stack-requests-for-synchronous-decompression.patch

